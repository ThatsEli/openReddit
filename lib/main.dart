import 'package:flutter/material.dart';
import 'package:redditclient/pages/login.dart';
import 'package:redditclient/stores/redditStore.dart';

// void main() => runApp(MyApp());

main() {
  RedditStore.init();
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
      home: Login(),
    );
  }
}
