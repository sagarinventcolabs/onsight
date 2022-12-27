/// Error : {"Code":401,"Message":"The Token has expired"}

class ErrorModel {
  ErrorModel({
      Error? error,}){
    _error = error;
}

  ErrorModel.fromJson(dynamic json) {
    _error = json['Error'] != null ? Error.fromJson(json['Error']) : null;
  }
  Error? _error;
ErrorModel copyWith({  Error? error,
}) => ErrorModel(  error: error ?? _error,
);
  Error? get error => _error;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_error != null) {
      map['Error'] = _error?.toJson();
    }
    return map;
  }

}

/// Code : 401
/// Message : "The Token has expired"

class Error {
  Error({
      num? code, 
      String? message,}){
    _code = code;
    _message = message;
}

  Error.fromJson(dynamic json) {
    _code = json['Code'];
    _message = json['Message'];
  }
  num? _code;
  String? _message;
Error copyWith({  num? code,
  String? message,
}) => Error(  code: code ?? _code,
  message: message ?? _message,
);
  num? get code => _code;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Code'] = _code;
    map['Message'] = _message;
    return map;
  }

}