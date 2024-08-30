import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // เพิ่มการนำเข้าของ SystemChrome
import 'package:lotto_app/pages/intro.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('th_TH', null);

  // ตั้งค่าสีของ Status Bar
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.black, // สีพื้นหลังของ Status Bar
      statusBarIconBrightness: Brightness.light, // สีของไอคอนใน Status Bar
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application. 
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: IntroPage(),
    );
  }
}
