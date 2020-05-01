class User {
  final String name;
  final String authToken;

  User({this.name, this.authToken});
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
    name: json['username'].toString(),
    authToken: json['token'].toString(),
    );
  }
}