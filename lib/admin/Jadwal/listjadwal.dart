import 'package:flutter/material.dart';
import 'package:kidsgbisukhat4/admin/DataPelayan/tambahdata.dart';
import 'package:kidsgbisukhat4/admin/Jadwal/buatjadwal.dart';

class ListJadwal extends StatefulWidget {
  const ListJadwal({super.key});

  @override
  State<ListJadwal> createState() => _ListJadwalState();
}

class _ListJadwalState extends State<ListJadwal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("List Jadwal",
            style: TextStyle(
              fontSize: 20,
            )),
        centerTitle: false,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const BuatJadwal()),
          );
        },
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }
}
