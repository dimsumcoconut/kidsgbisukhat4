import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Izin {
  final String? nama;
  final String? status;

  Izin({this.nama = "", this.status = ""});
}

class Minggu4 extends StatefulWidget {
  const Minggu4({Key? key}) : super(key: key);

  @override
  State<Minggu4> createState() => _Minggu4State();
}

class _Minggu4State extends State<Minggu4> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('users')
      .where('jabatan', isEqualTo: 'Guru')
      .snapshots();

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  final CollectionReference tugasCollection =
      FirebaseFirestore.instance.collection('tugas_pel');

  final CollectionReference izinCollection =
      FirebaseFirestore.instance.collection('izin3');

  // Future<List<String>> alluser () async {
  //   List <String> data = await usersCollection.get().then((value) => value.docs.map((e) => print(e)).toList());

  // }

  void izinMinggu4() async {
    await izinCollection.get().then((value) => value.docs.map((e) {
          izin.add(Izin(nama: e['nama'], status: e['status']));
        }).toList());
    print(izin);
  }

  alluser() async {
    await usersCollection.get().then((value) => value.docs.map((e) {
          if (e['jabatan'] == 'Guru') {
            nama.add(e['nama']);
            setState(() {});
          }
        }).toList());
    print(nama);
  }

  alltugas() async {
    await tugasCollection.get().then((value) => value.docs.map((e) {
          posisi.add(e['tugas']);
          setState(() {});
        }).toList());
    print(posisi);
  }

  @override
  void initState() {
    super.initState();
    alluser();
    alltugas();
    izinMinggu4();
  }

  List<String> nama = [];
  final List<String> posisi = [];
  final List<Izin> izin = [];

  void gantiUserIzin(List<String> user, List<Izin> izin) {
    List<String> userUpdated = List.from(user);
    Random random = Random();

    for (var item in izin) {
      if (item.status == "1") {
        // Temukan indeks user yang izin
        int index = userUpdated.indexOf(item.nama!);
        if (index != -1) {
          // Buat daftar user yang bisa dipilih sebagai pengganti (kecuali yang izin)
          List<String> candidates = List.from(user)..remove(item.nama);
          // Pilih user pengganti secara acak
          String replacement = candidates[random.nextInt(candidates.length)];
          // Ganti user yang izin dengan user pengganti
          userUpdated[index] = replacement;
        }
      }
    }
    setState(() {
      nama = userUpdated;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Minggu 4",
            style: TextStyle(
              fontSize: 20,
            )),
        centerTitle: false,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _usersStream,
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasData) {
              final List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
              if (documents.isEmpty) {
                return const Center();
              }
              return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListView.builder(
                    itemCount: nama.length > posisi.length
                        ? posisi.length
                        : nama.length,
                    itemBuilder: (context, index) => ListTile(
                      title: Text(posisi[index]),
                      subtitle: Text(nama[index]),
                    ),
                  ));
            }

            if (snapshot.hasError) {
              return const Center(
                child: Text("An Error Occured"),
              );
            }
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }),
      bottomSheet: Container(
        height: 60,
        color: Color.fromARGB(255, 255, 255, 255),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection('minggu4')
                      .doc('jadwal4')
                      .set({
                    "WL": nama[0],
                    "Singer": nama[1],
                    "Firman Kecil": nama[2],
                    "Firman Besar": nama[3],
                    "Multimedia": nama[4],
                    "Usher": nama[5],
                    "Doa": nama[6],
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Jadwal berhasil di-upload'),
                      backgroundColor: const Color.fromARGB(255, 99, 99, 99),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
                child: const Text(
                  "Upload",
                  style: TextStyle(color: Colors.black),
                )),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    nama.shuffle();
                  });
                  gantiUserIzin(nama, izin);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
                child: const Text(
                  "Random",
                  style: TextStyle(color: Colors.black),
                )),
          ],
        ),
      ),
    );
  }
}

