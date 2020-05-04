

class Response {
  final int responseCode;
  final String token;
  final String message;

  Response({this.responseCode, this.token, this.message});
  factory Response.fromJson(Map<String, dynamic> json) {
    return new Response(
      responseCode: json['responseCode'],
      token: json['user']['token'] != null? json['user']['token']: null,
      message: json['message'],
    );

  }
  Map<String, dynamic> toJson() => {
    "message" : message == null ? null : message,
    "responseCode": responseCode == null ? null : responseCode
  };
}