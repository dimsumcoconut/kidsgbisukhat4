import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class JadwalMinggu4 extends StatefulWidget {
  const JadwalMinggu4({super.key});

  @override
  State<JadwalMinggu4> createState() => _JadwalMinggu4State();
}

class _JadwalMinggu4State extends State<JadwalMinggu4> {
  final Stream<QuerySnapshot> minggu5Stream =
      FirebaseFirestore.instance.collection('minggu4').snapshots();

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
      FirebaseFirestore.instance.collection('minggu4');

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
      body: jadwal.isEmpty
          ? const Center(
              child: Text('Jadwal belum tersedia.'),
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
    );
  }
}
