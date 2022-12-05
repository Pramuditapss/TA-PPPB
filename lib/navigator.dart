import 'package:flutter/material.dart';
import 'package:tugas_akhir/pages/episode.pages.dart';
import 'package:tugas_akhir/pages/home.pages.dart';
import 'package:tugas_akhir/pages/profile.pages.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedNavbar = 0;
  final List<Widget> _widgetOptions = <Widget>[
    const HomePage(),
    const Episode(),
    const Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.switch_account_rounded), label: 'Characters'),
          BottomNavigationBarItem(
              icon: Icon(Icons.video_collection), label: 'Episodes'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedNavbar,
        selectedItemColor: Color.fromARGB(255, 27, 166, 197),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: (index) {
          setState(() {
            _selectedNavbar = index;
          });
        },
      ),
      body: _widgetOptions.elementAt(_selectedNavbar),
    );
  }
}
