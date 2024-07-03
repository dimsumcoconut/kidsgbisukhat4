import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kidsgbisukhat4/pelayan/Berita/berita_page.dart';
import 'package:kidsgbisukhat4/pelayan/pengajuan_izin/ajukanizin.dart';
import 'package:kidsgbisukhat4/pelayan/pengajuan_izin/daftarpengajuan.dart';
import 'package:kidsgbisukhat4/pelayan/jadwalpelayanan.dart';
import 'package:kidsgbisukhat4/pelayan/unduhbahan.dart';
import 'package:kidsgbisukhat4/screen/loginscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PelayanDashboard extends StatefulWidget {
  const PelayanDashboard({super.key});

  @override
  State<PelayanDashboard> createState() => _PelayanDashboardState();
}

class _PelayanDashboardState extends State<PelayanDashboard> {
  @override
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
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.only(top: 30, left: 5, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(bottom: 10, left: 15),
              child: Row(children: [
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 5),
                      child: Text(
                        "Shallom, ",
                        style: TextStyle(
                            fontSize: 25,
                            fontFamily: "Sansita",
                            color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Text(
                        "Kak " + dataUser['nama'] + "!",
                        // dataUser!['nama'],
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Ruluko",
                            color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                    ),
                    Text(
                      // ignore: prefer_interpolation_to_compose_strings
                      "Email: " + dataUser['email'],
                      style: const TextStyle(
                          fontSize: 15,
                          fontFamily: "One",
                          color: Color.fromARGB(255, 172, 172, 172)),
                    ),
                  ],
                ),
              ]),
            ),

            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                "Menu",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // jadwal pelayanan
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const JadwalPelayanan()));
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                tileColor: Color.fromARGB(255, 0, 0, 0),
                leading: const Icon(
                  Icons.date_range_outlined,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                title: const Text(
                  "Jadwal Pelayanan",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

            // bahan mengajar
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Bahan_Mengajar()));
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                tileColor: Color.fromARGB(255, 0, 0, 0),
                leading: const Icon(
                  Icons.download,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                title: const Text(
                  "Bahan Mengajar",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

            // pengajuan izin
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AjukanIzin()));
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                tileColor: Color.fromARGB(255, 0, 0, 0),
                leading: const Icon(
                  Icons.edit,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                title: const Text(
                  "Pengajuan Izin",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

            // berita
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BeritaPelayan()));
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                tileColor: Color.fromARGB(255, 0, 0, 0),
                leading: const Icon(
                  Icons.newspaper,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                title: const Text(
                  "Berita",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

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
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        "Keluar",
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
