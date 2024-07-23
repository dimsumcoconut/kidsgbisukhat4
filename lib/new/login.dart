import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kidsgbisukhat4/consts.dart';
import 'package:kidsgbisukhat4/new/mainpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final focusEmail = FocusNode();
  final focusPassword = FocusNode();
  bool seePassword = false;
  bool isLoading = false;
  final CollectionReference collectionUser =
      FirebaseFirestore.instance.collection('users');
  Future<dynamic> login(
      {required String email, required String password}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    String message = '';
    dynamic data;
    StatusType status;

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      log(userCredential.user!.uid);
      // if (userCredential.user != null) {
      data = await collectionUser
          .where('email', isEqualTo: userCredential.user!.email!)
          .get()
          .then((querySnapshot) {
        Map<String, dynamic> user = {
          'nama': querySnapshot.docs.first['nama'],
          'email': querySnapshot.docs.first['email'],
          'jabatan': querySnapshot.docs.first['jabatan'],
          'password': querySnapshot.docs.first['password'],
        };
        return user;
      });
      print(data);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('userPref', jsonEncode(data));
      prefs.setBool('loggedIn', true);
      log(prefs.getString('userPref')!);
      status = StatusType.success;
      message = 'Login Suksess';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided.';
      } else if (e.code == 'invalid-credential') {
        message = 'email atau password tidak sesuai';
      } else {
        message = e.code;
      }
      data = null;
      status = StatusType.error;
    }

    return Response(data: data, message: message, status: status);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: formKey,
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
                              fontSize: 20,
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
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty || value == '') {
                          return 'Harap masukkan email.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: passwordController,
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
                          label: const Text('Password',
                              style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                              fontSize: 16)),
                          suffixIcon: IconButton(
                              onPressed: () {
                                seePassword = !seePassword;
                                setState(() {});
                              },
                              icon: Icon(
                                seePassword == true
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ))),
                      keyboardType: seePassword == true
                          ? TextInputType.text
                          : TextInputType.visiblePassword,
                      obscureText: seePassword == true ? false : true,
                      validator: (value) {
                        if (value!.isEmpty || value == '') {
                          return 'Masukkan Password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
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
                                      isLoading = true;
                                    });
                                    Response? response;

                                    response = await login(
                                      email: emailController.text,
                                      password: passwordController.text,
                                    );
                                    setState(() {
                                      isLoading = false;
                                    });
                                    if (response!.status ==
                                        StatusType.success) {
                                      if (context.mounted) {
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                MainPage(user: response!.data),
                                          ),
                                          (route) => false,
                                        );
                                      }
                                    }
                                    if (context.mounted) {
                                      // Navigator.of(context).pop();

                                      var snackBar = SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        content: Text(response.message!),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    }
                                  }
                                },
                                child: isLoading
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
                                    : const Text('Login'))),
                      ],
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
}
