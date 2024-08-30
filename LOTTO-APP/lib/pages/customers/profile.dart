import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lotto_app/config/internal_config.dart';
import 'package:lotto_app/model/Response/UsersLoginPostResponse.dart';
import 'package:lotto_app/nav/navbar.dart';
import 'package:lotto_app/nav/navbottom.dart';
import 'package:lotto_app/sidebar/customerSidebar.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  final int uid;

  const ProfilePage({super.key, required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late Future<UsersLoginPostResponse> loadDataUser;

  @override
  void initState() {
    super.initState();
    loadDataUser = fetchUserData(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    final double circleDiameter =
        MediaQuery.of(context).size.width * 0.6; // ขนาดวงกลม

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // วาง Navbar ไว้ที่ตำแหน่งแรกเพื่อให้แสดงอยู่ด้านบนสุด
            Navbar(
              loadDataUser: loadDataUser,
              scaffoldKey: _scaffoldKey,
            ),
            // วางวงกลมไว้ที่ตำแหน่งถัดไป
            Positioned(
              top: 0,
              left: MediaQuery.of(context).size.width / 2 - circleDiameter / 2,
              child: Container(
                height: circleDiameter,
                width: circleDiameter,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                // วงกลมจะอยู่ด้านหลัง AppBar
                clipBehavior: Clip.none,
                child: const SizedBox.expand(),
              ),
            ),
          ],
        ),
      ),
      drawer: FutureBuilder<UsersLoginPostResponse>(
        future: loadDataUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Drawer(
              child: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasError) {
            return Drawer(
              child: Center(child: Text('Error: ${snapshot.error}')),
            );
          }
          if (snapshot.hasData) {
            final user = snapshot.data!;
            return CustomerSidebar(
              imageUrl: user.image ?? '',
              username: user.username,
              uid: user.uid,
              currentPage: 'profile',
            );
          } else {
            return Drawer(
              child: Center(child: Text('No data available')),
            );
          }
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // เนื้อหาหลักของหน้า
            Container(
              padding: EdgeInsets.all(16.0),
              child: Text("Profile Page Content"),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavBottom(
        uid: widget.uid,
        selectedIndex: 0,
      ),
    );
  }

  Future<UsersLoginPostResponse> fetchUserData(int uid) async {
    final response =
        await http.get(Uri.parse('${API_ENDPOINT}/customers/$uid'));
    if (response.statusCode == 200) {
      return UsersLoginPostResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user data');
    }
  }
}
