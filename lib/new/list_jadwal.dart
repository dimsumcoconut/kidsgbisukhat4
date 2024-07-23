import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import 'package:kidsgbisukhat4/new/bikin_jadwal.dart';
import 'package:kidsgbisukhat4/new/detailjadwal.dart';

class ListJadwalPage extends StatefulWidget {
  final dynamic user;
  const ListJadwalPage({super.key, required this.user});

  @override
  State<ListJadwalPage> createState() => _ListJadwalPageState();
}

class _ListJadwalPageState extends State<ListJadwalPage> {
  final CollectionReference collectionJadwal =
      FirebaseFirestore.instance.collection('jadwals');

  Stream<List<dynamic>> fetchAllSortedFirestore() {
    return collectionJadwal.snapshots().map((s) => s.docs
        .map((e) {
          List<dynamic> details = [];
          for (var i = 0; i < e['details'].length; i++) {
            details.add({
              'tugas': e['details'][i]['tugas'],
              'user': e['details'][i]['user'],
              'created_at': e['details'][i]['created_at'],
            });
          }
          Map<String, dynamic> jadwal = {
            'tanggal': e['tanggal'],
            'name': e['name'],
            'details': details,
            'created_at': e['created_at'],
          };

          return jadwal;
        })
        .sorted(
          (a, b) => b['created_at'].compareTo(a['created_at']),
        )
        .toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text("Jadwal",
            style: TextStyle(fontSize: 20, color: Colors.white)),
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: fetchAllSortedFirestore(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
            // Display a loading indicator while waiting for data
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
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> jadwal = snapshot.data![index];
                return ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailJadwalPage(
                          jadwal: jadwal,
                          user: widget.user,
                        ),
                      ),
                    );
                  },
                  title: Text(jadwal['name']),
                  subtitle: Text(DateFormat('EEEE, dd-MMM-yyyy', 'id_ID')
                      .format(jadwal['tanggal'].toDate())),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded),
                );
              },
            );
            // return YourDataWidget(
            //     data: snapshot.data); // Display your UI with the data
          }
        },
      ),
      floatingActionButton: widget.user['jabatan'] == 'Admin'
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BikinJadwal(),
                  ),
                );
              },
              child: const Icon(Icons.add),
            )
          : const SizedBox.shrink(),
    );
  }
}
