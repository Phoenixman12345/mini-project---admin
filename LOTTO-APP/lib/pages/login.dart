import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lotto_app/animation/AnimatedCheckmark.dart';
import 'package:lotto_app/config/internal_config.dart';
import 'package:http/http.dart' as http;
import 'package:lotto_app/model/Response/UsersLoginPostResponse.dart';
import 'package:lotto_app/pages/admin/adminHome.dart';
import 'package:lotto_app/pages/customers/home.dart';
import 'package:lotto_app/model/Request/UsersLoginPostRequest.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;
  String errorText = '';
  TextEditingController usernameOrEmailCtl = TextEditingController();
  TextEditingController passwordCtl = TextEditingController();

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: DraggableScrollableSheet(
        initialChildSize: 0.73,
        minChildSize: 0.73,
        maxChildSize: 1.0,
        expand: true,
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(45)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: ListView(
                controller: scrollController,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 0),
                    child: Center(
                      child: Container(
                        width: 80,
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 35),
                  Column(
                    children: [
                      Text(
                        'ยินดีต้อนรับกลับ',
                        style: TextStyle(
                          fontSize: 43,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SukhumvitSet',
                        ),
                      ),
                      Text(
                        'เข้าสู่ระบบของคุณ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6C6C6C),
                          fontFamily: 'SukhumvitSet',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 35),
                  TextField(
                    controller: usernameOrEmailCtl,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xFFF5F5F7),
                      hintText: 'ชื่อผู้ใช้ หรือ ที่อยู่อีเมล',
                      hintStyle: const TextStyle(
                        fontFamily: 'SukhumvitSet',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.black,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: const TextStyle(
                      fontFamily: 'SukhumvitSet',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 15),
                  TextField(
                    controller: passwordCtl,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xFFF5F5F7),
                      hintText: 'รหัสผ่าน',
                      hintStyle: const TextStyle(
                        fontFamily: 'SukhumvitSet',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                      prefixIcon: Icon(Icons.lock, color: Colors.black),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: _togglePasswordVisibility,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: const TextStyle(
                      fontFamily: 'SukhumvitSet',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        'ลืมรหัสผ่าน?',
                        style: TextStyle(
                          fontFamily: 'SukhumvitSet',
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Color(0xFF000000),
                        ),
                      ),
                    ),
                  ),
                  FilledButton(
                    onPressed: login,
                    child: Text(
                      'เข้าสู่ระบบ',
                      style: TextStyle(
                        fontFamily: 'SukhumvitSet',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: Color(0xFFF92A47),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      minimumSize: Size(double.infinity, 50),
                    ),
                  ),
                  SizedBox(height: 40),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 3,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          margin: EdgeInsets.only(right: 8),
                        ),
                      ),
                      Text(
                        'หรือ ดำเนินต่อด้วยวิธีอื่น',
                        style: TextStyle(
                          fontFamily: 'SukhumvitSet',
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 3,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          margin: EdgeInsets.only(left: 8),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 24,
                        child: ClipOval(
                          child: Image.asset(
                            'assets/logo/icons8-facebook.png',
                            width: 40,
                            height: 40,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 24,
                        child: ClipOval(
                          child: Image.asset(
                            'assets/logo/icons8-google.png',
                            width: 40,
                            height: 40,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 24,
                        child: ClipOval(
                          child: Image.asset(
                            'assets/logo/icons8-apple.png',
                            width: 40,
                            height: 40,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> login() async {
    log('username or email: ${usernameOrEmailCtl.text}');
    log('password: ${passwordCtl.text}');

    if (usernameOrEmailCtl.text.isEmpty || passwordCtl.text.isEmpty) {
      setState(() {
        errorText = 'กรุณาใส่ข้อมูลให้ครบทุกช่อง';
      });
      _showErrorDialog('กรุณาใส่ข้อมูลให้ครบทุกช่อง');
      return;
    }
    var data = UsersLoginPostRequest(
      usernameOrEmail: usernameOrEmailCtl.text,
      password: passwordCtl.text,
    );
    log('Sending data: ${jsonEncode(data.toJson())}');

    try {
      var response = await http.post(
        Uri.parse('$API_ENDPOINT/login'),
        headers: {"Content-Type": "application/json; charset=utf-8"},
        body: jsonEncode(data.toJson()),
      );
      // log('Status code: ${response.statusCode}');
      // log('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        // log('Response data: $responseData');

        UsersLoginPostResponse users =
            UsersLoginPostResponse.fromJson(responseData['users']);

        // log("Email: ${users.email}");
        // log("UserName: ${users.username}");
        log("uid : ${users.uid}");
        log("type : ${users.type}");

        int userType = users.type;
        int uid = users.uid;

        if (userType == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AdminhomePage(uid: uid),
            ),
          );
        } else if (userType == 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(uid: uid),
            ),
          );
        } else {
          _showErrorDialog('ไม่สามารถกำหนดประเภทผู้ใช้ได้');
        }
      } else {
        // var responseData = jsonDecode(response.body);
        // log('Response data: $responseData');

        String errorMessage = 'ชื่อผู้ใช้ หรือ อีเมล และ รหัสผ่านไม่ถูกต้อง';

        setState(() {
          errorText = errorMessage;
        });
        _showErrorDialog(errorMessage);
      }
    } catch (e) {
      log('Error: $e');
      setState(() {
        errorText = 'ไม่สามารถเข้าสู่ระบบได้ ลองใหม่อีกครั้ง';
      });
      _showErrorDialog('ไม่สามารถเข้าสู่ระบบได้ ลองใหม่อีกครั้ง');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                  child: Container(
                    color: Colors.black.withOpacity(0),
                  ),
                ),
              ),
              Container(
                height: 210,
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(45),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 10),
                    AnimatedCheckmark(isSuccess: false),
                    SizedBox(height: 10),
                    Container(
                      child: Text(
                        ' เข้าสู่ระบบไม่สำเร็จ',
                        style: TextStyle(
                          fontFamily: 'SukhumvitSet',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color(0xFF000000),
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      message,
                      style: TextStyle(
                        fontFamily: 'SukhumvitSet',
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Color(0xFF000000),
                      ),
                    ),
                    SizedBox(height: 15),
                    Column(
                      children: [
                        Container(
                          height: 1,
                          decoration: BoxDecoration(
                            color: Color(0xffB3B3B3),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                child: Text(
                                  'ตกลง',
                                  style: TextStyle(
                                    fontFamily: 'SukhumvitSet',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Color(0xFF007AFF),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
