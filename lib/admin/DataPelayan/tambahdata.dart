import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kidsgbisukhat4/admin/dashboardadmin.dart';

class Tambah extends StatefulWidget {
  const Tambah({super.key});

  @override
  _Tambah createState() => _Tambah();
}

class _Tambah extends State<Tambah> {
  final List<String> data = ['Guru', 'Asisten'];
  String selecteditem = 'Guru';

  _Tambah();

  bool showProgress = false;
  bool visible = false;
  File? file;
  var options = ['Guru', 'Asisten'];
  var _currentItemSelected = "Guru";
  var jabatan = "Guru";

  final _formKey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController nama = TextEditingController();
  // TextEditingController jabatan = TextEditingController();

  // bool _isObscure = true;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nama.dispose();
    email.dispose();
    password.dispose();
    // jabatan.dispose();
    super.dispose();
  }

  clearText() {
    nama.clear();
    email.clear();
    password.clear();
    // jabatan.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        title:
            const Text("Tambah Data Pelayan", style: TextStyle(fontSize: 18)),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.only(top: 30, left: 5, right: 20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //email
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 15),
                    child: TextFormField(
                      controller: email,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Email cannot be empty";
                        }
                        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                            .hasMatch(value)) {
                          return ("Please enter a valid email");
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) {},
                    ),
                  ),

                  //nama
                  const SizedBox(height: 20),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 15),
                    child: TextFormField(
                      controller: nama,
                      decoration: InputDecoration(
                          labelText: 'Nama',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: Colors.black))),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Harap diisi";
                        }
                        return null;
                      },
                      onChanged: (value) {},
                    ),
                  ),

                  const SizedBox(height: 20),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 15),
                    child: TextFormField(
                      controller: password,
                      decoration: InputDecoration(
                          labelText: 'Tanggal Lahir',
                          hintText: 'DDMMYYYY',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: Colors.black))),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Wajib diisi";
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) {},
                    ),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.only(left: 19),
                    child: Row(
                      children: [
                        const Text(
                          "Jabatan: ",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 20),
                        DropdownButton<String>(
                          items: options.map((String dropDownStringItem) {
                            return DropdownMenuItem(
                              value: dropDownStringItem,
                              child: Text(
                                dropDownStringItem,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (newValueSelected) {
                            setState(() {
                              _currentItemSelected = newValueSelected!;
                              jabatan = newValueSelected;
                            });
                          },
                          value: _currentItemSelected,
                          icon: const Icon(Icons.arrow_drop_down),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {},
                          child: MaterialButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  signUp(email.text, password.text, nama.text,
                                      jabatan);
                                  clearText();
                                });
                              }
                            },
                            child: Center(
                              child: Container(
                                height: 30,
                                width: 100,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                  borderRadius: BorderRadius.circular(90),
                                ),
                                child: const Center(
                                  child: Text("Tambah",
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {},
                          child: MaterialButton(
                            onPressed: () => {clearText()},
                            child: Center(
                              child: Container(
                                height: 30,
                                width: 100,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                  borderRadius: BorderRadius.circular(90),
                                ),
                                child: const Center(
                                  child: Text("Hapus",
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )),
      ),
    );
  }

  void signUp(
      String email, String password, String nama, String jabatan) async {
    const CircularProgressIndicator();
    if (_formKey.currentState!.validate()) {
      String message = '';
      try {
        await auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) =>
                {postDetailsToFirestore(email, password, nama, jabatan)})
            .catchError((e) {});
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          message = 'The password provided is too weak.';
        } else if (e.code == 'email-already-in-use') {
          message = 'The account already exists for that email.';
        }
      } catch (e) {
        message = "Email sudah pernah didaftarkan, silakan gunakan email lain.";
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        // duration: const Duration(seconds: 1),
      ));
    }
  }

  postDetailsToFirestore(
      String email, String password, String nama, String jabatan) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    var user = auth.currentUser;

    CollectionReference ref = FirebaseFirestore.instance.collection('users');
    ref.doc(user!.uid).set({
      'email': email,
      'password': password,
      'nama': nama,
      'jabatan': jabatan,
    });
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const DashboardAdmin()));
  }
}
