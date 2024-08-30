import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lotto_app/config/internal_config.dart';
import 'package:lotto_app/model/Response/UsersLoginPostResponse.dart';
import 'package:lotto_app/nav/navbar.dart';
import 'package:lotto_app/nav/navbottom.dart';
import 'package:lotto_app/sidebar/customerSidebar.dart';
import 'package:http/http.dart' as http;

class BasketPage extends StatefulWidget {
  final int uid;
  const BasketPage({super.key, required this.uid});

  @override
  State<BasketPage> createState() => _BasketPageState();
}

class _BasketPageState extends State<BasketPage> {
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
              currentPage: 'basket',
            );
          } else {
            return Drawer(child: Center(child: Text('No data available')));
          }
        },
      ),
      bottomNavigationBar: NavBottom(
        uid: widget.uid,
        selectedIndex: 2,
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
