import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kidsgbisukhat4/consts.dart';

class AddBerita extends StatefulWidget {
  final dynamic user;

  const AddBerita({super.key, this.user});

  @override
  State<AddBerita> createState() => _AddBeritaState();
}

class _AddBeritaState extends State<AddBerita> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController tanggalController = TextEditingController();
  final TextEditingController beritaController = TextEditingController();
  final TextEditingController keteranganController = TextEditingController();

  Map<String, dynamic>? user;
  List<Map<String, dynamic>> listUser = [];
  bool isLoadingSave = false;
  DateTime? dateTime;

  final CollectionReference collectionIzin =
      FirebaseFirestore.instance.collection('berita');

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
      message = 'Tambah Berita Sukses';
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
        title: const Text("Tambah Berita",
            style: TextStyle(fontSize: 20, color: Colors.white)),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          children: [
            TextFormField(
              controller: beritaController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), label: Text('Nama Berita')),
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
              controller: tanggalController,
              readOnly: true,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), label: Text('Masukkan Tanggal')),
              onTap: () {
                showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2099),
                ).then((pickedDate) {
                  if (pickedDate != null) {
                    setState(() {
                      dateTime = pickedDate;
                      String formattedDate =
                          DateFormat('EEEE, dd-MMM-yyyy', 'id_ID')
                              .format(pickedDate);
                      // print(formattedDate);
                      tanggalController.text = formattedDate;
                    });
                  }
                });
              },
              validator: (value) {
                if (value!.isEmpty || value == '') {
                  return 'Masukkan Tanggal Izin';
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
                              'berita': beritaController.text,
                              'tanggal': tanggalController.text,
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
                            : const Text('Tambah Berita'))),
              ],
            )
          ],
        ),
      ),
    );
  }
}
