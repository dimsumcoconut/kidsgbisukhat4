import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kidsgbisukhat4/new/login.dart';
import 'package:kidsgbisukhat4/new/mainpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBdcLg1jOLr-u7b6GzvFgDJkwQ-yPwU3hw",
          authDomain: "kidsgbisukhat4.firebaseapp.com",
          projectId: "kidsgbisukhat4",
          storageBucket: "kidsgbisukhat4.appspot.com",
          messagingSenderId: "850745654380",
          appId: "1:850745654380:web:be2b64effbc2501a36ec49",
          measurementId: "G-T97WJHRDCR"));
  initializeDateFormatting();
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  prefs.then(
    (value) {
      runApp(const MyApp());
    },
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  bool loggedIn = false;
  dynamic user;
  init() async {
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    loggedIn = prefs.getBool('loggedIn') ?? false;
    if (loggedIn) {
      user = jsonDecode(prefs.getString('userPref')!);
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: false,
      ),
      debugShowCheckedModeBanner: false,
      home: loggedIn
          ? MainPage(
              user: user,
            )
          : const LoginPage(),
    );
  }
}
