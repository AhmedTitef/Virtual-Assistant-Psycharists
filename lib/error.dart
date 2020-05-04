class responseError {
  final int responseCode;
  final String message;

  responseError({this.responseCode, this.message});
  factory responseError.fromJson(Map<String, dynamic> json) {
    return new responseError(
      responseCode: json['responseCode'],
      message: json['message'],
    );

  }
}