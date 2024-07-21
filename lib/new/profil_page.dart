import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kidsgbisukhat4/consts.dart';
import 'package:kidsgbisukhat4/new/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  Map<String, dynamic> dataUser = {};
  getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    dataUser = jsonDecode(prefs.getString('userPref')!);

    setState(() {});
  }

  showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.deepOrange,
      action: SnackBarAction(
        label: 'Tutup',
        onPressed: () {},
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future logout() async {
    String message = '';
    dynamic data;
    StatusType status;
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      auth.signOut();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // prefs.remove('userPref');
      prefs.setBool('loggedIn', false);
      message = 'Logout Sukses';
      data = null;
      status = StatusType.success;
    } catch (e) {
      message = e.toString();
      data = null;
      status = StatusType.error;
    }
    return Response(data: null, status: status, message: message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        title: const Text("Profil",
            style: TextStyle(fontSize: 20, color: Colors.white)),
        centerTitle: false,
      ),
      body: Column(
        children: [
          const SizedBox(width: 90),
          Padding(
            padding: const EdgeInsets.only(bottom: 20, left: 1),
            child: Row(children: [
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 5),
                    child: Text(
                      "Nama: " + dataUser['nama'],
                      style: TextStyle(fontSize: 15, color: Colors.black),
                    ),
                  ),
                  Text(
                    // ignore: prefer_interpolation_to_compose_strings
                    "Email: " + dataUser['email'],
                    style: const TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(255, 172, 172, 172)),
                  ),
                ],
              ),
            ]),
          ),
          ListTile(
            onTap: () async {
              Response response = await logout();
              if (response.status == StatusType.success) {
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (route) => false,
                  );
                }
              }
              if (context.mounted) {
                var snackBar = SnackBar(
                  behavior: SnackBarBehavior.floating,
                  content: Text(response.message!),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            title: const Text('Logout'),
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
          )
        ],
      ),
    );
  }
}
