import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lotto_app/config/config.dart';
import 'package:lotto_app/config/internal_config.dart';
import 'package:lotto_app/model/Response/LottoGetResponse.dart';
import 'package:lotto_app/model/Response/UsersLoginPostResponse.dart';
import 'package:lotto_app/nav/navbar.dart';
import 'package:lotto_app/nav/navbottom.dart';
import 'package:lotto_app/sidebar/CustomerSidebar.dart';
import 'package:lotto_app/model/Response/LottoTypeGetResponse.dart';
import 'dart:developer';
class HomePage extends StatefulWidget {
  final int uid;
  const HomePage({super.key, required this.uid});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<UsersLoginPostResponse> loadDataUser;
  late Future<List<LottoGetResponse>> loadDataLotto;
  late Future<List<LottoGetResponse>> loadDataLottoPrize;
  late Future<List<LottoTypeGetResponse>> loadDataLottoType;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController searchCtl = TextEditingController();
  String selectedType = 'ทั้งหมด';
  List<LottoGetResponse> filteredLottoData = [];

  @override
  void initState() {
    super.initState();
    loadDataUser = fetchUserData();
    loadDataLotto = fetchAllLotto();
    loadDataLottoPrize = loadDataLottoPrizeAsync();
  }

  @override
  Widget build(BuildContext context) {
    bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    log(isPortrait ? 'Portrait' : 'Landscape');
    double horizontalPadding = isPortrait ? 20.0 : 60.0;

    double cardwidth = isPortrait ? (MediaQuery.of(context).size.width / 2) -20 : (MediaQuery.of(context).size.width / 3) - 20;
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
      body: FutureBuilder<List<LottoGetResponse>>(
        future: loadDataLotto,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          filteredLottoData = snapshot.data ?? [];
          return SingleChildScrollView(
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
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: TextField(
                            controller: searchCtl,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Color(0xFFF5F5F7),
                              hintText: 'ค้นหาเลขล็อตเตอรี่',
                              hintStyle: TextStyle(
                                fontFamily: 'SukhumvitSet',
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              prefixIcon: Icon(Icons.search_rounded),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            style: TextStyle(
                              fontFamily: 'SukhumvitSet',
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            onChanged: (value) {
                              print('Search query: $value');
                            },
                          ),
                        ),
                        SizedBox(height: 10),
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
                                  return Container(
                                    height: 134,
                                    width: double.infinity,
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFFEAAC8B),
                                          Color(0xFFE88C7D),
                                          Color(0xFFEE5566),
                                          Color(0xFFB56576),
                                          Color(0xFF6D597A),
                                        ],
                                        begin: Alignment.topRight,
                                        end: Alignment.bottomLeft,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 15),
                                          child: Row(
                                            children: [
                                              Text(
                                                lottoData.formattedDate,
                                                style: TextStyle(
                                                    fontFamily: 'SukhumvitSet',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          'รางวัลที่ ${lottoData.prize}',
                                          style: TextStyle(
                                              fontFamily: 'SukhumvitSet',
                                              fontWeight: FontWeight.w600,
                                              fontSize: 26,
                                              color: Colors.white),
                                        ),
                                        SizedBox(height: 3),
                                        Container(
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
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                        FutureBuilder<List<LottoGetResponse>>(
                          future: loadDataLotto,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }
                            if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            }
                            final lottoTypes = snapshot.data ?? [];
                            List<String> lottoTypeList = lottoTypes
                                .map((type) => type.type)
                                .toSet()
                                .toList();

                            return Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  ElevatedButton(
                                    onPressed: () => selectType('ทั้งหมด'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: selectedType == 'ทั้งหมด'
                                          ? Colors.black
                                          : Colors.black.withOpacity(0.1),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        side: BorderSide.none,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                      elevation: 0,
                                    ),
                                    child: Text(
                                      'ทั้งหมด',
                                      style: TextStyle(
                                        fontFamily: 'SukhumvitSet',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: selectedType == 'ทั้งหมด'
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                  ...lottoTypeList.map((type) {
                                    return ElevatedButton(
                                      onPressed: () => selectType(type),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: selectedType == type
                                            ? Colors.black
                                            : Colors.black.withOpacity(0.1),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          side: BorderSide.none,
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        elevation: 0,
                                      ),
                                      child: Text(
                                        type,
                                        style: TextStyle(
                                          fontFamily: 'SukhumvitSet',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: selectedType == type
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ],
                              ),
                            );
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Container(
                              child: Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: filteredLottoData
                                    .where((lotto) =>
                                        selectedType == 'ทั้งหมด' ||
                                        lotto.type == selectedType)
                                    .toList()
                                    .map((lotto) {
                                  return Container(
                                    width: cardwidth,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFF5F5F7),
                                      borderRadius: BorderRadius.circular(22),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          spreadRadius: 1,
                                          blurRadius: 3,
                                          offset: Offset(3, 4),
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'หมายเลข',
                                                style: TextStyle(
                                                  fontFamily: 'SukhumvitSet',
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14,
                                                  color: Color(0xFF6C6C6C),
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 4, horizontal: 8),
                                                decoration: BoxDecoration(
                                                  color: Color(0xFFFFFFFF),
                                                  borderRadius:
                                                      BorderRadius.circular(7),
                                                ),
                                                child: Text(
                                                  '${lotto.type}',
                                                  style: TextStyle(
                                                    fontFamily: 'SukhumvitSet',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10,
                                                    color: Color(0xFF000000),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            '${lotto.number}',
                                            style: TextStyle(
                                              fontFamily: 'SukhumvitSet',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 24,
                                              color: Color(0xFF2D2D2D),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(top: 8),
                                            child: Center(
                                              child: Container(
                                                width: double.infinity,
                                                height: 2.5,
                                                decoration: BoxDecoration(
                                                  color: Color(0xFFFF0000),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            'คงเหลือ  ${lotto.lottoQuantity}${lotto.type == 'หวยชุด' ? '  ชุด' : lotto.type == 'หวยเดี่ยว' ? '  ใบ' : ''}',
                                            style: TextStyle(
                                              fontFamily: 'SukhumvitSet',
                                              fontWeight: FontWeight.w600,
                                              fontSize: 11,
                                              color: Color(0xFF2D2D2D),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.wallet,
                                                    size: 26,
                                                    color: Color(0xFFF92A47),
                                                  ),
                                                  Text(
                                                    '${lotto.price}',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'SukhumvitSet',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20,
                                                      color: Color(0xFFF92A47),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                width: 65,
                                                height: 27,
                                                child: ElevatedButton(
                                                  onPressed: () {},
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Color(0xFFF92A47),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    padding: EdgeInsets.zero,
                                                  ),
                                                  child: Text(
                                                    'เพิ่มลงตะกร้า',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'SukhumvitSet',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 10,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
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

      List<LottoGetResponse> firstPrizeList =
          allLottoData.where((lotto) => lotto.prize == 1).toList();
      return firstPrizeList;
    } else {
      throw Exception('Failed to load lotto data');
    }
  }

  Future<List<LottoGetResponse>> fetchAllLotto() async {
    var config = await Configuration.getConfig();
    var res = await http.get(Uri.parse('${config['apiEndpoint']}/lotto'));
    if (res.statusCode == 200) {
      List<dynamic> data = jsonDecode(res.body);
      return data.map((item) => LottoGetResponse.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load lotto prize data');
    }
  }

  void selectType(String type) {
    setState(() {
      selectedType = type;
    });
  }
}