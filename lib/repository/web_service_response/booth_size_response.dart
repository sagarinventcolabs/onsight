import 'dart:convert';
/// BoothSize : "10*10"

BoothSizeResponse boothSizeResponseFromJson(String str) => BoothSizeResponse.fromJson(json.decode(str));
String boothSizeResponseToJson(BoothSizeResponse data) => json.encode(data.toJson());
class BoothSizeResponse {
  BoothSizeResponse({
      String? boothSize,}){
    _boothSize = boothSize;
}

  BoothSizeResponse.fromJson(dynamic json) {
    _boothSize = json['BoothSize'];
  }
  String? _boothSize;
BoothSizeResponse copyWith({  String? boothSize,
}) => BoothSizeResponse(  boothSize: boothSize ?? _boothSize,
);
  String? get boothSize => _boothSize;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['BoothSize'] = _boothSize;
    return map;
  }

}