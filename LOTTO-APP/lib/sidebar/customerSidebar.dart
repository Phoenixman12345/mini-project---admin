import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lotto_app/pages/customers/basket.dart';
import 'package:lotto_app/pages/customers/check_lotto.dart';
import 'package:lotto_app/pages/customers/home.dart';
import 'package:lotto_app/pages/customers/my_lotto.dart';
import 'package:lotto_app/pages/customers/profile.dart';
import 'package:lotto_app/pages/customers/wallet.dart';
import 'package:lotto_app/pages/intro.dart';

class CustomerSidebar extends StatelessWidget {
  final String imageUrl;
  final String username;
  final int uid;
  final String currentPage;

  const CustomerSidebar({
    super.key,
    required this.imageUrl,
    required this.username,
    required this.uid,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      alignment: Alignment.topLeft,
      widthFactor: 0.7,
      heightFactor: 1,
      child: Stack(
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          Container(
            color: Color(0xFFF5F5F7).withOpacity(0.85),
            child: ListView(
              physics: ClampingScrollPhysics(),
              padding: EdgeInsets.zero,
              children: [
                AppBar(
                  automaticallyImplyLeading: false,
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: IconButton(
                      icon: Icon(Icons.cancel),
                      color: Colors.black,
                      iconSize: 50,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 20, bottom: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 100,
                            height: 100,
                            child: imageUrl.isNotEmpty &&
                                    Uri.tryParse(imageUrl)?.isAbsolute == true
                                ? Image.network(
                                    imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return _buildDefaultImage();
                                    },
                                  )
                                : _buildDefaultImage(),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Text(
                        username,
                        style: TextStyle(
                          fontFamily: 'SukhumvitSet',
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.house_rounded,
                  text: 'หน้าหลัก',
                  page: 'home',
                  onTap: () {
                    log('Navigating to Home with UID: $uid');
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomePage(uid: uid)),
                    );
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.person_rounded,
                  text: 'ข้อมูลส่วนตัว',
                  page: 'profile',
                  onTap: () {
                    log('Navigating to Profile with UID: $uid');
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfilePage(uid: uid)),
                    );
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.confirmation_number,
                  text: 'ตรวจฉลาก',
                  page: 'check_lotto', // เพิ่มค่า page
                  onTap: () {
                    log('Navigating to Check LOTTO with UID: $uid');
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CheckLotto(uid: uid)),
                    );
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.local_mall_rounded,
                  text: 'LOTTO ของฉัน',
                  page: 'my_lotto', // เพิ่มค่า page
                  onTap: () {
                    log('Navigating to MY LOTTO with UID: $uid');
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyLottoPage(uid: uid)),
                    );
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.shopping_basket_rounded,
                  text: 'ตะกร้า',
                  page: 'basket', // เพิ่มค่า page
                  onTap: () {
                    log('Navigating to Basket with UID: $uid');
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BasketPage(uid: uid)),
                    );
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.wallet,
                  text: 'Wallet',
                  page: 'wallet', // เพิ่มค่า page
                  onTap: () {
                    log('Navigating to Wallet with UID: $uid');
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WalletPage(uid: uid)),
                    );
                  },
                ),
                Divider(),
                SizedBox(height: 50),
                _buildMenuItem(
                  context,
                  icon: Icons.logout_rounded,
                  text: 'ออกจากระบบ',
                  page: 'logout', // เพิ่มค่า page
                  onTap: () {
                    _showLogoutConfirmation(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context,
      {required IconData icon,
      required String text,
      required String page,
      required VoidCallback onTap}) {
    bool isSelected = currentPage == page;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.black : Colors.black,
                size: 38,
              ),
              SizedBox(width: 8),
              Text(
                text,
                style: TextStyle(
                  fontFamily: 'SukhumvitSet',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isSelected
                      ? const Color.fromARGB(255, 0, 0, 0)
                      : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultImage() {
    return Center(
      child: SizedBox(
        width: 100,
        height: 100,
        child: ClipOval(
          child: Image.asset(
            'assets/logo/mc.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Stack(
          children: [
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
            Container(
              height: 230,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),
              ),
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 80,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    'ยืนยันออกจากระบบ',
                    style: TextStyle(
                      fontFamily: 'SukhumvitSet',
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'คุณต้องการออกจากระบบใช่ไหม?',
                    style: TextStyle(
                      fontFamily: 'SukhumvitSet',
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'ยกเลิก',
                          style: TextStyle(
                            fontFamily: 'SukhumvitSet',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const IntroPage(),
                            ),
                          );
                        },
                        child: Text(
                          'ออกจากระบบ',
                          style: TextStyle(
                            fontFamily: 'SukhumvitSet',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
