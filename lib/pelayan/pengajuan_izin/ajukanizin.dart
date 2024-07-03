import 'package:flutter/material.dart';
import 'package:kidsgbisukhat4/admin/Jadwal/Minggu%201/tugasminggu1.dart';
import 'package:kidsgbisukhat4/admin/Jadwal/Minggu%202/tugasminggu2.dart';
import 'package:kidsgbisukhat4/admin/Jadwal/Minggu%203/tugasminggu3_screen.dart';
import 'package:kidsgbisukhat4/admin/Jadwal/Minggu%204/tugasminggu4_screen.dart';
import 'package:kidsgbisukhat4/admin/Jadwal/Minggu%205/tugasminggu5.dart';
import 'package:kidsgbisukhat4/pelayan/pengajuan_izin/minggu1/izin_minggu1.dart';
import 'package:kidsgbisukhat4/pelayan/pengajuan_izin/minggu2/izin2.dart';
import 'package:kidsgbisukhat4/pelayan/pengajuan_izin/minggu3/izin3.dart';
import 'package:kidsgbisukhat4/pelayan/pengajuan_izin/minggu4/izin4.dart';
import 'package:kidsgbisukhat4/pelayan/pengajuan_izin/minggu5/izin5.dart';

class AjukanIzin extends StatefulWidget {
  const AjukanIzin({super.key});

  @override
  State<AjukanIzin> createState() => _AjukanIzinState();
}

class _AjukanIzinState extends State<AjukanIzin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Ajukan Izin",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 30, left: 5, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const IzinMinggu1()));
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    padding: const EdgeInsets.symmetric(
                      vertical: 11,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 240, 240, 240),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(children: [
                      Icon(Icons.calendar_month),
                      SizedBox(width: 15),
                      Text("Minggu 1"),
                    ]),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Izin2()));
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    padding: const EdgeInsets.symmetric(
                      vertical: 11,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 240, 240, 240),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(children: [
                      Icon(Icons.calendar_month),
                      SizedBox(width: 15),
                      Text("Minggu 2"),
                    ]),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Izin3()));
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    padding: const EdgeInsets.symmetric(
                      vertical: 11,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 240, 240, 240),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(children: [
                      Icon(Icons.calendar_month),
                      SizedBox(width: 15),
                      Text("Minggu 3"),
                    ]),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Izin4()));
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    padding: const EdgeInsets.symmetric(
                      vertical: 11,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 240, 240, 240),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(children: [
                      Icon(Icons.calendar_month),
                      SizedBox(width: 15),
                      Text("Minggu 4"),
                    ]),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Izin5()));
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    padding: const EdgeInsets.symmetric(
                      vertical: 11,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 240, 240, 240),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(children: [
                      Icon(Icons.calendar_month),
                      SizedBox(width: 15),
                      Text("Minggu 5"),
                    ]),
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
