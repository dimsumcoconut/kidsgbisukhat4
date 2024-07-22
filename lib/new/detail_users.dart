import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kidsgbisukhat4/consts.dart';

class DetailUsersPage extends StatefulWidget {
  final Map<String, dynamic> izin;
  final dynamic user;
  const DetailUsersPage({super.key, required this.izin, this.user});

  @override
  State<DetailUsersPage> createState() => _DetailUsersPageState();
}

class _DetailUsersPageState extends State<DetailUsersPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController alasanController = TextEditingController();
  final TextEditingController tanggalIzinController = TextEditingController();
  final TextEditingController namaUserController = TextEditingController();
  bool isLoadingSave = false;
  int? status;
  final CollectionReference collectionIzin =
      FirebaseFirestore.instance.collection('izin');
  List<Map<String, dynamic>> list_status = [
    {
      'status': 'Belum Dibaca',
      'value': 0,
    },
    {
      'status': 'Disetujui',
      'value': 1,
    },
    {
      'status': 'TIdak Disetujui',
      'value': 2,
    },
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    alasanController.text = widget.izin['alasan'];
    namaUserController.text = widget.izin['user']['nama'];
    tanggalIzinController.text = DateFormat('EEEE, dd-MMM-yyyy', 'id_ID')
        .format(widget.izin['tanggal_izin'].toDate());
    status = widget.izin['status'];
  }

  createData(dynamic izin) async {
    String message = '';
    dynamic data;
    StatusType status;
    try {
      // await collectionIzin.add(izin);
      await collectionIzin.doc(izin['id']).set(izin);
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        title: const Text("Detail Izin",
            style: TextStyle(fontSize: 20, color: Colors.white)
            ),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(10),
          children: [
            TextFormField(
              controller: namaUserController,
              readOnly: true,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), label: Text('Nama User')),
              onTap: () {},
              validator: (value) {
                if (value!.isEmpty || value == '') {
                  return 'Masukkan Nama User';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: tanggalIzinController,
              readOnly: true,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), label: Text('Tanggal Izin')),
              onTap: () {},
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
              readOnly: true,
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
            widget.user['jabatan'] != 'Admin'
                ? DropdownButtonFormField(
                    decoration: const InputDecoration(
                      labelText: 'Status',
                      hintText: 'Masukkan Status',
                      floatingLabelAlignment: FloatingLabelAlignment.start,
                      isCollapsed: false,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      // prefixIcon: const Icon(Icons.menu_rounded),
                      border: OutlineInputBorder(),
                    ),
                    value: status,
                    items: [
                      DropdownMenuItem(
                        value: list_status[status!]['value'],
                        child: Text(
                          list_status[status!]['status'],
                        ),
                      )
                    ],
                    onChanged: (value) {
                      if (widget.user['jabatan'] != 'Admin') {
                        null;
                      } else {
                        setState(() {
                          print(value);
                          status = value as int;
                        });
                      }
                    },
                  )
                : DropdownButtonFormField(
                    decoration: const InputDecoration(
                      labelText: 'Status',
                      hintText: 'Masukkan Status',
                      floatingLabelAlignment: FloatingLabelAlignment.start,
                      isCollapsed: false,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      // prefixIcon: const Icon(Icons.menu_rounded),
                      border: OutlineInputBorder(),
                    ),
                    value: status,
                    items: [
                      ...List.generate(
                        list_status.length,
                        (index) {
                          return DropdownMenuItem(
                            value: list_status[index]['value'],
                            child: Text(
                              list_status[index]['status'],
                            ),
                          );
                        },
                      )
                    ],
                    onChanged: (value) {
                      if (widget.user['jabatan'] != 'Admin') {
                        null;
                      } else {
                        setState(() {
                          print(value);
                          status = value as int;
                        });
                      }
                    },
                  ),
            const SizedBox(
              height: 15,
            ),
            widget.user['jabatan'] != 'Admin'
                ? const SizedBox.shrink()
                : Row(
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
                                    'id': widget.izin['id'],
                                    'user': widget.izin['user'],
                                    'alasan': alasanController.text,
                                    'status': status,
                                    'tanggal_izin': widget.izin['tanggal_izin'],
                                    'created_at': widget.izin['created_at'],
                                    'updated_at': Timestamp.now(),
                                  };

                                  response = await createData(izin);
                                  setState(() {
                                    isLoadingSave = false;
                                  });
                                  if (context.mounted) {
                                    Navigator.of(context).pop();

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
                                  : const Text('Simpan'))),
                    ],
                  )
          ],
        ),
      ),
    );
  }
}
