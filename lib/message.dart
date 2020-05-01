class Message {
  final String message;

  Message({this.message});
  factory Message.fromJson(Map<String, dynamic> json) {
    return new Message(
      message: json['newMessage'].toString(),
    );
  }
}