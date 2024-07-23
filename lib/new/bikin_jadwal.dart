import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import 'package:kidsgbisukhat4/consts.dart';

class BikinJadwal extends StatefulWidget {
  @override
  _BikinJadwalState createState() => _BikinJadwalState();
}

class _BikinJadwalState extends State<BikinJadwal> {
  final TextEditingController tanggalJadwalController = TextEditingController();
  final TextEditingController namaJadwalController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  DateTime? dateTime;

  List<String> tugas = [
    'WL',
    'Singer',
    'Firman Kelas Kecil',
    'Firman Kelas Besar',
    'Multimedia',
    'Doa',
    'Usher',
  ];
  bool isLoadingSave = false;
  List<Map<String, dynamic>> listUsers = [];
  List<dynamic> listAvailableUsers = [];
  List<dynamic> listNotAvailableUsers = [];
  //mendapatkan user yg izin
  final CollectionReference collectionIzin =
      FirebaseFirestore.instance.collection('izin');
//mendapatkan tugas
  final CollectionReference collectionTugas =
      FirebaseFirestore.instance.collection('tugass');
  //mendapatkan semua user
  final CollectionReference collectionUser =
      FirebaseFirestore.instance.collection('users');

  final CollectionReference collectionJadwal =
      FirebaseFirestore.instance.collection('jadwals');
  final CollectionReference collectionTemp =
      FirebaseFirestore.instance.collection('temp');
  cekAvailableUser() async {
    listAvailableUsers.clear();
    //available user
//cari dari collection izin yg tgl izin != dateTime dan statu !=1
    List<dynamic> data =
        await collectionIzin.get().then((value) => value.docs.map(
              (e) {
                Map<String, dynamic> izin = {
                  'id': e['id'],
                  'user': e['user'],
                  'alasan': e['alasan'],
                  'status': e['status'],
                  'tanggal_izin': e['tanggal_izin'],
                  'created_at': e['created_at'],
                  'updated_at': e['updated_at'],
                };
                return izin;
              },
            ).toList());
    listNotAvailableUsers = data
        .where((element) =>
            element['status'] == 1 &&
            element['tanggal_izin'] == Timestamp.fromDate(dateTime!))
        .toList();

    List<dynamic> getuser =
        await collectionUser.get().then((value) => value.docs
            .map((e) {
              Map<String, dynamic> user = {
                'nama': e['nama'],
                'email': e['email'],
                'jabatan': e['jabatan'],
                'password': e['password'],
              };
              return user;
            })
            .where(
              (element) => element['jabatan'] == 'Guru',
            )
            .toList());

    List<dynamic> dataBaru = [];
    //membndingkan dengan data izin
    for (var user in getuser) {
      dynamic value = await listNotAvailableUsers.firstWhereOrNull(
          (element) => element['user']['email'] == user['email']);
      if (value == null) {
        dataBaru.add(user);
        // listAvailableUsers.add(user);
      }
    }
    List<dynamic> temp = await collectionTemp.get().then((value) => value.docs
        .map(
          (e) {
            Map<String, dynamic> izin = {
              'tugas': e['tugas'],
              'user': e['user'],
              'created_at': e['created_at'],
            };
            return izin;
          },
        )
        .sorted((a, b) => a['created_at'].compareTo(b['created_at']))
        .toList());

    //membandingkan dgn data yg sdah dapat jadwal
    for (var item in dataBaru) {
      dynamic value = await temp.firstWhereOrNull(
          (element) => element['user']['email'] == item['email']);
      if (value == null) {
        listAvailableUsers.add(item);
      }
    }
    listAvailableUsers.shuffle();
    List<dynamic> userTambahan = [];
    if (listAvailableUsers.length < tugas.length) {
      //kurang user yg availble
      //ambil user dari yang sudah dapat jadwal sebelumnya
      for (var i = 0; i < temp.length; i++) {
        userTambahan.add(temp[i]['user']);
      }
      userTambahan.shuffle();
    }
    listAvailableUsers.addAll(userTambahan);
    print(listAvailableUsers.length < tugas.length ? 'User Kurang' : 'Cukup');
    setState(() {});
  }

