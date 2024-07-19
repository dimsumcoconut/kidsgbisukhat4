import 'package:flutter/material.dart';
import 'package:kidsgbisukhat4/new/list_izin.dart';
import 'package:kidsgbisukhat4/new/list_jadwal.dart';
import 'package:kidsgbisukhat4/new/list_user.dart';
import 'package:kidsgbisukhat4/new/priofil_page.dart';

class MainPage extends StatefulWidget {
  final dynamic user;
  const MainPage({super.key, required this.user});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentpage = 0;
  @override
  Widget build(BuildContext context) {
    Widget body() {
      switch (currentpage) {
        case 0:
          return widget.user['jabatan'] == 'Admin'
              ? const ListUserPage()
              : ListJadwalPage(
                  user: widget.user,
                );
        case 1:
          return widget.user['jabatan'] == 'Admin'
              ? ListIzinPage(
                  user: widget.user,
                )
              : ListIzinPage(
                  user: widget.user,
                );

        case 2:
          return widget.user['jabatan'] == 'Admin'
              ? ListJadwalPage(
                  user: widget.user,
                )
              : const ProfilePage();
        case 3:
          return widget.user['jabatan'] == 'Admin'
              ? const ProfilePage()
              : const Center(
                  child: Text(
                    'Something Wrong!!!',
                  ),
                );
        default:
          return const Center(
            child: Text(
              'Something Wrong!!!',
            ),
          );
      }
    }

    return Scaffold(
      body: body(),
      bottomNavigationBar: BottomNavigationBar(
          onTap: (value) {
            setState(() {
              currentpage = value;
            });
          },
          currentIndex: currentpage,
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: Colors.grey[300],
          items: [
            if (widget.user['jabatan'] == 'Admin')
              const BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: 'List User'),
            if (widget.user['jabatan'] == 'Admin')
              const BottomNavigationBarItem(
                  icon: Icon(Icons.edit), label: 'List Izin'),
            const BottomNavigationBarItem(
                icon: Icon(Icons.date_range), label: 'List Jadwal'),
            if (widget.user['jabatan'] == 'Guru')
              const BottomNavigationBarItem(
                  icon: Icon(Icons.list), label: 'Izin'),
            const BottomNavigationBarItem(
                icon: Icon(Icons.person_rounded), label: 'Profile'),
          ]),
    );
  }
}
