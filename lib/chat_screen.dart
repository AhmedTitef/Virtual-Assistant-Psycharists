import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';

import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';


import 'package:http/http.dart' as http;

import 'User.dart';
import 'message.dart';

class ChatScreen extends StatefulWidget {
  static String id = "chat_screen";

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

var textEditingController = TextEditingController();
final List<MessageBubble> _messages = <MessageBubble>[];

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();

    initSpeechState();
  }

  var buttonIsPressed = false;
  var buttonColorWhenPressed;

  bool _hasSpeech = false;
  String lastWords = "";
  String lastError = "";
  String lastStatus = "";
  final SpeechToText speech = SpeechToText();

  Future<void> initSpeechState() async {
    bool hasSpeech = await speech.initialize(
        onError: errorListener, onStatus: statusListener);

    if (!mounted) return;
    setState(() {
      _hasSpeech = hasSpeech;
    });
  }

  void micFunctionality() {
    setState(() {
      buttonIsPressed = !buttonIsPressed;
    });
    if (buttonIsPressed) {
      startListening();
    } else if (!buttonIsPressed) {
      cancelListening();
      setState(() {
        textEditingController.text = lastWords;
        messageText = textEditingController.text;
      });
    }
  }

  void startListening() {
    lastWords = "";
    lastError = "";

    speech.listen(onResult: resultListener);

    print("Lastword: $lastWords");
  }

  void stopListening() {
    speech.stop();
    setState(() {});
  }

  void cancelListening() {
    speech.cancel();
    setState(() {});
  }

  void resultListener(SpeechRecognitionResult result) {
    setState(() {
      lastWords = "${result.recognizedWords} ";
    });
  }

  void errorListener(SpeechRecognitionError error) {
    setState(() {
      lastError = "${error.errorMsg} - ${error.permanent}";
    });
  }

  void statusListener(String status) {
    setState(() {
      lastStatus = "$status";
    });
  }

  var messageText;
/**
  void agentResponse(query) async {
    AuthGoogle authGoogle =
        await AuthGoogle(fileJson: "assets/newagent-pyuavn-92b986d8472e.json")
            .build();
    Dialogflow dialogflow =
        Dialogflow(authGoogle: authGoogle, language: Language.english);
    AIResponse response = await dialogflow.detectIntent(query);
    MessageBubble messageBubble = MessageBubble(
    sender: "Bot",
    text: response.getMessage().toString(),
    isMe: false,
    );
    setState(() {
    _messages.insert(0, messageBubble);
    });
  }
*/

  void agentResponse (query) async{
  /**Map data = {
    'username': 'diane', //use any username must be unique
    'password': 'helloworld'
  };

  String body = json.encode(data);

  http.Response response = await http.post(
    'http://chatbot-server4800.herokuapp.com/users/login',
    headers: {"Content-Type": "application/json"},
    body: body,
  );

  print("response1 "+ response.body);

  var user = User.fromJson(json.decode(response.body));
  //var user = User.fromJson(jsonDecode(response.body));
*/
  Map data2 = {
    'message': query
  };

  String body2 = json.encode(data2);

  http.Response response2 = await http.post(
    'http://chatbot-server4800.herokuapp.com/messages',
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI1ZTliNWQ0MTI1YzRlNzAwMTdmN2IyYzgiLCJpYXQiOjE1ODcyNDAyNTd9.jkZ9bnYCnNkF-EeGybABuuY1SOugW0E0Q8cfK-HMqCw'},
    body: body2,
  );
  print("response2 "+ response2.body.toString());

  var message = Message.fromJson(json.decode(response2.body));
  print(message.message.toString());

  MessageBubble messageBubble = MessageBubble(
    sender: "Bot",
    text: message.message.toString(),
    isMe: false,
  );

  setState(() {
    _messages.insert(0, messageBubble);
  });

}


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Colors.white, Colors.blue])),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Flexible(
                  child: ListView.builder(
                    reverse: true,
                    itemBuilder: (_, int index) => _messages[index],
                    itemCount: _messages.length,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                        child: TextField(
                      controller: textEditingController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20),
                          hintText: "Type your message here..."),
                    )),
                    FlatButton(
                      onPressed: () {
                        if (textEditingController.text.isNotEmpty) {
                          MessageBubble message = new MessageBubble(
                            text: messageText,
                            sender: "me",
                            isMe: true,
                          );

                          setState(() {
                            _messages.insert(0, message);
                          });

                          agentResponse(messageText);
                          textEditingController.clear();
                        }
                      },
                      child: Icon(Icons.send),
                    ),
                    FlatButton(
                      onPressed: micFunctionality,
                      color: buttonIsPressed ? Colors.orange : Color(0xFFFFFF),

//

                      child: Icon(Icons.mic),
                    ),

                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({this.sender, this.text, this.isMe});

  final bool isMe;
  final String sender;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            sender,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),
          Material(
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  )
                : BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
            //set each corner indvidually
            elevation: 5.0,
            //add shadows
            color: isMe ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                text,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black54,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
