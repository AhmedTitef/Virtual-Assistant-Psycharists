import 'package:flutter/material.dart';
import 'package:virtual_assistant/chat_screen.dart';
import 'package:virtual_assistant/loginscreen.dart';
import 'package:virtual_assistant/screen1.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     initialRoute: MainScreen.id,
      routes: {
       MainScreen.id: (context) => MyHomePage(),
        ChatScreen.id: (context) => ChatScreen(),
      },
    );
  }
}
