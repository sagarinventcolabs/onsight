/// EmailAddress : "test73@gmail.com"
/// FirstName : "Rohit"
/// LastName : "Sharma"

class FetchProfileResponse {
  FetchProfileResponse({
      String? emailAddress, 
      String? firstName, 
      String? lastName,}){
    _emailAddress = emailAddress;
    _firstName = firstName;
    _lastName = lastName;
}

  FetchProfileResponse.fromJson(dynamic json) {
    _emailAddress = json['EmailAddress'];
    _firstName = json['FirstName'];
    _lastName = json['LastName'];
  }
  String? _emailAddress;
  String? _firstName;
  String? _lastName;
FetchProfileResponse copyWith({  String? emailAddress,
  String? firstName,
  String? lastName,
}) => FetchProfileResponse(  emailAddress: emailAddress ?? _emailAddress,
  firstName: firstName ?? _firstName,
  lastName: lastName ?? _lastName,
);
  String? get emailAddress => _emailAddress;
  String? get firstName => _firstName;
  String? get lastName => _lastName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['EmailAddress'] = _emailAddress;
    map['FirstName'] = _firstName;
    map['LastName'] = _lastName;
    return map;
  }

  set lastName(String? value) {
    _lastName = value;
  }

  set firstName(String? value) {
    _firstName = value;
  }

  set emailAddress(String? value) {
    _emailAddress = value;
  }
}