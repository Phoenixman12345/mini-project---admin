import 'package:flutter/material.dart';
import 'package:lotto_app/pages/login.dart';
import 'package:lotto_app/pages/register.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFEAAC8B),
              Color(0xFFE88C7D),
              Color(0xFFEE5566),
              Color(0xFFB56576),
              Color(0xFF6D597A),
              Color(0xFF355070),
              Color(0xFFEAAC8B),
              Color(0xFFFFFFFF),
              Color(0xFFF92A47),
              Color(0xFFFFFFFF),
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Column(
          children: [
            const Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'LOTTO',
                      style: TextStyle(
                        fontFamily: 'SukhumvitSet',
                        fontSize: 68,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                    Text(
                      'ซื้อ - ขาย ลอตเตอรี่เถื่อนที่โด่งดังที่สุดในประเทศไทย',
                      style: TextStyle(
                        fontFamily: 'SukhumvitSet',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () => _showLoginBottomSheet(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF92A47),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      minimumSize: const Size(300, 50),
                    ),
                    child: const Text(
                      'เข้าสู่ระบบ',
                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontFamily: 'SukhumvitSet',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF000000),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      minimumSize: const Size(300, 50),
                    ),
                    child: const Text(
                      'ลงทะเบียน',
                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontFamily: 'SukhumvitSet',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLoginBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return LoginPage();
      },
    );
  }

  void register() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RegisterPage(),
      ),
    );
  }
}
