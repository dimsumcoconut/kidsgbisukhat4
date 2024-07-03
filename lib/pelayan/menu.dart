import 'package:flutter/material.dart';
import 'package:kidsgbisukhat4/pelayan/Berita/berita_page.dart';
import 'package:kidsgbisukhat4/pelayan/pengajuan_izin/daftarpengajuan.dart';
import 'package:kidsgbisukhat4/pelayan/jadwalpelayanan.dart';
import 'package:kidsgbisukhat4/pelayan/unduhbahan.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      shrinkWrap: true,
      childAspectRatio: (200 / 189),
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 13),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.black,
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 233, 233, 233).withOpacity(0.4),
                  spreadRadius: 1,
                  blurRadius: 8,
                ),
              ]),
          child: Column(children: [
            InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const JadwalPelayanan(),
                      ));
                },
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Image.asset("assets/images/date.png", width: 100),
                        // const SizedBox(height: 5),
                        const Text(
                          "Jadwal",
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                )),
          ]),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.black,
          ),
          child: Column(children: [
            InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DaftarPengajuan(),
                      ));
                },
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Image.asset("assets/images/izin.png", width: 100),
                        // const SizedBox(height: 5),
                        const Text(
                          "Pengajuan Izin",
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                )),
          ]),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.black,
          ),
          child: Column(children: [
            InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Bahan_Mengajar(),
                      ));
                },
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Image.asset("assets/images/download.png", width: 100),
                        // const SizedBox(height: 5),
                        const Text(
                          "Bahan Mengajar",
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                )),
          ]),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.black,
          ),
          child: Column(children: [
            InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BeritaPelayan(),
                      ));
                },
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Image.asset("assets/images/news.png", width: 100),
                        // const SizedBox(height: 5),
                        const Text(
                          "Berita",
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                )),
          ]),
        ),
      ],
    );
  }
}
