import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kidsgbisukhat4/consts.dart';
import 'package:kidsgbisukhat4/new/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
        centerTitle: true,
        title: const Text('Profile Page'),
      ),
      body: Column(
        children: [
          const SizedBox(width: 100, height: 100, child: FlutterLogo()),
          ListTile(
            onTap: () {},
            title: const Text('Edit Profile'),
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
          ),
          ListTile(
              onTap: () {},
              title: const Text('Dark Mode'),
              trailing: Switch(
                value: false,
                onChanged: (value) {},
              )),
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
