import 'package:flutter/material.dart';
import 'dart:developer';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lotto_app/config/config.dart';
import 'package:lotto_app/model/Response/UsersLoginPostResponse.dart';
import 'package:lotto_app/model/Response/LottoGetResponse.dart';
import 'package:lotto_app/nav/navbar.dart';
import 'package:lotto_app/nav/navbottomAdmin.dart';
import 'package:lotto_app/sidebar/adminSidebar.dart';
import 'package:lotto_app/config/internal_config.dart';
import 'package:lotto_app/model/Response/allUserGetResponse.dart';

class ManageUser extends StatefulWidget {
  final int uid;
  ManageUser({super.key, required this.uid});

  @override
  State<ManageUser> createState() => _ManageUserState();
}

class _ManageUserState extends State<ManageUser> {
  late Future<UsersLoginPostResponse> loadDataUser;
  late Future<List<UsergetAlldata>>
      loadAlldataUser; // เปลี่ยนชนิดข้อมูลให้ถูกต้อง
  List<UsergetAlldata> userGetResponses = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String url = '';
  void initState() {
    super.initState();
    log('Show User uid: ${widget.uid}');
    loadDataUser = fetchUserData();
    loadAlldataUser = fetchAllUser();
  }

  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    log(isPortrait ? 'Portrait' : 'Landscape');
    double horizontalPadding = isPortrait ? 20.0 : 60.0;
    double cardwidth = isPortrait
        ? (MediaQuery.of(context).size.width / 2) - 20
        : (MediaQuery.of(context).size.width / 3) - 20;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: Navbar(
        loadDataUser: loadDataUser,
        scaffoldKey: _scaffoldKey,
      ),
      drawer: FutureBuilder<UsersLoginPostResponse>(
        future: loadDataUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Drawer(child: Center(child: CircularProgressIndicator()));
          }
          if (snapshot.hasError) {
            return Drawer(
                child: Center(child: Text('Error: ${snapshot.error}')));
          }
          final user = snapshot.data!;
          return CustomerSidebar(
            imageUrl: user.image ?? '',
            username: user.username,
            uid: user.uid,
            currentPage: 'home',
          );
        },
      ),
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder<UsersLoginPostResponse>(
              future: loadDataUser,
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (userSnapshot.hasError) {
                  return Center(child: Text('Error: ${userSnapshot.error}'));
                }
                final user = userSnapshot.data!;
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(left: 15, top: 5),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'มาจัดการคนซื้อหวยกันเถอะ!',
                                  style: TextStyle(
                                    fontFamily: 'SukhumvitSet',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Color(0xFF7B7B7C),
                                  ),
                                ),
                                Text(
                                  'จัดการข้อมูลสมาชิก',
                                  style: TextStyle(
                                    fontFamily: 'SukhumvitSet',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 30,
                                    color: Color(0xFF000000),
                                  ),
                                ),
                              ])),
                      FutureBuilder<List<UsergetAlldata>>(
                        future: loadAlldataUser,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          }
                          final List<UsergetAlldata> users = snapshot.data!;
                          return Center(
                            child: Container(
                              child: Wrap(
                                spacing: 5.0, // ระยะห่างระหว่างการ์ดในแนวนอน
                                runSpacing:
                                    5.0, // ระยะห่างระหว่างการ์ดในแนวตั้ง
                                children: List.generate(users.length, (index) {
                                  final user = users[index];
                                  final isEvenIndex = index % 2 == 0;
                                  Color cardColor = index % 2 == 0 ? Color.fromARGB(255, 1, 56, 86) :  Color.fromARGB(255, 243, 241, 241); // ใช้สีตามลำดับ
                                  Color fontColor = index % 2 == 0 ? Color.fromARGB(255, 255, 255, 255) :  Color.fromARGB(255, 1, 56, 86); 
                                  
                                  
                                  return SizedBox(
                                    width: cardwidth,
                                    height:
                                        150, // กำหนดความกว้างของการ์ดให้เหมาะสม
                                    child: Card(
                                      color: cardColor,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                           
                                            Row(
                                            children: [
                                              Icon(
                                                Icons.wallet,
                                                color: Color.fromARGB(228, 226, 174, 15), // ตั้งค่าสีของไอคอน
                                              ),
                                              SizedBox(
                                                width: 3, // เพิ่มระยะห่างระหว่างไอคอนและข้อความ
                                              ),
                                              Text(
                                                '${user.wallet}',
                                                style: TextStyle(
                                                  color: Color.fromARGB(228, 226, 174, 15), // ตั้งค่าสีของข้อความ
                                                ),
                                              ),
                                              Spacer(),
                                              IconButton(
                                                onPressed: () {},
                                                icon: Icon(
                                                  Icons.more_horiz,
                                                  color: Color.fromARGB(228, 226, 174, 15), // ตั้งค่าสีของไอคอนปุ่ม
                                                ),
                                              ),
                                            ],
                                            ),
                                            
                                            Center(
                                              child: Text(
                                                user.username,
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontFamily: 'SukhumvitSet',
                                                  fontWeight: FontWeight.w700,
                                                  color: fontColor,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(top: 8),
                                              child: Center(
                                                child: Container(
                                                  width: double.infinity,
                                                  height: 1.5,
                                                  decoration: BoxDecoration(
                                                    color: Color.fromARGB(228, 226, 174, 15),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              'ชื่อ-สกุล : ' + user.fullname,
                                              style: TextStyle(
                                                fontFamily: 'SukhumvitSet',
                                                fontWeight: FontWeight.w600,
                                                fontSize: 11,
                                                color: fontColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          );
                        },
                      )
                    ]);
              }),
        ],
      )),
      bottomNavigationBar: NavBottom(
        uid: widget.uid,
        selectedIndex: 0,
      ),
    );
  }

  Future<UsersLoginPostResponse> fetchUserData() async {
    final response =
        await http.get(Uri.parse('$API_ENDPOINT/customers/${widget.uid}'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return UsersLoginPostResponse.fromJson(data);
    } else {
      throw Exception('Failed to load user data');
    }
  }
  // Future<UsergetAlldata> fetchAllUser() async {
  //   var config = await Configuration.getConfig();
  //   url = config['apiEndpoint'];

  //   var res = await http.get(Uri.parse('$url/trips'));
  //   log(res.body);
  //   userGetResponses = usergetAlldataFromJson(res.body);

  // }
//   Future<UsergetAlldata> fetchAllUser() async {
//   final response = await http.get(Uri.parse('$API_ENDPOINT/allusers'));
//   if (response.statusCode == 200) {
//     final data = json.decode(response.body);
//     return UsergetAlldata.fromJson(data);
//   } else {
//     throw Exception('Failed to load user data');
//   }
// }
  Future<List<UsergetAlldata>> fetchAllUser() async {
    final response = await http.get(Uri.parse('$API_ENDPOINT/allusers'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => UsergetAlldata.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load user data');
    }
  }
}
