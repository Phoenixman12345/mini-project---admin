import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lotto_app/config/internal_config.dart';
import 'package:lotto_app/model/Response/UsersLoginPostResponse.dart';
import 'package:lotto_app/nav/navbar.dart';
import 'package:lotto_app/nav/navbottom.dart';
import 'package:lotto_app/sidebar/customerSidebar.dart';
import 'package:http/http.dart' as http;

class WalletPage extends StatefulWidget {
  final int uid;
  const WalletPage({super.key, required this.uid});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late Future<UsersLoginPostResponse> loadDataUser;

  @override
  void initState() {
    super.initState();
    loadDataUser = fetchUserData(widget.uid);
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
          if (snapshot.hasData) {
            final user = snapshot.data!;
            return CustomerSidebar(
              imageUrl: user.image ?? '',
              username: user.username,
              uid: user.uid,
              currentPage: 'wallet',
            );
          } else {
            return Drawer(child: Center(child: Text('No data available')));
          }
        },
      ),
      bottomNavigationBar: NavBottom(
        uid: widget.uid,
        selectedIndex: 3,
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
