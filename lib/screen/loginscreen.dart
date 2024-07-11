import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:kidsgbisukhat4/admin/dashboardadmin.dart';
import 'package:kidsgbisukhat4/models/user_model.dart';
import 'package:kidsgbisukhat4/pelayan/dashboard_pelayan_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final _formKey = GlobalKey<FormState>();

  bool visible = false;

  final auth = FirebaseAuth.instance;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isSecurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(children: [
              const Padding(
                padding: EdgeInsets.only(right: 25, left: 25, top: 80),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Shallom,",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 1),
              const Padding(
                padding: EdgeInsets.only(right: 25, left: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Silakan Login",
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 100,
              ),
              Container(
                // width: 500,
                // margin: const EdgeInsets.symmetric(horizontal: 20),
                // decoration: BoxDecoration(
                //     color: const Color.fromARGB(210, 0, 0, 0),
                //     borderRadius: BorderRadius.circular(20)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 75),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    ),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 0, 0, 0))),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                        ),
                        prefixIcon: Icon(
                          Icons.email,
                          color: Color.fromARGB(255, 0, 0, 0),
                          size: 18,
                        ),
                        label: Text(
                          'Email',
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                              fontSize: 16),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Harap masukkan email";
                        }
                        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                            .hasMatch(value)) {
                          return ("Harap masukkan email yang benar");
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) {
                        emailController.text = value!;
                      },
                      style: const TextStyle(
                          fontWeight: FontWeight.normal, color: Colors.black),
                    ),
                    TextFormField(
                      controller: passwordController,
                      obscureText: _isSecurePassword,
                      decoration: InputDecoration(
                        enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 0, 0, 0))),
                        focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Color.fromARGB(255, 0, 0, 0),
                          size: 18,
                        ),
                        suffixIcon: buttonPassword(),
                        label: const Text(
                          'Password',
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Color.fromARGB(255, 0, 0, 0)),
                        ),
                      ),
                      validator: (value) {
                        RegExp regex = RegExp(r'^.{6,}$');
                        if (value!.isEmpty) {
                          return "Harap masukkan password";
                        }
                        if (!regex.hasMatch(value)) {
                          return ("Password kurang dari enam karakter");
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) {
                        passwordController.text = value!;
                      },
                      style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                    const SizedBox(height: 30),
                    MaterialButton(
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                      elevation: 5.0,
                      height: 40,
                      onPressed: () {
                        setState(() {
                          visible = true;
                        });
                        signIn(emailController.text, passwordController.text);
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            borderRadius: BorderRadius.circular(10)),
                        child: const Center(
                          child: Text("Log In",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Widget buttonPassword() {
    return IconButton(
      onPressed: () {
        setState(() {
          _isSecurePassword = !_isSecurePassword;
        });
      },
      icon: _isSecurePassword
          ? const Icon(Icons.visibility)
          : const Icon(Icons.visibility_off),
      color: const Color.fromARGB(255, 0, 0, 0),
    );
  }

  void route() {
    User? user = FirebaseAuth.instance.currentUser;
    // var a =
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        if (documentSnapshot.get('jabatan') == "Admin") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const DashboardAdmin(
                  // nama: documentSnapshot.get('nama'),
                  ),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const PelayanDashboard(),
            ),
          );
        }
      } else {
        print('Document does not exist on the database');
      }
    });
  }

  void signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      dynamic data;
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        print(userCredential.user!.email);
        data = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: userCredential.user!.email!)
            .get()
            .then((querySnapshot) =>
                UserModel.fromSnapshot(querySnapshot.docs.first));
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('userPref', jsonEncode(data.toSharedPref()));
        prefs.setBool('loggedIn', true);
        print(prefs.getString('userPref'));
        print(jsonDecode(prefs.getString('userPref')!)['nama']);
        // route();
        if (jsonDecode(prefs.getString('userPref')!)['jabatan'] == 'Admin') {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => DashboardAdmin(),
              ));
        } else {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => PelayanDashboard(),
              ));
        }
      } on FirebaseAuthException catch (e) {
        String message = '';
        if (e.code == 'user-not-found') {
          message = 'Email salah.';
        } else if (e.code == 'wrong-password') {
          message = 'Password salah.';
        } else {
          message = 'Email atau password salah.';
        }

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message),
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
          // duration: const Duration(seconds: 1),
        ));
      }
    }
  }
}
