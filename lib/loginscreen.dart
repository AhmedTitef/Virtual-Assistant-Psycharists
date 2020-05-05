import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:virtual_assistant/chat_screen.dart';
import 'package:http/http.dart' as http;
import 'package:virtual_assistant/response.dart';
import 'package:virtual_assistant/error.dart';

import 'User.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

final usernameController = TextEditingController();
final passwordController = TextEditingController();
bool loginFailed = false;
String nullmessage;

class _MyHomePageState extends State<MyHomePage> {
  TextStyle style = TextStyle(fontSize: 20.0);

  //add

  @override
  Widget build(BuildContext context) {
    final usernameField = TextField(
      controller: usernameController,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
        errorText: loginFailed? '': null,
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Username",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final passwordField = TextFormField(
      controller: passwordController,
      obscureText: true,
      style: style,
      decoration: InputDecoration(
          errorText: loginFailed? nullmessage: null,
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
          Response loginResponse =
              await login(usernameController.text, passwordController.text);
          if (loginResponse != null) {
            print("successful logged in");
            loginFailed = false;
            print(loginResponse.token);
            Navigator.pushNamed(context, ChatScreen.id, arguments: loginResponse.token);
          } else {
            print("login failed....");
            loginFailed = true;
          }
          setState(() {
          });
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
          Response signupResponse =
              await signup(usernameController.text, passwordController.text);
          if (signupResponse!= null) {
            print("successful signup");
            print(signupResponse.token);
            loginFailed = false;
            Navigator.pushNamed(context, ChatScreen.id, arguments: signupResponse.token);
          } else {
            print("signup failed");
            loginFailed = true;
          }
          setState(() {

          });
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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 85.0,
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
      ),
    );
  }

  Future <Response> signup(usernameController, passwordController) async {
    try {
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
      var error = responseError.fromJson(json.decode(response.body));
      nullmessage = error.message;
      return Response.fromJson(json.decode(response.body));
    }catch(Exception){
      return null;
    }
  }

  Future<Response> login(usernameController, passwordController) async {
    try {
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
      var error = responseError.fromJson(json.decode(loginResponse.body));
      nullmessage = error.message;
      return Response.fromJson(json.decode(loginResponse.body));

    }catch(Exception){
      return null;
    }

  }
}
