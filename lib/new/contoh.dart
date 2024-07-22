// class _MonthPickerScreenState extends State<MonthPickerScreen> {
//   DateTime? _selected;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Month Picker Example'),
//       ),
//       body: Form(

//         child: TextFormField(
//   validator: value.isEmpty ? 'this field is required' : null,
//   readOnly: true,
//   style: TextStyle(fontSize: 13.0),
//   decoration: InputDecoration(
//     hintStyle: TextStyle(fontSize: 13.0),
//     hintText: 'Pick Year',
//     contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
//     border: OutlineInputBorder(),
//     suffixIcon: Icon(Icons.calendar_today),
//   ),
//   onTap: () => handleReadOnlyInputClick(context),
// )

// void handleReadOnlyInputClick(context) {
//   showBottomSheet(
//       context: context,
//       builder: (BuildContext context) => Container(
//         width: MediaQuery.of(context).size.width,
//         child: YearPicker(
//           selectedDate: DateTime(1997),
//           firstDate: DateTime(1995),
//           lastDate: DateTime.now(),
//           onChanged: (val) {
//             print(val);
//             Navigator.pop(context);
//           },
//         ),
//     )
//   );
// },
//       )
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kidsgbisukhat4/consts.dart';

class Time extends StatefulWidget {
  @override
  _TimeState createState() => _TimeState();
}

class _TimeState extends State<Time> with SingleTickerProviderStateMixin {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController bulanController= TextEditingController();
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

  final CollectionReference collectionIzin =
      FirebaseFirestore.instance.collection('bahan');

  createData(dynamic izin) async {
    String message = '';
    dynamic data;
    StatusType status;
    try {
      await collectionIzin.add(izin).then(
        (value) {
          izin['id'] = value.id;
          collectionIzin.doc(value.id).set(izin);
        },
      );
      data = izin;
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
            //  TextFormField(
            //   controller: bulanController,
            //   decoration: const InputDecoration(
            //       border: OutlineInputBorder(),
            //       label: Text('Klik Tombol Di Bawah')),
                  
            //   keyboardType: TextInputType.streetAddress,
            //   validator: (value) {
            //     if (value!.isEmpty || value == '') {
            //       return 'Harap Diisi.';
            //     }
            //     return null;
            //   },
            // ),
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
            SizedBox(
              height: 10,
            ),
            Text(DateFormat.yMMMM().format(_selectedMonth)),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                ),
                onPressed: switchPicker,
                child: Text(
                  'Pilih Bulan',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
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

                            Map<String, dynamic> izin = {
                              'bulan': Timestamp.fromDate(dateTime!),
                              'bahan': bahanController.text,
                              'keterangan': keteranganController.text,
                              'created_at': Timestamp.now(),
                              'updated_at': Timestamp.now(),
                            };
                            response = await createData(izin);
                            setState(() {
                              isLoadingSave = false;
                            });
                            if (context.mounted) {
                              // if (widget.user['jabatan'] == 'Admin') {
                              Navigator.of(context).pop();
                              // } else {
                              //   bulanController.clear();
                              //   tanggalIzinController.clear();
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
