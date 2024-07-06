import 'package:flutter/material.dart';
import 'package:kidsgbisukhat4/pelayan/Jadwal/jadwalminggu1.dart';
import 'package:kidsgbisukhat4/pelayan/Jadwal/jadwalminggu2.dart';
import 'package:kidsgbisukhat4/pelayan/Jadwal/jadwalminggu3.dart';
import 'package:kidsgbisukhat4/pelayan/Jadwal/jadwalminggu4.dart';
import 'package:kidsgbisukhat4/pelayan/Jadwal/jadwalminggu5.dart';

class JadwalPelayanan extends StatefulWidget {
  const JadwalPelayanan({super.key});

  @override
  State<JadwalPelayanan> createState() => _JadwalPelayananState();
}

class _JadwalPelayananState extends State<JadwalPelayanan>
    with SingleTickerProviderStateMixin {
  // TabController? controller;
  // final screentitle = ['1', '2', '3', '4', '5'];

  // @override
  // void initState() {
  //   controller = TabController(length: 5, vsync: this);
  //   controller!.addListener(() {
  //     setState(() {});
  //   });
  //   super.initState();
  // }

  // @override
  // void dispose() {
  //   controller!.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Jadwal Pelayanan",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 30, left: 5, right: 20, bottom: 20),
          child: Column(children: [
            const Text("Minggu ke",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(width: 0),
            DefaultTabController(
                length: 5,
                child: Column(children: [
                  Material(
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      child: TabBar(
                          physics: const ClampingScrollPhysics(),
                          padding: const EdgeInsets.only(top: 10),
                          unselectedLabelColor:
                              const Color.fromARGB(255, 0, 0, 0),
                          indicatorSize: TabBarIndicatorSize.label,
                          tabs: [
                            Tab(
                              child: Container(
                                height: 35,
                                child: const Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "1",
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            Tab(
                              child: Container(
                                height: 35,
                                child: const Align(
                                  alignment: Alignment.center,
                                  child: Text("2",
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ),
                            Tab(
                              child: Container(
                                height: 35,
                                child: const Align(
                                  alignment: Alignment.center,
                                  child: Text("3",
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ),
                            Tab(
                              child: Container(
                                height: 35,
                                child: const Align(
                                  alignment: Alignment.center,
                                  child: Text("4",
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ),
                            Tab(
                              child: Container(
                                height: 35,
                                child: const Align(
                                  alignment: Alignment.center,
                                  child: Text("5",
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ),
                          ]),
                    ),
                  ),
                  Container(
                    width: double.maxFinite,
                    height: 500,
                    child: const TabBarView(children: [
                      JadwalMinggu1(),
                      JadwalMinggu2(),
                      JadwalMinggu3(),
                      JadwalMinggu4(),
                      JadwalMinggu5(),
                    ]),
                  )
                ]))
          ]),
        ),
      ),
    );
  }
}
