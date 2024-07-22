import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kidsgbisukhat4/consts.dart';

class Add_Bahan extends StatefulWidget {
  @override
  _Add_BahanState createState() => _Add_BahanState();
}

class _Add_BahanState extends State<Add_Bahan> with SingleTickerProviderStateMixin {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController bulanController = TextEditingController();
  final TextEditingController bahanController = TextEditingController();
  final TextEditingController keteranganController = TextEditingController();
  bool isLoadingSave = false;

  bool pickerIsExpanded = false;
  int _pickerYear = DateTime.now().year;
  DateTime _selectedMonth = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    1,
  );
  DateTime? dateTime;

  dynamic _pickerOpen = false;

  void switchPicker() {
    setState(() {
      _pickerOpen ^= true;
    });
  }

  final CollectionReference collectionbahan =
      FirebaseFirestore.instance.collection('bahan');

  createData(dynamic bahan) async {
    String message = '';
    dynamic data;
    StatusType status;
    try {
      await collectionbahan.add(bahan).then(
        (value) {
          bahan['id'] = value.id;
          collectionbahan.doc(value.id).set(bahan);
        },
      );
      data = bahan;
      status = StatusType.success;
      message = 'Tambah Bahan Sukses';
    } catch (e) {
      message = 'Gagal ';
      data = null;
      status = StatusType.error;
    }
    return Response(data: data, status: status, message: message);
  }

  @override
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
              backgroundColor: Colors.amber,
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
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(10),
          children: [
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
            const SizedBox(
              height: 10,
            ),
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
            TextFormField(
              controller: keteranganController,
              maxLines: 4,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), label: Text('Keterangan')),
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
            Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                        ),
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            setState(() {
                              isLoadingSave = true;
                            });
                            Response response;

                            Map<String, dynamic> bahan = {
                              'bulan': Timestamp.fromDate(_selectedMonth!),
                              'bahan': bahanController.text,
                              'keterangan': keteranganController.text,
                              'created_at': Timestamp.now(),
                              'updated_at': Timestamp.now(),
                            };
                            response = await createData(bahan);
                            setState(() {
                              isLoadingSave = false;
                            });
                            if (context.mounted) {
                              // if (widget.user['jabatan'] == 'Admin') {
                              Navigator.of(context).pop();
                              // } else {
                              //   bulanController.clear();
                              //   tanggalbahanController.clear();
                              // }

                              var snackBar = SnackBar(
                                behavior: SnackBarBehavior.floating,
                                content: Text(response.message!),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          }
                        },
                        child: isLoadingSave
                            ? const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Center(
                                    child: SizedBox(
                                      width: 14,
                                      height: 14,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 14),
                                  Text('Loading...')
                                ],
                              )
                            : const Text('Tambah Bahan'))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
