class ErrorResponse {
  ErrorResponse({
      this.error, 
      this.errorDescription,
      this.message
  });

  ErrorResponse.fromJson(dynamic json) {
    error = json['error'];
    errorDescription = json['error_description'];
    message = json['Message'];
  }
  String? error;
  String? errorDescription;
  String? message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['error'] = error;
    map['error_description'] = errorDescription;
    map['Message'] = message;
    return map;
  }

}




