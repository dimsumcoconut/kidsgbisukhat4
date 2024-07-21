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
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text("Detail Jadwal",
            style: TextStyle(
              fontSize: 20,
              color: Colors.white
            )),
        centerTitle: false,
      ),
      body: ListView(
        shrinkWrap: true,
        // physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(10),
        children: [
          const SizedBox(height: 10),
          TextFormField(
            controller: TextEditingController(
                text: DateFormat('EEEE, dd-MMM-yyyy', 'id_ID')
                    .format(widget.jadwal['tanggal'].toDate())),
            readOnly: true,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), label: Text('Tanggal')),
            onTap: () {},
            validator: (value) {
              if (value!.isEmpty || value == '') {
                return 'Masukkan Tanggal Jadwal';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 18,
          ),
          TextFormField(
            controller: TextEditingController(text: widget.jadwal['name']),
            decoration: const InputDecoration(
                border: OutlineInputBorder(), label: Text('Nama')),
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
              Text('Tugas'),
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
                          ? const Icon(Icons.warning)
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
