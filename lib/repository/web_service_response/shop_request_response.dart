import 'dart:convert';
/// Shop : "2020 EXHIBITS"

ShopRequestResponse shopRequestResponseFromJson(String str) => ShopRequestResponse.fromJson(json.decode(str));
String shopRequestResponseToJson(ShopRequestResponse data) => json.encode(data.toJson());
class ShopRequestResponse {
  ShopRequestResponse({
      String? shop,}){
    _shop = shop;
}

  ShopRequestResponse.fromJson(dynamic json) {
    _shop = json['Shop'];
  }
  String? _shop;
ShopRequestResponse copyWith({  String? shop,
}) => ShopRequestResponse(  shop: shop ?? _shop,
);
  String? get shop => _shop;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Shop'] = _shop;
    return map;
  }

}