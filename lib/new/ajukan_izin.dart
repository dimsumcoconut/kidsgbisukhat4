import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kidsgbisukhat4/consts.dart';

class AjukanIzinPage extends StatefulWidget {
  final dynamic user;

  const AjukanIzinPage({super.key, this.user});

  @override
  State<AjukanIzinPage> createState() => _AjukanIzinPageState();
}

class _AjukanIzinPageState extends State<AjukanIzinPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController alasanController = TextEditingController();
  final TextEditingController tanggalIzinController = TextEditingController();
  Map<String, dynamic>? user;
  List<Map<String, dynamic>> listUser = [];
  bool isLoadingSave = false;
  DateTime? dateTime;

  final CollectionReference collectionUser =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference collectionIzin =
      FirebaseFirestore.instance.collection('izin');

  allUser() async {
    List<Map<String, dynamic>> data =
        await collectionUser.get().then((value) => value.docs.map((e) {
              Map<String, dynamic> user = {
                'nama': e['nama'],
                'email': e['email'],
                'jabatan': e['jabatan'],
                'password': e['password'],
              };
              return user;
            }).toList());
    listUser = data;
    listUser = listUser
        .where((element) => element['jabatan'] != 'Admin')
        // .sorted(
        //   (a, b) => b['created_at'].compareTo(a['created_at']),
        // )
        .toList();
    setState(() {});
    return data;
  }

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
      message = 'Tambah Izin Sukses';
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
    allUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        title: const Text("Ajukan Izin",
            style: TextStyle(fontSize: 20, color: Colors.white)),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(10),
          children: [
            widget.user['jabatan'] == 'Admin'
                ? DropdownButtonFormField(
                    decoration: const InputDecoration(
                      labelText: 'User',
                      hintText: 'Masukkan User',
                      floatingLabelAlignment: FloatingLabelAlignment.start,
                      isCollapsed: false,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      // prefixIcon: const Icon(Icons.menu_rounded),
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      ...List.generate(
                        listUser.length,
                        (index) {
                          return DropdownMenuItem(
                            value: listUser[index],
                            child: Text(
                              listUser[index]['nama'],
                            ),
                          );
                        },
                      )
                    ],
                    onChanged: (value) {
                      setState(() {
                        user = value;
                      });
                    },
                  )
                : const SizedBox.shrink(),
            widget.user['jabatan'] == 'Admin'
                ? const SizedBox(
                    height: 10,
                  )
                : const SizedBox.shrink(),
            TextFormField(
              controller: tanggalIzinController,
              readOnly: true,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), label: Text('Tanggal Izin')),
              onTap: () {
                 showDatePicker(
                        context: context,
                        // initialDate: pickedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        selectableDayPredicate: (DateTime date) {
                          // Hanya izinkan hari Minggu yang dapat dipilih
                          return date.weekday == DateTime.sunday;
                        },
                      ).then((pickedDate) {
                  if (pickedDate != null) {
                    setState(() {
                      dateTime = pickedDate;
                      String formattedDate =
                          DateFormat('EEEE, dd-MMM-yyyy', 'id_ID')
                              .format(pickedDate);
                      // print(formattedDate);
                      tanggalIzinController.text = formattedDate;
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
              height: 10,
            ),
            TextFormField(
              controller: alasanController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), label: Text('Alasan')),
              maxLines: 3,
              keyboardType: TextInputType.streetAddress,
              validator: (value) {
                if (value!.isEmpty || value == '') {
                  return 'Masukkan Alasan';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 10,
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
                              // 'user': widget.user ?? user,
                              'user': user ?? widget.user,
                              'alasan': alasanController.text,
                              'status': 0,
                              'tanggal_izin': Timestamp.fromDate(dateTime!),
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
                              //   alasanController.clear();
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
                            : const Text('Ajukan Izin'))),
              ],
            )
          ],
        ),
      ),
    );
  }
}
