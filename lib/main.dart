import 'package:flutter/material.dart';
import 'ScanningPage.dart';

void main() => runApp(LoginPage());

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Color(0xFF282828),
          primaryColor: Color(0xFF121212)),
      home: ScanningPage(),
    );
  }
}
