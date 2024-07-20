import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kidsgbisukhat4/consts.dart';

class AddBahan extends StatefulWidget {
  final dynamic user;

  const AddBahan({super.key, this.user});

  @override
  State<AddBahan> createState() => _AddBahanState();
}

class _AddBahanState extends State<AddBahan> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController bulanController = TextEditingController();
  final TextEditingController bahanController = TextEditingController();
  final TextEditingController keteranganController = TextEditingController();

  Map<String, dynamic>? user;
  List<Map<String, dynamic>> listUser = [];
  bool isLoadingSave = false;
  DateTime? dateTime;

  final CollectionReference collectionIzin =
      FirebaseFirestore.instance.collection('bahan');

  createData(dynamic izin) async {
    String message = '';
    dynamic data;
    StatusType status;
    try {
      await collectionIzin.add(izin).then(
        (value) {
          izin['id'] = value.id;
          collectionIzin.doc(value.id).set(izin);
        },
      );
      data = izin;
      status = StatusType.success;
      message = 'Tambah Bahan Sukses';
    } catch (e) {
      message = 'Gagal ';
      data = null;
      status = StatusType.error;
    }
    return Response(data: data, status: status, message: message);
  }

  @override
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        title: const Text("Tambah Bahan",
            style: TextStyle(fontSize: 20, color: Colors.white)),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(10),
          children: [
            TextFormField(
              controller: bulanController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), label: Text('Bulan')),
              keyboardType: TextInputType.streetAddress,
              validator: (value) {
                if (value!.isEmpty || value == '') {
                  return 'Harap Diisi.';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: bahanController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), label: Text('Bahan')),
              keyboardType: TextInputType.streetAddress,
              validator: (value) {
                if (value!.isEmpty || value == '') {
                  return 'Harap Diisi.';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: keteranganController,
              maxLines: 4,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), label: Text('Keterangan')),
              keyboardType: TextInputType.streetAddress,
              validator: (value) {
                if (value!.isEmpty || value == '') {
                  return 'Harap Diisi.';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                        ),
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            setState(() {
                              isLoadingSave = true;
                            });
                            Response response;

                            Map<String, dynamic> izin = {
                              'bulan': bulanController.text,
                              'bahan': bahanController.text,
                              'keterangan': keteranganController.text,
                              'created_at': Timestamp.now(),
                              'updated_at': Timestamp.now(),
                            };
                            response = await createData(izin);
                            setState(() {
                              isLoadingSave = false;
                            });
                            if (context.mounted) {
                              // if (widget.user['jabatan'] == 'Admin') {
                              Navigator.of(context).pop();
                              // } else {
                              //   bulanController.clear();
                              //   tanggalIzinController.clear();
                              // }

                              var snackBar = SnackBar(
                                behavior: SnackBarBehavior.floating,
                                content: Text(response.message!),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          }
                        },
                        child: isLoadingSave
                            ? const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Center(
                                    child: SizedBox(
                                      width: 14,
                                      height: 14,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 14),
                                  Text('Loading...')
                                ],
                              )
                            : const Text('Tambah Bahan'))),
              ],
            )
          ],
        ),
      ),
    );
  }
}