  simpanJadwal(dynamic jadwal) async {
    String message = '';
    dynamic data;
    StatusType status;
    try {
      await collectionJadwal.add(jadwal).then(
        (value) {
          jadwal['id'] = value.id;
          collectionJadwal.doc(value.id).set(jadwal);
        },
      );
      //menyimpan user yg sudah kebagian jadwal
      for (var element in jadwal['details']) {
        await collectionTemp.add(element);
      }
      //
      await hapusTemp();

      data = jadwal;
      status = StatusType.success;
      message = 'Sukses Membuat Jadwal';
    } catch (e) {
      data = null;
      status = StatusType.error;
      message = 'Gagal Membuat Jadwal';
    }
    return Response(data: data, status: status, message: message);
  }

  hapusTemp() async {
    List<dynamic> getuser =
        await collectionUser.get().then((value) => value.docs
            .map((e) {
              Map<String, dynamic> user = {
                'nama': e['nama'],
                'email': e['email'],
                'jabatan': e['jabatan'],
                'password': e['password'],
              };
              return user;
            })
            .where(
              (element) => element['jabatan'] == 'Guru',
            )
            .toList());
    List<dynamic> temp = await collectionTemp.get().then((value) => value.docs
        .map(
          (e) {
            Map<String, dynamic> temp = {
              'id': e.id,
              'tugas': e['tugas'],
              'user': e['user'],
              'created_at': e['created_at'],
            };
            return temp;
          },
        )
        .sorted((a, b) => a['created_at'].compareTo(b['created_at']))
        .toList());
    if (temp.length >= getuser.length) {
      for (var i = 0; i < getuser.length; i++) {
        var id = temp[i]['id'];
        print(id);
        print(temp[i]['user']['name']);
        collectionTemp.doc(id).delete();
      }
    }
  }

DateTime pickedDate =
      DateTime.now(); // Default example date: 28th July 2024

  // DateTime pickedDate =
  //     DateTime(2024, 7, 28); // Default example date: 28th July 2024

  @override
  void initState() {
    super.initState();
    _calculateWeekOfMonth(pickedDate);
  }

  /// Function to calculate the week of the month
  int weekOfMonth(DateTime date) {
    DateTime firstDayOfMonth = DateTime(date.year, date.month, 1);
    int firstWeekday = firstDayOfMonth.weekday;

    // Calculate the difference between the first weekday and Monday (1)
    int offset = firstWeekday - DateTime.monday;
    if (offset < 0) offset += 7; // Adjust if the month starts before Monday

    // Calculate week number
    int weekNumber = ((date.day + offset - 1) ~/ 7) + 1;
    return weekNumber;
  }

