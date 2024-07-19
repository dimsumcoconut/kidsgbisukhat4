import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Izin {
  final String? nama;
  final String? status;

  Izin({this.nama = "", this.status = ""});
}

class Jadwal1Controller extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final RxList<String> nama = <String>[].obs;
  final RxList<String> posisi = <String>[].obs;
  final RxList<Izin> izin = <Izin>[].obs;
  Rx<DateTime> selectedDate = DateTime.now().obs;
  RxMap jadwal = {}.obs;
  final Set<String> usedUsers = <String>{};

  final RxList<String> assignedUser = <String>[].obs;

  final Stream<QuerySnapshot> usersStream = FirebaseFirestore.instance
      .collection('users')
      .where('jabatan', isEqualTo: 'Guru')
      .snapshots();

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  final CollectionReference tugasCollection =
      FirebaseFirestore.instance.collection('tugas_pel');

  final CollectionReference izinCollection =
      FirebaseFirestore.instance.collection('izin1');

  final CollectionReference jadwalCollection =
      FirebaseFirestore.instance.collection('minggu1');

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllData();
  }

  void fetchAllData() {
    izinMinggu1();
    alluser();
    alltugas();
    getJadwal();
  }

  Future<void> getJadwal() async {
    final value = await jadwalCollection.get();
    final List<String> fetchedTugas = [];
    final dataJadwal = value.docs[0].data() as Map;
    print(dataJadwal);
    dataJadwal.forEach((key, value) {
      if (key != "Tanggal") {
        assignedUser.add(value);
      }
    });
  }

  Future<void> izinMinggu1() async {
    isLoading.value = true;
    final value = await izinCollection.get();
    izin.assignAll(value.docs
        .map((e) => Izin(nama: e['nama'], status: e['status']))
        .toList());
  }

  Future<void> alluser() async {
    // Ambil data dari minggu-minggu sebelumnya
    String currentWeek = "minggu1";
    List<String> weeks = [
      'minggu2',
      'minggu3',
      'minggu4',
      'minggu5'
    ]; // Misalnya, minggu1 tidak diambil

    // tambahin user yang sudah dijadwalkan ke Set (usedUsers)
    for (var week in weeks) {
      final value = await _firestore.collection(week).get();
      for (var e in value.docs) {
        final data = e.data() as Map;
        data.forEach((key, value) {
          if (value is String) {
            usedUsers.add(value);
          }
        });
      }
    }
    // print("ini used $usedUsers");

    // ambil semua data user
    final QuerySnapshot value = await usersCollection.get();
    final List<String> fetchedNama = [];

    // Buat set user yang sedang izin
    Set<String> izinUsers = izin
        .where((item) => item.status == "1")
        .map((item) => item.nama!)
        .toSet();

    for (var e in value.docs) {
      final data = e.data() as Map;
      if (data['jabatan'] == 'Guru') {
        final namaUser = data['nama'];
        // buat pastiin nama user belum digunakan pada minggu yang lain dan tidak sedang izin
        if (!usedUsers.contains(namaUser) && !izinUsers.contains(namaUser)) {
          fetchedNama.add(namaUser);
        }
      }
    }
    nama.assignAll(fetchedNama);
    print("ini $nama");
  }

  Future<void> alltugas() async {
    final value = await tugasCollection.get();
    final List<String> fetchedTugas = [];
    for (var data in value.docs) {
      final e = data.data() as Map;
      fetchedTugas.add(e['tugas']);
    }
    posisi.assignAll(fetchedTugas);
    print(posisi);
    isLoading.value = false;
  }

  void gantiUserIzin(List<String> user, List<Izin> izinList) {
    List<String> userUpdated = List.from(user);

    for (var item in izinList) {
      if (item.status == "1") {
        int index = userUpdated.indexOf(item.nama!);
        if (index != -1) {
          String replacement = replaceUserForIzin(user, item.nama!);
          if (replacement.isNotEmpty) {
            userUpdated[index] = replacement;
          }
        }
      }
    }
    nama.assignAll(userUpdated);

    List<String> debugNamaUserIzin = [];
    for (var value in izinList) {
      debugNamaUserIzin.add(value.nama!);
    }

    // assignRandomUsers();
    print(
        "user assigned: $assignedUser, user ready : ${nama.length}, user izin : ${debugNamaUserIzin} , used user : ${usedUsers.length}");
  }

  String replaceUserForIzin(List<String> user, String izinUser) {
    // Buat daftar user yang bisa dipilih sebagai pengganti (kecuali yang izin dan yang sudah digunakan)
    List<String> candidates = user
        .where((u) =>
            !izin.map((i) => i.nama).contains(u) && !usedUsers.contains(u))
        .toList();
    if (candidates.isNotEmpty) {
      Random random = Random();
      return candidates[random.nextInt(candidates.length)];
    }
    return "";
  }

  void assignRandomUsers() {
    List<String> availableUsers =
        List.from(nama); // Buat salinan dari list user
    Random random = Random();

    assignedUser
        .clear(); // kosongkan list assignedUser sebelum menambahkan user baru

    for (int i = 0; i < 7; i++) {
      if (availableUsers.isEmpty) {
        break; // Jika tidak ada user yang tersisa, hentikan proses
      }
      int randomIndex = random.nextInt(availableUsers.length);
      assignedUser.add(availableUsers[randomIndex]);
      availableUsers.removeAt(
          randomIndex); // Hapus user yang sudah dipilih dari daftar availableUsers
    }
  }

  void uploadSchedule() {
    _firestore.collection('minggu1').doc('jadwal1').set({
      "WL": assignedUser[0],
      "Singer": assignedUser[1],
      "Firman Kecil": assignedUser[2],
      "Firman Besar": assignedUser[3],
      "Multimedia": assignedUser[4],
      "Usher": assignedUser[5],
      "Doa": assignedUser[6],
      "Tanggal": selectedDate.value.toIso8601String()
    });
    Get.snackbar('Success', 'Jadwal berhasil di-upload',
        backgroundColor: Color.fromARGB(255, 99, 99, 99),
        colorText: Colors.white);
    // print("tes");
    fetchAllData();
  }
}
