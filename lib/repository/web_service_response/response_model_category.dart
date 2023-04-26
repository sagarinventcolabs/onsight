import 'package:on_sight_application/screens/onboarding/model/onboarding_document_image_model.dart';

/// ItemId : 286
/// FirstName : "Sagar"
/// LastName : "Test"
/// ID : 0
/// SSCard : 0
/// W4 : 0
/// I9 : 0
/// I9Supporting : 0
/// DirectDepositForm : 0
/// DirectDepositSuppporting : 1

class ResponseModelCategory {
  ResponseModelCategory({
      num? itemId, 
      String? firstName, 
      String? lastName, 
      num? id, 
      num? sSCard, 
      num? w4, 
      num? i9, 
      num? i9Supporting, 
      num? directDepositForm, 
      num? directDepositSuppporting,}){
    _itemId = itemId;
    _firstName = firstName;
    _lastName = lastName;
    _id = id;
    _sSCard = sSCard;
    _w4 = w4;
    _i9 = i9;
    _i9Supporting = i9Supporting;
    _directDepositForm = directDepositForm;
    _directDepositSuppporting = directDepositSuppporting;
}

  ResponseModelCategory.fromJson(dynamic json) {
    _itemId = json['ItemId'];
    _firstName = json['FirstName'];
    _lastName = json['LastName'];
    _id = json['ID'];
    _sSCard = json['SSCard'];
    _w4 = json['W4'];
    _i9 = json['I9'];
    _i9Supporting = json['I9Supporting'];
    _directDepositForm = json['DirectDepositForm'];
    _directDepositSuppporting = json['DirectDepositSuppporting'];
  }
  num? _itemId;
  String? _firstName;
  String? _lastName;
  num? _id;
  num? _sSCard;
  num? _w4;
  num? _i9;
  num? _i9Supporting;
  num? _directDepositForm;
  num? _directDepositSuppporting;
  List<OnBoardingDocumentImageModel>? _listImage = [];
ResponseModelCategory copyWith({  num? itemId,
  String? firstName,
  String? lastName,
  num? id,
  num? sSCard,
  num? w4,
  num? i9,
  num? i9Supporting,
  num? directDepositForm,
  num? directDepositSuppporting,
}) => ResponseModelCategory(  itemId: itemId ?? _itemId,
  firstName: firstName ?? _firstName,
  lastName: lastName ?? _lastName,
  id: id ?? _id,
  sSCard: sSCard ?? _sSCard,
  w4: w4 ?? _w4,
  i9: i9 ?? _i9,
  i9Supporting: i9Supporting ?? _i9Supporting,
  directDepositForm: directDepositForm ?? _directDepositForm,
  directDepositSuppporting: directDepositSuppporting ?? _directDepositSuppporting,
);
  num? get itemId => _itemId;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  num? get id => _id;
  num? get sSCard => _sSCard;
  num? get w4 => _w4;
  num? get i9 => _i9;
  num? get i9Supporting => _i9Supporting;
  num? get directDepositForm => _directDepositForm;
  num? get directDepositSuppporting => _directDepositSuppporting;
  List<OnBoardingDocumentImageModel>? get listImage => _listImage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ItemId'] = _itemId;
    map['FirstName'] = _firstName;
    map['LastName'] = _lastName;
    map['ID'] = _id;
    map['SSCard'] = _sSCard;
    map['W4'] = _w4;
    map['I9'] = _i9;
    map['I9Supporting'] = _i9Supporting;
    map['DirectDepositForm'] = _directDepositForm;
    map['DirectDepositSuppporting'] = _directDepositSuppporting;
    return map;
  }

}