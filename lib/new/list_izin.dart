import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import 'package:kidsgbisukhat4/new/ajukan_izin.dart';
import 'package:kidsgbisukhat4/new/detail_izin.dart';

class ListIzinPage extends StatefulWidget {
  final dynamic user;
  const ListIzinPage({super.key, this.user});

  @override
  State<ListIzinPage> createState() => _ListIzinPageState();
}

class _ListIzinPageState extends State<ListIzinPage> {
  List<Map<String, dynamic>> listIzin = [];
  final CollectionReference collectionIzins =
      FirebaseFirestore.instance.collection('izin');
  Stream<List<dynamic>> fetchAllSortedFirestore() {
    if (widget.user['jabatan'] == 'Admin') {
      return collectionIzins.snapshots().map((s) => s.docs
          .map((e) {
            return {
              'tanggal_izin': e['tanggal_izin'],
              'alasan': e['alasan'],
              'status': e['status'],
              'created_at': e['created_at'],
              'user': e['user'],
              'id': e['id'],
            };
          })
          // .where((element) => element['status'] == 0)
          .sorted(
            (a, b) => b['created_at'].compareTo(a['created_at']),
          )
          .toList());
    } else {
      return collectionIzins.snapshots().map((s) => s.docs
          .map((e) {
            return {
              'tanggal_izin': e['tanggal_izin'],
              'alasan': e['alasan'],
              'status': e['status'],
              'created_at': e['created_at'],
              'user': e['user'],
              'id': e['id'],
            };
          })
          .where((element) => element['user']['email'] == widget.user['email'])
          .sorted(
            (a, b) => b['created_at'].compareTo(a['created_at']),
          )
          .toList());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text("List Izin",
            style: TextStyle(fontSize: 20, color: Colors.white)),
        centerTitle: false,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AjukanIzinPage(
                user: widget.user,
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
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
                Map<String, dynamic> izin = snapshot.data![index];
                String status = izin['status'] == 0
                    ? 'Belum Dibaca'
                    : izin['status'] == 1
                        ? 'Disetujui'
                        : 'Tidak Disetujui';
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailIzinPage(
                          izin: izin,
                          user: widget.user,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  izin['user']['nama'],
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text('${izin['alasan']}'),
                                Text(
                                    '${DateFormat('EEEE, dd-MMM-yyyy', 'id_ID').format(izin['tanggal_izin'].toDate())}'),
                                Text(status),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios_rounded)
                        ],
                      ),
                    ),
                  ),
                );
                // return ListTile(
                //   tileColor:
                //   izin['status'] == 1
                //       ? Colors.blue
                //       : izin['status'] == 2
                //           ? Colors.red
                //           : Colors.transparent,
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => DetailIzinPage(
                //           izin: izin,
                //           user: widget.user,
                //         ),
                //       ),
                //     );
                //   },
                //   title: Text(
                //     izin['user']['nama'],
                //   ),
                //   subtitle: Text(
                //     '${izin['alasan']}\n${DateFormat('EEEE, dd-MMM-yyyy', 'id_ID').format(izin['tanggal_izin'].toDate())}\n${izin['status']}',
                //   ),
                //   trailing: const Icon(Icons.arrow_forward_ios_rounded),
                // );
              },
            );
          }
        },
      ),
    );
  }
}
