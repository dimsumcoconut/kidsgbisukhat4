import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:kidsgbisukhat4/pelayan/pengajuan_izin/minggu4/my_firebase.dart';

class DI4 extends StatefulWidget {
  const DI4({super.key});

  @override
  State<DI4> createState() => _DI4State();
}

class _DI4State extends State<DI4> {
  bool isChecked = false;

  final izinSnapshot = MyFirebase.izin4Collection.snapshots();

  void deleteIzin(String id) async {
    await MyFirebase.izin4Collection.doc(id).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Daftar dihapus'),
        backgroundColor: const Color.fromARGB(255, 99, 99, 99),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Daftar Izin Minggu 4",
            style: TextStyle(
              fontSize: 18,
            )),
        centerTitle: false,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: izinSnapshot,
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasData) {
              final List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
              if (documents.isEmpty) {
                return Center(
                  child: Text(
                    "Tidak ada data.",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                );
              }
              return ListView.builder(
                itemCount: documents.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final contactId = documents[index].id;
                  final izin = documents[index].data() as Map<String, dynamic>;
                  final String nama = izin['nama'];
                  final String tanggal = izin['tanggal'];
                  final String alasan = izin['alasan'];
                  final String status = izin['status'] == "0"
                      ? "Belum Ditanggapi"
                      : izin['status'] == "1"
                          ? "Disetujui"
                          : "Tidak Disetujui";

                  return ListTile(
                    onTap: () {},
                    title: Text("$nama",
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                    subtitle: Text("$tanggal \n$alasan \n$status"),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection('izin4')
                                .doc(documents[index].id)
                                .set({
                              'tanggal': tanggal,
                              'nama': nama,
                              'alasan': alasan,
                              'status': "1",
                            });
                          },
                          splashRadius: 24,
                          icon: const Icon(Icons.check),
                        ),
                        IconButton(
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection('izin4')
                                .doc(documents[index].id)
                                .set({
                              'tanggal': tanggal,
                              'nama': nama,
                              'alasan': alasan,
                              'status': "2",
                            });
                          },
                          splashRadius: 24,
                          icon: const Icon(Icons.close),
                        ),
                        IconButton(
                          onPressed: () {
                            deleteIzin(contactId);
                          },
                          splashRadius: 24,
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
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
    );
  }
}
