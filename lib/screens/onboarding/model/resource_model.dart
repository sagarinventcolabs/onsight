class EditResourceModel{

  String city = "";
  String classification = "";
  String mobile = "";
  String union = "";



  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['City'] = city;
    map['Classification'] = classification;
    map['Mobile'] = mobile;
    map['Union'] = union;
    return map;
  }

}