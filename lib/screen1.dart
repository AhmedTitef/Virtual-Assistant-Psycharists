import 'dart:async';

import 'package:flutter/material.dart';
import 'package:virtual_assistant/chat_screen.dart';

class MainScreen extends StatefulWidget {
  static String id = "main_screen";

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var name = "";
  var password = "";

  var textFieldInput;

  var show1 = true;
  var show4 = false;
  var show2 = true;
  var show3 = false;


  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.white, Colors.blue],
          )),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  "Welcome to Psychariast Assistant!",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Card(
                  shape: CircleBorder(),
                  elevation: 20,
                  child: CircleAvatar(
                    radius: 100.0,
                    backgroundImage: AssetImage("assets/06-512.png"),
                  ),
                ),
                Visibility(
                  visible: show1,
                  child: Text("Please Enter Your Username", style: TextStyle(fontSize: 20),),
                ),
                Visibility(
                  visible: show4,
                  child: Text("Please Enter Your Password", style: TextStyle(fontSize: 20),),
                ),

                Visibility(
                  visible: show2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 120),
                    child: Container(
                      child: TextField(
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          setState(() {
                            textFieldInput = value;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: show4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 120),
                    child: Container(
                      child: TextField(
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          setState(() {
                            textFieldInput = value;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Visibility(visible: show3, child: Text("Hello $name" , style: TextStyle(fontSize: 20),)),
                RaisedButton(
                  color: Colors.greenAccent,
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  onPressed: () {
                    setState(() {
                      name = textFieldInput;
                      password = textFieldInput;
                      show1 = false;
                      show4 = false;
                      show2 = false;
                      show3 = true;
                    });
                    Future.delayed(Duration(seconds: 2), () {
                      Navigator.pushNamed(context, ChatScreen.id);
                    });
                  },
                  child: Text("Submit"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
