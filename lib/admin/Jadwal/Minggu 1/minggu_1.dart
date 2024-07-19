import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kidsgbisukhat4/controller/jadwal1_controller.dart';

class Minggu1 extends StatelessWidget {
  Minggu1({super.key});
  final Jadwal1Controller controller = Get.put(Jadwal1Controller());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minggu 1'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: controller.selectedDate.value,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null && picked != controller.selectedDate.value) {
                  controller.selectedDate.value = picked;
                }
              },
              child: Text("Pilih Tanggal"),
            ),
            Obx(() => Text(
                "Tanggal terpilih: ${DateFormat('dd MMMM yyyy', 'id_ID').format(controller.selectedDate.value)}")),
            Expanded(
                child: Obx(
              () => ListView.builder(
                itemCount: controller.assignedUser.value.length >
                        controller.posisi.value.length
                    ? controller.posisi.value.length
                    : controller.assignedUser.value.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(controller.posisi.value[index]),
                    subtitle: Text(controller.assignedUser.value[index]),
                  );
                },
              ),
            )),
            ElevatedButton(
              onPressed: () {
                controller.uploadSchedule();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
              ),
              child: const Text(
                "Upload",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      }),
      bottomSheet: Container(
        height: 60,
        color: Color.fromARGB(255, 255, 255, 255),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: () {
                  controller.uploadSchedule();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
                child: const Text(
                  "Upload",
                  style: TextStyle(color: Colors.black),
                )),
            ElevatedButton(
                onPressed: () {
                  controller.assignRandomUsers();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
                child: const Text(
                  "Random",
                  style: TextStyle(color: Colors.black),
                )),
          ],
        ),
      ),
    );
  }
}
