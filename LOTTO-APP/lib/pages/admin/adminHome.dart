import 'dart:developer';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lotto_app/config/config.dart';
import 'package:lotto_app/model/Response/UsersLoginPostResponse.dart';
import 'package:lotto_app/model/Response/LottoGetResponse.dart';
import 'package:lotto_app/nav/navbar.dart';
import 'package:lotto_app/nav/navbottomAdmin.dart';
import 'package:lotto_app/sidebar/adminSidebar.dart';
import 'package:lotto_app/config/internal_config.dart';

class AdminhomePage extends StatefulWidget {
  final int uid;
  const AdminhomePage({super.key, required this.uid});

  @override
  State<AdminhomePage> createState() => _AdminhomePageState();
}

class _AdminhomePageState extends State<AdminhomePage> {
  late Future<UsersLoginPostResponse> loadDataUser;
  late Future<List<LottoGetResponse>> loadDataLottoPrize;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  void initState() {
    super.initState();
    log('Show User uid: ${widget.uid}');
    loadDataUser = fetchUserData();
    loadDataLottoPrize = loadDataLottoPrizeAsync();
  }

  @override
  Widget build(BuildContext context) {
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
              if (userSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (userSnapshot.hasError) {
                      return Center(
                          child: Text('Error: ${userSnapshot.error}'));
                    }
                    final user = userSnapshot.data!;
                    return Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15, top: 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ยินดีต้อนรับ กลับมา!',
                                style: TextStyle(
                                  fontFamily: 'SukhumvitSet',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color(0xFF7B7B7C),
                                ),
                              ),
                              Text(
                                '${user.username}',
                                style: TextStyle(
                                  fontFamily: 'SukhumvitSet',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 30,
                                  color: Color(0xFF000000),
                                ),
                              ),
                            ]
                          )),
                          FutureBuilder<List<LottoGetResponse>>(
                          future: loadDataLottoPrize,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }
                            if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            }
                            final lottoDataList = snapshot.data ?? [];

                            if (lottoDataList.isEmpty) {
                              return Center(
                                  child: Text('No lottery data available'));
                            }

                            return Padding(
                              padding:
                                  const EdgeInsets.only(left: 30, right: 30),
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: lottoDataList.length,
                                itemBuilder: (context, index) {
                                  final lottoData = lottoDataList[index];
                                  Color backColor = index % 2 == 0 ? Color.fromARGB(255, 1, 56, 86) :  Color.fromARGB(255, 215, 215, 215);
                                  Color buttonColor = index % 2 == 0 ? Color.fromARGB(255, 238, 179, 30) : Color.fromARGB(255, 1, 56, 86);
                                  Color fontColor = index % 2 == 0 ? Color.fromARGB(255, 1, 56, 86) : Color.fromARGB(255, 255, 255, 255);
                                   Color prizefontColor = index % 2 == 0 ? Color.fromARGB(255, 255, 255, 255) : Color.fromARGB(255, 0, 0, 0);
                                  return Container(
                                    height: 135,
                                    width: double.infinity,
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    decoration: BoxDecoration(
                                      color: backColor,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:MainAxisAlignment.center,
                                      crossAxisAlignment:CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Text(
                                            'รางวัลที่ ${lottoData.prize}',
                                            style: TextStyle(
                                                fontFamily: 'SukhumvitSet',
                                                fontWeight: FontWeight.w700,
                                                fontSize: 26,
                                                color: prizefontColor),
                                          ),
                                        ),
                                        SizedBox(height: 3),
                                        Row(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(left: 10),
                                              child: Container(
                                                width: 190,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      '${lottoData.number}',
                                                      style: TextStyle(
                                                          fontFamily: 'SukhumvitSet',
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 35,
                                                          color: const Color.fromARGB(255, 69, 67, 67)),
                                                    ),
                                                    
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(10.0),
                                              child: FilledButton(
                                                onPressed: () {
                                                  // โค้ดที่ต้องการให้ปุ่มทำงานเมื่อถูกกด
                                                },
                                                style: ButtonStyle(
                                                  backgroundColor: MaterialStateProperty.resolveWith<Color?>((states) {
                                                    return buttonColor; // สีพื้นฐานของปุ่ม
                                                  }),
                                                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // สีของข้อความบนปุ่ม
                                                ),
                                                child: Text('สุ่ม',style: TextStyle(
                                                  fontFamily: 'SukhumvitSet',
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 15,
                                                  color: fontColor
                                                ),)
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ]);
            }
            
            ),
            
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
    Future<List<LottoGetResponse>> loadDataLottoPrizeAsync() async {
    var config = await Configuration.getConfig();
    var res = await http.get(Uri.parse('${config['apiEndpoint']}/lotto-prize'));
    if (res.statusCode == 200) {
      List<dynamic> data = jsonDecode(res.body);
      List<LottoGetResponse> allLottoData =
          data.map((item) => LottoGetResponse.fromJson(item)).toList();

      // List<LottoGetResponse> firstPrizeList =
      //     allLottoData.where((lotto) => lotto.prize == 1).toList();
      return allLottoData;
    } else {
      throw Exception('Failed to load lotto data');
    }
  }
}
