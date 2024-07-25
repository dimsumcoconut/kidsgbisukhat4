import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class TambahBahan extends StatefulWidget {
  const TambahBahan({super.key});

  @override
  _TambahBahanState createState() => _TambahBahanState();
}

class _TambahBahanState extends State<TambahBahan> {
  final _formKey = GlobalKey<FormState>();
  DateTime? dateTime;
  final TextEditingController bulanController = TextEditingController();
  final TextEditingController bahanController = TextEditingController();
  // final TextEditingController keteranganController = TextEditingController();
  // final TextEditingController _descriptionController = TextEditingController();

  final CollectionReference bahanCollection =
      FirebaseFirestore.instance.collection('bahan');

  bool pickerIsExpanded = false;
  int _pickerYear = DateTime.now().year;
  DateTime _selectedMonth = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    1,
  );
  dynamic _pickerOpen = false;

  void switchPicker() {
    setState(() {
      _pickerOpen ^= true;
    });
  }

  List<Widget> generateRowOfMonths(from, to) {
    List<Widget> months = [];
    for (int i = from; i <= to; i++) {
      DateTime dateTime = DateTime(_pickerYear, i, 1);
      final backgroundColor = dateTime.isAtSameMomentAs(_selectedMonth);
      // ? Theme.of(context).accentColor
      // : Colors.transparent;
      months.add(
        AnimatedSwitcher(
          duration: kThemeChangeDuration,
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          child: TextButton(
            key: ValueKey(backgroundColor),
            onPressed: () {
              setState(() {
                _selectedMonth = dateTime;
              });
              bulanController.text = DateFormat.yMMMM().format(_selectedMonth);
            },
            style: TextButton.styleFrom(
              // backgroundColor: Colors.amber,
              shape: CircleBorder(),
            ),
            child: Text(
              DateFormat('MMM').format(dateTime),
            ),
          ),
        ),
      );
    }
    return months;
  }

  List<Widget> generateMonths() {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: generateRowOfMonths(1, 6),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: generateRowOfMonths(7, 12),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        title: const Text("Tambah Bahan",
            style: TextStyle(fontSize: 20, color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: bulanController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), label: Text('Bulan')),
                onTap: switchPicker,

                // keyboardType: TextInputType.streetAddress,
                validator: (value) {
                  if (value!.isEmpty || value == '') {
                    return 'Harap Diisi.';
                  }
                  return null;
                },
              ),
              Material(
                color: Theme.of(context).cardColor,
                child: AnimatedSize(
                  curve: Curves.easeInOut,
                  // vsync: this,
                  duration: Duration(milliseconds: 300),
                  child: Container(
                    height: _pickerOpen ? null : 0.0,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _pickerYear = _pickerYear - 1;
                                });
                              },
                              icon: Icon(Icons.navigate_before_rounded),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  _pickerYear.toString(),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _pickerYear = _pickerYear + 1;
                                });
                              },
                              icon: Icon(Icons.navigate_next_rounded),
                            ),
                          ],
                        ),
                        ...generateMonths(),
                        SizedBox(
                          height: 10.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              // TextFormField(
              //   controller: _descriptionController,
              //   decoration: const InputDecoration(
              //     labelText: 'Deskripsi Jadwal',
              //   ),
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Deskripsi tidak boleh kosong';
              //     }
              //     return null;
              //   },
              // ),
              // const SizedBox(
              //   height: 10,
              // ),
              TextFormField(
                controller: bahanController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Link Google Drive')),
                keyboardType: TextInputType.streetAddress,
                validator: (value) {
                  if (value!.isEmpty || value == '') {
                    return 'Harap Diisi.';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              // TextFormField(
              //   controller: keteranganController,
              //   maxLines: 4,
              //   decoration: const InputDecoration(
              //       border: OutlineInputBorder(), label: Text('Keterangan')),
              //   keyboardType: TextInputType.streetAddress,
              //   validator: (value) {
              //     if (value!.isEmpty || value == '') {
              //       return 'Harap Diisi.';
              //     }
              //     return null;
              //   },
              // ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                      ),
                      onPressed: submitBahan,
                      child: const Text('Tambahkan Bahan'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              // Expanded(child: _buildJadwalList()),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectMonth(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dateTime ?? now,
      firstDate: DateTime(2020, 1),
      lastDate: DateTime(2030, 12),
      initialDatePickerMode: DatePickerMode.year, // Set initial mode to year
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light(),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedMonth =
            DateTime(picked.year, picked.month); // Resetting day to 1
      });
    }
  }

  Future<void> submitBahan() async {
    if (_formKey.currentState!.validate()) {
      // if (_selectedMonth == null) {
      //   return;
      // }

      // final bulan =
      //     '${_selectedMonth!.month.toString().padLeft(2, '0')}-${_selectedMonth!.year}';

      // Cek apakah bulan sudah ada di Firestore
      final querySnapshot =
          await bahanCollection.where('bulan', isEqualTo: _selectedMonth).get();

      if (querySnapshot.docs.isNotEmpty) {
        _showPeringatan();
      } else {
        // Jika belum ada, tambahkan ke Firestore
        await bahanCollection.add({
          'bulan': _selectedMonth,
          'bahan': bahanController.text,
          'created_at': Timestamp.now(),
          'updated_at': Timestamp.now(),
        });

        bulanController.clear();
        bahanController.clear();

        dateTime = null;
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
          content: const Text(
              'Sudah pernah menambahkan bahan dengan bulan tersebut.'),
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

  // Widget _buildJadwalList() {
  //   return StreamBuilder<QuerySnapshot>(
  //     stream: bahanCollection.snapshots(),
  //     builder: (context, snapshot) {
  //       if (!snapshot.hasData) {
  //         return const Center(child: CircularProgressIndicator());
  //       }

  //       final documents = snapshot.data!.docs;
  //       return ListView.builder(
  //         itemCount: documents.length,
  //         itemBuilder: (context, index) {
  //           final data = documents[index].data() as Map<String, dynamic>;
  //           final bulan = data['bulan'] as String;
  //           final deskripsi = data['deskripsi'] as String;

  //           return ListTile(
  //             title: Text(deskripsi),
  //             subtitle: Text('Bulan: $bulan'),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }
}
