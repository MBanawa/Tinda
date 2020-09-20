import 'package:flutter/material.dart';
import 'package:tinda/View/home_page.dart';


void main() => runApp(MainApp());

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    
//return MaterialApp, Setup Theme Settings, Call Homepage
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.teal,
        scaffoldBackgroundColor: Colors.grey.shade200,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.yellow.shade900,
        ),
      ),
      home: HomePage(),
    );
  }
}
