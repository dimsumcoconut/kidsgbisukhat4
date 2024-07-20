import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kidsgbisukhat4/new/addnews.dart';

class ListBerita extends StatefulWidget {
  final dynamic user;
  const ListBerita({super.key, this.user});

  @override
  State<ListBerita> createState() => _ListBeritaState();
}

class _ListBeritaState extends State<ListBerita> {
  List<Map<String, dynamic>> listberita = [];
  final CollectionReference collectionBerita =
      FirebaseFirestore.instance.collection('berita');

  void deleteContact(String id) async {
    FirebaseFirestore.instance.collection('berita');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Berita berhasil dihapus'),
        backgroundColor: const Color.fromARGB(255, 99, 99, 99),
      ),
    );
  }

  Stream<List<dynamic>> fetchAllSortedFirestore() {
    if (widget.user['jabatan'] == 'Admin') {
      return collectionBerita.snapshots().map((s) => s.docs.map((e) {
            return {
              'berita': e['berita'],
              'keterangan': e['keterangan'],
              'tanggal': e['tanggal'],
              'created_at': e['created_at'],
            };
          })
              // .where((element) => element['status'] == 0)
              // .sorted(
              //   (a, b) => b['created_at'].compareTo(a['created_at']),
              // )
              .toList());
    } else {
      return collectionBerita.snapshots().map((s) => s.docs
          .map((e) {
            return {
              'berita': e['berita'],
              'keterangan': e['keterangan'],
              'tanggal': e['tanggal'],
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
        title: const Text("List Berita",
            style: TextStyle(fontSize: 20, color: Colors.white)),
        centerTitle: false,
      ),
  floatingActionButton: widget.user['jabatan'] == 'Admin'
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddBerita(),
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
                Map<String, dynamic> berita = snapshot.data![index];
                return ListTile(
                  title: Text(
                    berita['berita'],
                  ),
                  subtitle: Text(
                    '${berita['tanggal']}',
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
