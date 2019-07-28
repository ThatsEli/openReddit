import 'package:flutter/material.dart';
import 'package:redditclient/screens/loginScreen.dart';

// void main() => runApp(MyApp());

main() {
  runApp(MyApp());
} 

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Redditclient',
      theme: ThemeData(
        brightness: Brightness.dark
      ),
      home: LoginScreen(),
    );
  }
}
