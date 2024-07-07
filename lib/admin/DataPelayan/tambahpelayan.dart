import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kidsgbisukhat4/admin/dashboardadmin.dart';

class TambahDataPelayan extends StatefulWidget {
  const TambahDataPelayan({super.key});

  @override
  _TambahDataPelayan createState() => _TambahDataPelayan();
}

class _TambahDataPelayan extends State<TambahDataPelayan> {
  final List<String> data = ['Aktif', 'Tidak Aktif'];
  String selecteditem = 'Aktif';

  _TambahDataPelayan();

  bool showProgress = false;
  bool visible = false;
  File? file;
  var options = [
    'Aktif',
    'Tidak Aktif',
  ];
  var _currentItemSelected = "Aktif";
  var status = "Aktif";

  final _formKey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController nama = TextEditingController();
  TextEditingController jabatan = TextEditingController();

  // bool _isObscure = true;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nama.dispose();
    email.dispose();
    password.dispose();
    jabatan.dispose();
    super.dispose();
  }

  clearText() {
    nama.clear();
    email.clear();
    password.clear();
    jabatan.clear();
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
                          // suffixIcon: IconButton(
                          //     icon: Icon(_isObscure
                          //         ? Icons.visibility_off
                          //         : Icons.visibility),
                          //     onPressed: () {
                          // setState(() {
                          //   _isObscure = !_isObscure;
                          // });
                          //     }),
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
                  const SizedBox(height: 20),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 15),
                    child: TextFormField(
                      controller: jabatan,
                      decoration: InputDecoration(
                        labelText: 'Jabatan',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                        // enabled: false
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Harap diisi";
                        }
                        return null;
                      },
                      onChanged: (value) {},
                    ),
                  ),
                  // const SizedBox(height: 10),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 19),
                  //   child: Row(
                  //     children: [
                  //       const Text(
                  //         "Status: ",
                  //         style: TextStyle(
                  //           fontSize: 20,
                  //           fontWeight: FontWeight.bold,
                  //           color: Colors.black,
                  //         ),
                  //       ),
                  //       const SizedBox(width: 20),
                  //       DropdownButton<String>(
                  //         items: options.map((String dropDownStringItem) {
                  //           return DropdownMenuItem(
                  //             value: dropDownStringItem,
                  //             child: Text(
                  //               dropDownStringItem,
                  //             ),
                  //           );
                  //         }).toList(),
                  //         onChanged: (newValueSelected) {
                  //           setState(() {
                  //             _currentItemSelected = newValueSelected!;
                  //             status = newValueSelected;
                  //           });
                  //         },
                  //         value: _currentItemSelected,
                  //         icon: const Icon(Icons.arrow_drop_down),
                  //       ),
                  //     ],
                  //   ),
                  // ),

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
                                  signUp(email.text, password.text,
                                      jabatan.text, nama.text, status);
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

  void signUp(String email, String password, String jabatan, String nama,
      String status) async {
    const CircularProgressIndicator();
    if (_formKey.currentState!.validate()) {
      await auth
          .createUserWithEmailAndPassword(
            email: email,
            password: password,
          )
          .then((value) =>
              {postDetailsToFirestore(email, jabatan, password, nama, status)})
          // ignore: body_might_complete_normally_catch_error
          .catchError((e) {});
    }
  }

  postDetailsToFirestore(String email, String jabatan, String password,
      String nama, String status) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    var user = auth.currentUser;

    CollectionReference ref = FirebaseFirestore.instance.collection('users');
    ref.doc(user!.uid).set({
      'email': email,
      'jabatan': jabatan,
      'password': password,
      'nama': nama,
      'status': status,
    });
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const DashboardAdmin()));
  }
}
