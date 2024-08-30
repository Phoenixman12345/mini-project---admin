import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lotto_app/pages/admin/adminHome.dart';
import 'package:lotto_app/pages/admin/manageUser.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
class NavBottom extends StatefulWidget {
  final int uid;
  final int selectedIndex;

  const NavBottom({super.key, required this.uid, required this.selectedIndex});

  @override
  State<NavBottom> createState() => _NavBottomState();
}

class _NavBottomState extends State<NavBottom> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });

      switch (index) {
        case 0:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AdminhomePage(uid: widget.uid),
            ),
          );
          break;
        case 1:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => ManageUser(uid: widget.uid)),
          );
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 105, // Adjusted height for the navigation bar
      color: const Color.fromARGB(0, 0, 0, 0),
      child: Theme(
        data: ThemeData(
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            selectedLabelStyle: TextStyle(
              fontFamily: 'SukhumvitSet',
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            unselectedLabelStyle: TextStyle(
              fontFamily: 'SukhumvitSet',
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black.withOpacity(0.3),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.house_rounded),
              label: 'หน้าหลัก',
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.userCog),
              label: 'จัดการข้อมูลสมาชิก',
            ),

          ],
        ),
      ),
    );
  }
}
