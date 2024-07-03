import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kidsgbisukhat4/pelayan/pengajuan_izin/minggu1/izin_minggu1.dart';
import 'package:kidsgbisukhat4/pelayan/pengajuan_izin/minggu2/izin2.dart';
import 'package:kidsgbisukhat4/pelayan/pengajuan_izin/minggu2/my_firebase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DP2 extends StatefulWidget {
  const DP2({super.key});

  @override
  State<DP2> createState() => _DPI2State();
}

class _DPI2State extends State<DP2> {
 final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('izin2')
      // .where('nama', isEqualTo: widget.nama)
      .snapshots();

  final izinSnapshot = MyFirebase.izin2Collection.snapshots();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  Map<String, dynamic> dataUser = {};
  getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    dataUser = jsonDecode(prefs.getString('userPref')!);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Daftar Izin Minggu 2",
            style: TextStyle(
              fontSize: 18,
            )),
        centerTitle: false,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _usersStream,

          // stream: _usersStream.where((event) => false),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasData) {
              final List<QueryDocumentSnapshot> documents = snapshot.data!.docs
                  .where((element) => element['nama'] == dataUser['nama'])
                  .toList();
              if (documents.isEmpty) {
                return Center(
                  child: Text(
                    "Belum ada pengajuan izin",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                );
              }
              return ListView.builder(
                itemCount: documents.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final izin = documents[index].data() as Map<String, dynamic>;
                  final String tanggal = izin['tanggal'];
                  final String alasan = izin['alasan'];
                  final String status =
                      izin['status'] == "0" ? "Belum Ditanggapi"
                      : izin['status']  == "1" ?
                      "Disetujui" :
                      "Tidak Disetujui";

                  return ListTile(
                    onTap: () {},

                    title: Text("Tanggal: $tanggal",
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),

                    subtitle: Text("$alasan \n$status"),
                    isThreeLine: true,
                    //  trailing should be delete and edit button
                  );
                },
              );
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Izin2()),
          );
        },
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }
}