  /// Function to format and display the selected date's week information
  void _calculateWeekOfMonth(DateTime date) {
    // String formatNamaHari = DateFormat('EEEE', 'id_ID').format(date);
    String formatNamaBulan = DateFormat('MMMM', 'id_ID').format(date);
    int weekNum = weekOfMonth(date);

    // Update the text field with the formatted string
    namaJadwalController.text =
        'Minggu ke-$weekNum ${formatNamaBulan} ${DateFormat('yyyy', 'id_ID').format(date)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text("Atur Jadwal",
            style: TextStyle(fontSize: 20, color: Colors.white)),
        centerTitle: false,
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: tanggalJadwalController,
                    readOnly: true,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), label: Text('Tanggal')),
                    onTap: () {
                      showDatePicker(
                        context: context,
                        // initialDate: pickedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        selectableDayPredicate: (DateTime date) {
                          // Hanya izinkan hari Minggu yang dapat dipilih
                          return date.weekday == DateTime.sunday;
                        },
                      )

                          // showDatePicker(
                          //   context: context,
                          //   initialDate: DateTime.now(),
                          //   firstDate: DateTime.now(),
                          //   lastDate: DateTime(2099),
                          // )
                          .then((pickedDate) {
                        if (pickedDate != null) {
                          setState(() {
                            dateTime = pickedDate;
                            _calculateWeekOfMonth(pickedDate);

                            String formattedDate =
                                DateFormat('EEEE, dd-MMM-yyyy', 'id_ID')
                                    .format(pickedDate);
                            // print(formattedDate);
                            cekAvailableUser();
                            tanggalJadwalController.text = formattedDate;
                            // String formatNamaHari =
                            //     DateFormat('EEEE', 'id_ID').format(pickedDate);
                            // String formatNamaBulan =
                            //     DateFormat('MMMM', 'id_ID').format(pickedDate);
                            // String ke =
                            //     DateFormat('dd', 'id_ID').format(pickedDate);

                            // namaJadwalController.text =
                            //     '${formatNamaHari} ke-${(int.parse(ke) ~/ 7)} ${formatNamaBulan} ${DateFormat('yyyy', 'id_ID').format(pickedDate)}';
                          });
                        }
                      });
                    },
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
                    controller: namaJadwalController,
                    // readOnly: true,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), label: Text('Nama')),
                    keyboardType: TextInputType.streetAddress,
                    validator: (value) {
                      if (value!.isEmpty || value == '') {
                        return 'Harap Diisi';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Guru'),
                      // IconButton(
                      //     onPressed: () async {
                      //       setState(() {
                      //         listAvailableUsers.shuffle();
                      //       });
                      //     },
                      //     icon: const Icon(Icons.refresh))
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: listAvailableUsers.isNotEmpty
                        ? ListView.separated(
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            itemBuilder: (context, index) {
                              // return Text(listAvailableUsers[index]['name']);
                              return TextFormField(
                                readOnly: true,
                                controller: TextEditingController(
                                    text: listAvailableUsers[index %
                                        listAvailableUsers.length]['nama']),
                                decoration: InputDecoration(
                                    border: const OutlineInputBorder(),
                                    label: Text('Tugas ${index + 1}')),
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                                  height: 10,
                                ),
                            itemCount: tugas.length)
                        : const Center(child: Text('Pilih Tanggal')),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  listAvailableUsers.isNotEmpty
                      ? Row(
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
                                        Response? response;
                                        List<dynamic> details = [];
                                        for (var i = 0; i < tugas.length; i++) {
                                          details.add({
                                            'tugas': tugas[i],
                                            'user': listAvailableUsers[i],
                                            'created_at': Timestamp.now(),
                                          });
                                        }
                                        Map<String, dynamic> jadwal = {
                                          'tanggal':
                                              Timestamp.fromDate(dateTime!),
                                          'name': namaJadwalController.text,
                                          'details': details,
                                          'created_at': Timestamp.now(),
                                        };
                                        response = await simpanJadwal(jadwal);
                                        setState(() {
                                          isLoadingSave = false;
                                        });
                                        if (context.mounted) {
                                          Navigator.of(context).pop();

                                          var snackBar = SnackBar(
                                            behavior: SnackBarBehavior.floating,
                                            content: Text(response!.message!),
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
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 14),
                                              Text('Loading...')
                                            ],
                                          )
                                        : const Text('Simpan'))),
                          ],
                        )
                      : const SizedBox.shrink()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Function to display a dialog with the week information
  void _showWeekDialog(BuildContext context, DateTime date) {
    int weekNum = weekOfMonth(date);
    String formatNamaHari = DateFormat('EEEE', 'id_ID').format(date);
    String formatNamaBulan = DateFormat('MMMM', 'id_ID').format(date);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Informasi Minggu'),
          content: Text(
            '${formatNamaHari},  ${date.day} ${formatNamaBulan} adalah minggu ke-$weekNum di bulan tersebut.',
            style: TextStyle(fontSize: 16),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Tutup'),
            ),
          ],
        );
      },
    );
  }
}