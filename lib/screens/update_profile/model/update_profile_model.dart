/// Message : "User Details updated successfully"

class UpdateProfileModel {
  UpdateProfileModel({
      String? message,}){
    _message = message;
}

  UpdateProfileModel.fromJson(dynamic json) {
    _message = json['Message'];
  }
  String? _message;
UpdateProfileModel copyWith({  String? message,
}) => UpdateProfileModel(  message: message ?? _message,
);
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Message'] = _message;
    return map;
  }

}