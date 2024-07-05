import 'package:flutter/material.dart';

class JadwalNew extends StatefulWidget {
  const JadwalNew({super.key});

  @override
  State<JadwalNew> createState() => _JadwalNewState();
}

class _JadwalNewState extends State<JadwalNew> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text(
          "Buat Jadwal",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
