import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kidsgbisukhat4/new/tambahbahan.dart';

import 'package:url_launcher/url_launcher.dart';

class BahanPage extends StatefulWidget {
  final dynamic user;
  const BahanPage({super.key, this.user});

  @override
  State<BahanPage> createState() => _BahanPageState();
}

class _BahanPageState extends State<BahanPage> {
  List<Map<String, dynamic>> listbahan = [];
  final CollectionReference collectionbahan =
      FirebaseFirestore.instance.collection('bahan');

  void deleteContact(String id) async {
    FirebaseFirestore.instance.collection('bahan');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('bahan berhasil dihapus'),
        backgroundColor: const Color.fromARGB(255, 99, 99, 99),
      ),
    );
  }

  Stream<List<dynamic>> fetchAllSortedFirestore() {
    if (widget.user['jabatan'] == 'Admin') {
      return collectionbahan.snapshots().map((s) => s.docs.map((e) {
            return {
              'bahan': e['bahan'],
              // 'keterangan': e['keterangan'],
              'bulan': e['bulan'],
            };
          })
              // .where((element) => element['status'] == 0)
              // .sorted(
              //   (a, b) => b['created_at'].compareTo(a['created_at']),
              // )
              .toList());
    } else {
      return collectionbahan.snapshots().map((s) => s.docs.map((e) {
            return {
              'bahan': e['bahan'],
              // 'keterangan': e['keterangan'],
              'bulan': e['bulan'],
            };
          })
              // .where((element) => element['user']['email'] == widget.user['email'])
              // .sorted(
              //   (a, b) => b['created_at'].compareTo(a['created_at']),
              // )
              .toList());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text("List Bahan",
            style: TextStyle(fontSize: 20, color: Colors.white)),
        centerTitle: false,
      ),
      floatingActionButton: widget.user['jabatan'] == 'Admin'
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TambahBahan(),
                  ),
                );
              },
              child: const Icon(Icons.add),
            )
          : const SizedBox.shrink(),
      body: StreamBuilder(
        stream: fetchAllSortedFirestore(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            ); // Display a loading indicator while waiting for data
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            ); // Handle errors
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text('Belum Ada Data'),
            ); // Handle the case when there's no data
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> bahan = snapshot.data![index];
                return ListTile(
                  // onTap: () {
                  //   //ini kemna?
                  // },
                  title: Text(
                      '${DateFormat('MMMM - yyyy', 'id_ID').format(bahan['bulan'].toDate())}',
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold)),
                  subtitle: GestureDetector(
                    onTap: () async {
                      if (!await launchUrl(Uri.parse(
                        '${bahan['bahan']}',
                      ))) {
                        throw Exception('Could not launch ${bahan['bahan']}');
                      }
                    },
                    child: Text('Download',
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
