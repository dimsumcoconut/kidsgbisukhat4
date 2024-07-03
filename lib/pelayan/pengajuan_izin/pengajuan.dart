import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kidsgbisukhat4/pelayan/my_firebase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Pengajuan extends StatefulWidget {
  const Pengajuan({super.key});

  @override
  State<Pengajuan> createState() => _PengajuanState();
}

class _PengajuanState extends State<Pengajuan> {
  final _formKey = GlobalKey<FormState>();
  final tanggalController = TextEditingController();
  final namaController = TextEditingController();
  final alasanControler = TextEditingController();

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
    namaController.text = dataUser['nama'];
    setState(() {});
  }

  void addPengajuan() async {
    if (_formKey.currentState!.validate()) {
      try {
        await MyFirebase.izinCollection.add({
          'tanggal': tanggalController.text.trim(),
          'nama': namaController.text.trim(),
          'alasan': alasanControler.text.trim(),
          'status': "0",
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Izin berhasil diajukan'),
            backgroundColor: const Color.fromARGB(255, 99, 99, 99),
          ),
        );
        Navigator.pop(context);
      } on FirebaseException {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Gagal menambahkan'),
            backgroundColor: const Color.fromARGB(255, 0, 0, 0),
          ),
        );
      }
    } else {
      // show snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Data harap diisi'),
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        ),
      );
    }
  }

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
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: namaController,
                  enabled: false,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: tanggalController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Harap  diisi";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: "Tanggal: (01 Januari 2024)",
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: alasanControler,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Wajib diisi";
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    hintText: "Alasan",
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                    onPressed: addPengajuan, child: const Text("Ajukan Izin")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
