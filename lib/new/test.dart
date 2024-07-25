import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class JadwalPage extends StatefulWidget {
  const JadwalPage({super.key});

  @override
  _JadwalPageState createState() => _JadwalPageState();
}

class _JadwalPageState extends State<JadwalPage> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  final TextEditingController _descriptionController = TextEditingController();
  final CollectionReference _jadwalCollection = FirebaseFirestore.instance.collection('jadwal');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Jadwal Harian'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Pilih Tanggal',
                ),
                onTap: () => _selectDate(context),
                validator: (value) {
                  if (_selectedDate == null) {
                    return 'Tanggal tidak boleh kosong';
                  }
                  return null;
                },
                controller: TextEditingController(
                  text: _selectedDate != null
                      ? '${_selectedDate!.day.toString().padLeft(2, '0')}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.year}'
                      : '',
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi Jadwal',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Deskripsi tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitJadwal,
                child: const Text('Tambahkan Jadwal'),
              ),
              const SizedBox(height: 16.0),
              Expanded(child: _buildJadwalList()),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(2020, 1),
      lastDate: DateTime(2030, 12),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light(),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _submitJadwal() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null) {
        return;
      }

      // Konversi ke timestamp
      final timestamp = Timestamp.fromDate(_selectedDate!);

      // Cek apakah tanggal sudah ada di Firestore
      final querySnapshot = await _jadwalCollection
          .where('tanggal', isEqualTo: timestamp)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        _showPeringatan();
      } else {
        // Jika belum ada, tambahkan ke Firestore
        await _jadwalCollection.add({
          'tanggal': timestamp,
          'deskripsi': _descriptionController.text,
        });

        _descriptionController.clear();
        setState(() {
          _selectedDate = null;
        });
        _showSnackbar('Jadwal berhasil ditambahkan!');
      }
    }
  }

  void _showPeringatan() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Peringatan'),
          content: const Text('Tanggal dan bulan yang dimasukkan sudah ada di database!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget _buildJadwalList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _jadwalCollection.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final documents = snapshot.data!.docs;
        return ListView.builder(
          itemCount: documents.length,
          itemBuilder: (context, index) {
            final data = documents[index].data() as Map<String, dynamic>;
            final Timestamp timestamp = data['tanggal'] as Timestamp;
            final DateTime date = timestamp.toDate();
            final deskripsi = data['deskripsi'] as String;

            return ListTile(
              title: Text(deskripsi),
              subtitle: Text('Tanggal: ${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}'),
            );
          },
        );
      },
    );
  }
}
