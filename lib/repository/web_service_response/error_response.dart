class ErrorResponse {
  ErrorResponse({
      this.error, 
      this.errorDescription,
      this.Message
  });

  ErrorResponse.fromJson(dynamic json) {
    error = json['error'];
    errorDescription = json['error_description'];
    Message = json['Message'];
  }
  String? error;
  String? errorDescription;
  String? Message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['error'] = error;
    map['error_description'] = errorDescription;
    map['Message'] = Message;
    return map;
  }

}




