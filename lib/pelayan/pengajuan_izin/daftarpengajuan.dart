import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kidsgbisukhat4/pelayan/my_firebase.dart';
import 'package:kidsgbisukhat4/pelayan/pengajuan_izin/pengajuan.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DaftarPengajuan extends StatefulWidget {
  const DaftarPengajuan({Key? key}) : super(key: key);

  @override
  State<DaftarPengajuan> createState() => _DaftarPengajuanState();
}

class _DaftarPengajuanState extends State<DaftarPengajuan> {
// final Stream<QuerySnapshot> _test=FirebaseFirestore.instance.collection('izin')
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('izin')
      // .where('nama', isEqualTo: widget.nama)
      .snapshots();

  final izinSnapshot = MyFirebase.izinCollection.snapshots();

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
        title: const Text("Daftar Pengajuan Izin",
            style: TextStyle(
              fontSize: 20,
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
            MaterialPageRoute(builder: (context) => const Pengajuan()),
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
