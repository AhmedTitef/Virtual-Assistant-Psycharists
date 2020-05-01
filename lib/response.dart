class Response {
  final int responseCode;

  Response({this.responseCode});
  factory Response.fromJson(Map<String, dynamic> json) {
    return new Response(
      responseCode: json['responseCode'],
    );
  }
}