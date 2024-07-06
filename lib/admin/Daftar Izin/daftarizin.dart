import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kidsgbisukhat4/pelayan/my_firebase.dart';

class DaftarIzin extends StatefulWidget {
  const DaftarIzin({Key? key}) : super(key: key);

  @override
  State<DaftarIzin> createState() => _DaftarIzinState();
}

class _DaftarIzinState extends State<DaftarIzin> {
  bool isChecked = false;

  final izinSnapshot = MyFirebase.izinCollection.snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Daftar Izin",
            style: TextStyle(
              fontSize: 20,
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
                  final izin = documents[index].data() as Map<String, dynamic>;
                  final String nama = izin['nama'];
                  final String tanggal = izin['tanggal'];
                  final String alasan = izin['alasan'];
                  final String status = izin['status'] == "0"
                      ? "Belum Ditanggapi"
                      : izin['status'] == "1"
                          ? "Disetujui"
                          : "Tidak Disetujui";

                  // documents[index].id;

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
                                .collection('izin')
                                .doc(documents[index].id)
                                .set({
                              'tanggal': tanggal,
                              'nama': nama,
                              'alasan': alasan,
                              'status': "1",
                            });

                            // ScaffoldMessenger.of(context).showSnackBar(
                            //   SnackBar(
                            //     content:
                            //         const Text('Berhasil tidak disetujui'),
                            //     backgroundColor:
                            //         const Color.fromARGB(255, 99, 99, 99),
                            //   ),
                            // );
                          },
                          splashRadius: 24,
                          icon: const Icon(Icons.check),
                        ),
                        IconButton(
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection('izin')
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
