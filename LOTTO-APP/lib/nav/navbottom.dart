import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lotto_app/pages/customers/basket.dart';
import 'package:lotto_app/pages/customers/check_lotto.dart';
import 'package:lotto_app/pages/customers/home.dart';
import 'package:lotto_app/pages/customers/wallet.dart';

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
              builder: (context) => HomePage(uid: widget.uid),
            ),
          );
          break;
        case 1:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => CheckLotto(uid: widget.uid)),
          );
          break;
        case 2:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => BasketPage(uid: widget.uid)),
          );
          break;
        case 3:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => WalletPage(uid: widget.uid)),
          );
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 105, // Adjusted height for the navigation bar
      color: Colors.transparent,
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
              icon: Icon(Icons.confirmation_number),
              label: 'ตรวจฉลาก',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_basket),
              label: 'ตะกร้า',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet),
              label: 'Wallet',
            ),
          ],
        ),
      ),
    );
  }
}
