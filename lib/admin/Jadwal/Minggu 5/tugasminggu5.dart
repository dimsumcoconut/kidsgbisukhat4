import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kidsgbisukhat4/admin/Jadwal/Minggu%203/minggu_3.dart';
import 'package:kidsgbisukhat4/admin/Jadwal/Minggu%205/minggu_5.dart';

class TugasMinggu5 extends StatefulWidget {
  const TugasMinggu5({Key? key}) : super(key: key);

  @override
  State<TugasMinggu5> createState() => _TugasMinggu5State();
}

class _TugasMinggu5State extends State<TugasMinggu5> {
  final Stream<QuerySnapshot> minggu5Stream =
      FirebaseFirestore.instance.collection('minggu5').snapshots();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    allData();
    alltugas();
  }

  final CollectionReference tugasCollection =
      FirebaseFirestore.instance.collection('tugas_pel');

  final CollectionReference jadwalCollection =
      FirebaseFirestore.instance.collection('minggu5');

  allData() async {
    await jadwalCollection.get().then((value) => value.docs.map((e) {
          jadwal.add(e['WL']);
          jadwal.add(e['Singer']);
          jadwal.add(e['Firman Kecil']);
          jadwal.add(e['Firman Besar']);
          jadwal.add(e['Multimedia']);
          jadwal.add(e['Usher']);
          jadwal.add(e['Doa']);

          setState(() {});
        }).toList());
  }

  alltugas() async {
    await tugasCollection.get().then((value) => value.docs.map((e) {
          posisi.add(e['tugas']);
          setState(() {});
        }).toList());
  }

  List<String> jadwal = [];
  List<String> posisi = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Jadwal Minggu 5"),
      ),
      body: jadwal.isEmpty
          ? const Center(
              child: Text('Belum ada jadwal.'),
            )
          : Padding(
              padding: const EdgeInsets.only(left: 10),
              child: StreamBuilder<Object>(
                  stream: minggu5Stream,
                  builder: (context, snapshot) {
                    return ListView.builder(
                      itemBuilder: (context, index) => ListTile(
                        title: Text(
                          "${posisi[index]}: ",
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text("${jadwal[index]}"),

                        // title: Text("${posisi[index]}: ${jadwal[index]}"),
                      ),
                      itemCount: jadwal.length > posisi.length
                          ? posisi.length
                          : jadwal.length,
                    );
                  }),
            ),
      bottomSheet: Container(
        height: 60,
        color: Color.fromARGB(255, 255, 255, 255),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Minggu5()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
                child: const Text(
                  "Tambah",
                  style: TextStyle(color: Colors.black),
                )),
            ElevatedButton(
                onPressed: () {
                  // jadwal.removeAt(index);
                  // posisi.removeAt(index);
                  FirebaseFirestore.instance
                      .collection('minggu5')
                      .doc('jadwal5')
                      .set({});
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Jadwal berhasil dihapus'),
                      backgroundColor: const Color.fromARGB(255, 99, 99, 99),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
                child: const Text(
                  "Hapus",
                  style: TextStyle(color: Colors.black),
                )),
          ],
        ),
      ),
    );
  }
}
