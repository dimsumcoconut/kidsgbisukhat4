import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kidsgbisukhat4/new/user_page.dart';

class ListUserPage extends StatefulWidget {
  const ListUserPage({super.key});

  @override
  State<ListUserPage> createState() => _ListUserPageState();
}

class _ListUserPageState extends State<ListUserPage> {
  List<Map<String, dynamic>> listUser = [];

  final CollectionReference collectionUser =
      FirebaseFirestore.instance.collection('users');
  Stream<List<dynamic>> fetchAllSortedFirestore() {
    return collectionUser.snapshots().map((s) => s.docs.map((e) {
          Map<String, dynamic> user = {
            'nama': e['nama'],
            'email': e['email'],
            'jabatan': e['jabatan'],
            'password': e['password'],
          };
          return user;
        })
            // .sorted(
            //   (a, b) => b['created_at'].compareTo(a['created_at']),
            // )
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Data Guru",
            style: TextStyle(
              fontSize: 20,
              color: Colors.black
            )),
        centerTitle: false,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const UserPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: fetchAllSortedFirestore(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            ); // Display a loading indicator while waiting for data
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            ); // Handle errors
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text('Belum Ada Data'),
            ); // Handle the case when there's no data
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> user = snapshot.data![index];
                return ListTile(
                  onTap: () {},
                  title: Text(user['email']),
                  subtitle: Text(user['jabatan']),
                  // trailing: const Icon(Icons.arrow_forward_ios_rounded),
                );
              },
            );
          }
        },
      ),
    );
  }
}
