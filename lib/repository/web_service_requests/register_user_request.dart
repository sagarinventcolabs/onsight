/// ClientId : "Mobile"
/// NewUser : {"EmailAddress":"faiz.anwar@dreamorbit.com","FirstName":"Faiz","LastName":"Anwar"}

class RegisterUserRequest {
  RegisterUserRequest({
      String? clientId, 
      NewUser? newUser,}){
    _clientId = clientId;
    _newUser = newUser;
}

  RegisterUserRequest.fromJson(dynamic json) {
    _clientId = json['ClientId'];
    _newUser = json['NewUser'] != null ? NewUser.fromJson(json['NewUser']) : null;
  }
  String? _clientId;
  NewUser? _newUser;
RegisterUserRequest copyWith({  String? clientId,
  NewUser? newUser,
}) => RegisterUserRequest(  clientId: clientId ?? _clientId,
  newUser: newUser ?? _newUser,
);
  String? get clientId => _clientId;
  NewUser? get newUser => _newUser;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ClientId'] = _clientId;
    if (_newUser != null) {
      map['NewUser'] = _newUser?.toJson();
    }
    return map;
  }

}

/// EmailAddress : "faiz.anwar@dreamorbit.com"
/// FirstName : "Faiz"
/// LastName : "Anwar"

class NewUser {
  NewUser({
      String? emailAddress, 
      String? firstName, 
      String? lastName,}){
    _emailAddress = emailAddress;
    _firstName = firstName;
    _lastName = lastName;
}

  NewUser.fromJson(dynamic json) {
    _emailAddress = json['EmailAddress'];
    _firstName = json['FirstName'];
    _lastName = json['LastName'];
  }
  String? _emailAddress;
  String? _firstName;
  String? _lastName;
NewUser copyWith({  String? emailAddress,
  String? firstName,
  String? lastName,
}) => NewUser(  emailAddress: emailAddress ?? _emailAddress,
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

}