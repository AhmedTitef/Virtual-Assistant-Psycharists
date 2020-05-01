import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:virtual_assistant/chat_screen.dart';
import 'package:http/http.dart' as http;
import 'package:virtual_assistant/response.dart';

import 'User.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.
  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

final usernameController = TextEditingController();
final passwordController = TextEditingController();

class _MyHomePageState extends State<MyHomePage> {
  TextStyle style = TextStyle(fontSize: 20.0);

  @override
  Widget build(BuildContext context) {
    final usernameField = TextField(
      controller: usernameController,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Username",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final passwordField = TextField(
      controller: passwordController,
      obscureText: true,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final loginButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          bool loginResponse =
              await login(usernameController.text, passwordController.text);
          if (loginResponse) {
            print("successful logged in");
            Navigator.pushNamed(context, ChatScreen.id);
          } else {
            print("not successful login");
          }
        },
        child: Text("Login",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
    final signupButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          bool signupResponse =
              await signup(usernameController.text, passwordController.text);
          if (signupResponse) {
            print("successful signup");
            Navigator.pushNamed(context, ChatScreen.id);
          } else {
            print("not successful");
          }
        },
        //{print(usernameController.text + passwordController.text);},
        child: Text("Sign up",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 100.0,
                  child: Image.asset(
                    "assets/06-512.png",
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 30.0),
                usernameField,
                SizedBox(height: 20.0),
                passwordField,
                SizedBox(
                  height: 20.0,
                ),
                loginButon,
                SizedBox(height: 5.0),
                signupButon,
                SizedBox(
                  height: 1.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

//add comment
  //add comment
  //add comment
  //add comment

  Future<bool> signup(usernameController, passwordController) async {
    print('hello');
    Map data = {
      'username': usernameController, //use any username must be unique
      'password': passwordController
    };
    String body = json.encode(data);
    http.Response response = await http.post(
      'http://chatbot-server4800.herokuapp.com/users/login',
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    print("response1 " + response.body);

    var responseCode = Response.fromJson(json.decode(response.body));

    if (responseCode.responseCode == 200) {
      return Future.value(true);
    } else
      return Future.value(false);
  }

  Future<bool> login(usernameController, passwordController) async {
    Map data2 = {
      'username': usernameController, //use any username must be unique
      'password': passwordController
    };
    String body2 = json.encode(data2);
    http.Response loginResponse = await http.post(
      'http://chatbot-server4800.herokuapp.com/users/reAuthenticate',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: body2,
    );
    print("response2 " + loginResponse.body.toString());
    var responseCode = Response.fromJson(json.decode(loginResponse.body));

    //Response.fromJson(json.decode(response.body));
    if (responseCode.responseCode == 200) {
      return Future.value(true);
    } else
      return Future.value(false);
  }
}
