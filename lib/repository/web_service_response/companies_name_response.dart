import 'dart:convert';
/// SetupCompany : "ABSOLUTE"

CompaniesNameResponse companiesNameResponseFromJson(String str) => CompaniesNameResponse.fromJson(json.decode(str));
String companiesNameResponseToJson(CompaniesNameResponse data) => json.encode(data.toJson());
class CompaniesNameResponse {
  CompaniesNameResponse({
      String? setupCompany,}){
    _setupCompany = setupCompany;
}

  CompaniesNameResponse.fromJson(dynamic json) {
    _setupCompany = json['SetupCompany'];
  }
  String? _setupCompany;
CompaniesNameResponse copyWith({  String? setupCompany,
}) => CompaniesNameResponse(  setupCompany: setupCompany ?? _setupCompany,
);
  String? get setupCompany => _setupCompany;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['SetupCompany'] = _setupCompany;
    return map;
  }

}