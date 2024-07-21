import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kidsgbisukhat4/consts.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController noHpController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController tanggalLahirController = TextEditingController();
  DateTime? dateTime;
  String? jabatan;
  bool isLoadingSave = false;

  final CollectionReference collectionUser =
      FirebaseFirestore.instance.collection('users');
  createData(Map<String, dynamic> user) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    String message = '';
    dynamic data;
    StatusType status;
    try {
      // add user auth
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: user['email']!, password: user['password']);
      if (userCredential.user != null) {
        //add donatur
        user['id'] = userCredential.user!.uid;
        await collectionUser.doc(userCredential.user!.uid).set(user);
      }
      data = user;
      status = StatusType.success;
      message = 'Tambah User Sukses';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      } else if (e.code == 'invalid-email') {
        message = 'The email address is not valid.';
      } else if (e.code == 'operation-not-allowed') {
        message = 'email/password accounts are not enabled.';
      }
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
        title: const Text('Tambah',
            style: TextStyle(fontSize: 20, color: Colors.white)),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(10),
          children: [
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), label: Text('Email')),
              validator: (value) {
                if (value!.isEmpty || value == '') {
                  return 'Masukkan Email';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), label: Text('Name')),
              keyboardType: TextInputType.name,
              validator: (value) {
                if (value!.isEmpty || value == '') {
                  return 'Masukkan Nama';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: noHpController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), label: Text('No HP')),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value!.isEmpty || value == '') {
                  return 'Masukkan No HP';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: tanggalLahirController,
              readOnly: true,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), label: Text('Tanggal Lahir')),
              onTap: () {
                showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1980),
                  lastDate: DateTime.now(),
                ).then((pickedDate) {
                  if (pickedDate != null) {
                    setState(() {
                      dateTime = pickedDate;
                      String formattedDate =
                          DateFormat('EEEE, dd-MMM-yyyy', 'id_ID')
                              .format(pickedDate);
                      // print(formattedDate);
                      tanggalLahirController.text = formattedDate;
                    });
                  }
                });
              },
              validator: (value) {
                if (value!.isEmpty || value == '') {
                  return 'Masukkan Tanggal Lahir';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 15,
            ),
            DropdownButtonFormField(
              decoration: const InputDecoration(
                labelText: 'Jabatan',
                hintText: 'Masukkan Jabatan',
                floatingLabelAlignment: FloatingLabelAlignment.start,
                isCollapsed: false,
                floatingLabelBehavior: FloatingLabelBehavior.always,
                // prefixIcon: const Icon(Icons.menu_rounded),
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Guru',
                  child: Text(
                    "Guru",
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  jabatan = value;
                });
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

                            Map<String, dynamic> user = {
                              'nama': nameController.text,
                              'email': emailController.text,
                              'jabatan': jabatan,
                              'no_hp': noHpController.text,
                              'tanggal_lahir': Timestamp.fromDate(dateTime!),
                              'password':
                                  DateFormat('yyyyMMdd').format(dateTime!),
                              'created_at': Timestamp.now(),
                            };
                            response = await createData(user);
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
