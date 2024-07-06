import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kidsgbisukhat4/admin/Bahan/bahan.dart';
import 'package:kidsgbisukhat4/admin/Berita/berita_screen.dart';
import 'package:kidsgbisukhat4/admin/Daftar%20Izin/daftar_izin.dart';
import 'package:kidsgbisukhat4/admin/DataPelayan/data_guru.dart';
import 'package:kidsgbisukhat4/admin/Jadwal/buatjadwal.dart';
import 'package:kidsgbisukhat4/admin/Daftar%20Izin/daftarizin.dart';
import 'package:kidsgbisukhat4/screen/loginscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardAdmin extends StatefulWidget {
  const DashboardAdmin({super.key});

  @override
  State<DashboardAdmin> createState() => _DashboardAdmin();
}

class _DashboardAdmin extends State<DashboardAdmin> {
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

  logout() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.remove('userPref');
    prefs.setBool('loggedIn', false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 30, left: 5, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Text(
                              dataUser['nama'],
                              // dataUser!['nama'],
                              style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Ruluko",
                                  color: Color.fromARGB(255, 0, 0, 0)),
                            ),
                          ),
                        ],
                      ),
                    ]),
              ),

              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const DataGuru()));
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  tileColor: const Color.fromARGB(255, 0, 0, 0),
                  leading: const Icon(
                    Icons.person_2,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                  title: const Text(
                    "Data Pelayan",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),

              // buat jadwal
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BuatJadwal()));
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  tileColor: const Color.fromARGB(255, 0, 0, 0),
                  leading: const Icon(
                    Icons.date_range,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                  title: const Text(
                    "Buat Jadwal",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),

              // buat berita
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BeritaScreen()));
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  tileColor: const Color.fromARGB(255, 0, 0, 0),
                  leading: const Icon(
                    Icons.newspaper,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                  title: const Text(
                    "Buat Berita",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),

              // upload bahan
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BahanMengajar()));
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  tileColor: const Color.fromARGB(255, 0, 0, 0),
                  leading: const Icon(
                    Icons.book,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                  title: const Text(
                    "Bahan Mengajar",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),

              // pelayan izin
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const DaftarIzin()));
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  tileColor: Colors.black,
                  leading: const Icon(
                    Icons.fork_left,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                  title: const Text(
                    "Daftar Pelayan Izin",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),

              //button keluar
              const SizedBox(height: 40),
              InkWell(
                onTap: () {},
                child: MaterialButton(
                  onPressed: () async {
                    await logout();
                    Navigator.pushAndRemoveUntil(
                        // ignore: use_build_context_synchronously
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LogInScreen(),
                        ),
                        (route) => false);
                  },
                  child: Center(
                    child: Container(
                      height: 35,
                      width: 110,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Center(
                          child: Text(
                            "Keluar",
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _showExitConfirmationDialog(BuildContext context) async {
  logout() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.remove('userPref');
    prefs.setBool('loggedIn', false);
  }

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: const Color.fromARGB(255, 209, 241, 255),
        // title: const Text('Konfirmasi'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Tutup dialog
            },
            child: const Text('Tidak'),
          ),
          TextButton(
            onPressed: () async {
              await logout();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LogInScreen(),
                  ),
                  (route) => false);
            },
            child: const Text('Ya'),
          ),
        ],
      );
    },
  );
}
