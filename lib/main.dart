import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kidsgbisukhat4/admin/dashboardadmin.dart';
import 'package:kidsgbisukhat4/pelayan/dashboard_pelayan_screen.dart';
import 'package:kidsgbisukhat4/screen/loginscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBdcLg1jOLr-u7b6GzvFgDJkwQ-yPwU3hw",
          authDomain: "kidsgbisukhat4.firebaseapp.com",
          projectId: "kidsgbisukhat4",
          storageBucket: "kidsgbisukhat4.appspot.com",
          messagingSenderId: "850745654380",
          appId: "1:850745654380:web:be2b64effbc2501a36ec49",
          measurementId: "G-T97WJHRDCR"));
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  Map<String, dynamic> dataUser = {};

  bool isLogin = false;
  getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isLogin = prefs.getBool('loggedIn') ?? false;
    dataUser = jsonDecode(prefs.getString('userPref')!);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      home: isLogin
          ? dataUser['jabatan'] == 'Admin'
              ? const DashboardAdmin()
              : const PelayanDashboard()
          : const LogInScreen(),
    );
  }
}
