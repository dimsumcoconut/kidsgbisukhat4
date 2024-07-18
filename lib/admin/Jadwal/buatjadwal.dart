import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BuatJadwal extends StatefulWidget {
  const BuatJadwal({super.key});

  @override
  State<BuatJadwal> createState() => _BuatJadwalState();
}

class _BuatJadwalState extends State<BuatJadwal> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController tgl = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController nama = TextEditingController();

  void gantiUserIzin(List<String> user, List<Izin> izin) {
    List<String> userUpdated = List.from(user);
    Random random = Random();

    for (var item in izin) {
      if (item.status == "1") {
        // Temukan indeks user yang izin
        int index = userUpdated.indexOf(item.nama!);
        if (index != -1) {
          // Buat daftar user yang bisa dipilih sebagai pengganti (kecuali yang izin)
          List<String> candidates = List.from(user)..remove(item.nama);
          // Pilih user pengganti secara acak
          String replacement = candidates[random.nextInt(candidates.length)];
          // Ganti user yang izin dengan user pengganti
          userUpdated[index] = replacement;
        }
      }
    }
    setState(() {
      nama = userUpdated;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Buat Jadwal", style: TextStyle(fontSize: 18)),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.only(top: 30, left: 5, right: 20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //email
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 15),
                    child: TextField(
                      controller: tgl,
                      decoration: InputDecoration(
                        labelText: 'Tanggal',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1970),
                          lastDate: DateTime(2100),
                        );

                        if (date != null) {
                          tgl.text = DateFormat('dd MMMM yyyy').format(date);
                        }
                      },
                    ),
                  ),

                  //nama
                  const SizedBox(height: 20),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 15),
                    child: TextFormField(
                      controller: nama,
                      decoration: InputDecoration(
                          labelText: 'Nama',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: Colors.black))),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Harap diisi";
                        }
                        return null;
                      },
                      onChanged: (value) {},
                    ),
                  ),

                  const SizedBox(height: 40),
                  Padding(
                    padding: EdgeInsets.only(left: 19),
                    child: Row(
                      children: [
                        Text(
                          "Tugas: ",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              nama.shuffle();
                            });
                            gantiUserIzin(nama, izin);
                          },
                          splashRadius: 24,
                          icon: const Icon(Icons.edit_outlined),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
