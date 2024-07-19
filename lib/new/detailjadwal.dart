import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailJadwalPage extends StatefulWidget {
  final dynamic jadwal;
  final dynamic user;
  const DetailJadwalPage({super.key, this.jadwal, this.user});

  @override
  State<DetailJadwalPage> createState() => _DetailJadwalPageState();
}

class _DetailJadwalPageState extends State<DetailJadwalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Jadwal'),
        centerTitle: true,
      ),
      body: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(10),
        children: [
          TextFormField(
            controller: TextEditingController(
                text: DateFormat('EEEE, dd-MMM-yyyy', 'id_ID')
                    .format(widget.jadwal['tanggal'].toDate())),
            readOnly: true,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), label: Text('Tanggal Lahir')),
            onTap: () {},
            validator: (value) {
              if (value!.isEmpty || value == '') {
                return 'Masukkan Tanggal Jadwal';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: TextEditingController(text: widget.jadwal['name']),
            decoration: const InputDecoration(
                border: OutlineInputBorder(), label: Text('Nama Jadwal')),
            keyboardType: TextInputType.streetAddress,
            validator: (value) {
              if (value!.isEmpty || value == '') {
                return 'Masukkan Nama Jadwal';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 10,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Petugas'),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return TextFormField(
                  readOnly: true,
                  controller: TextEditingController(
                      text: widget.jadwal['details'][index]['user']['nama']),
                  decoration: InputDecoration(
                      prefixIcon: widget.jadwal['details'][index]['user']
                                  ['email'] ==
                              widget.user['email']
                          ? const Icon(Icons.person)
                          : null,
                      border: const OutlineInputBorder(),
                      label: Text(widget.jadwal['details'][index]['tugas'])),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(
                    height: 10,
                  ),
              itemCount: widget.jadwal['details'].length)
        ],
      ),
    );
  }
}
