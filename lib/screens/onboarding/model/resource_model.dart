/// ItemId : 8
/// FirstName : "test"
/// LastName : "test23333"
/// Status : "New"
/// Show : "S-101545"
/// MobilePhone : "7718011243"
/// Union : "dev"
/// Classification : "test"
/// Notes : "test"
/// SSN : "test"
/// City : "test"
/// ID : false
/// SSCard : false
/// W4 : false
/// I9 : true
/// I9Supporting : true
/// DirectDepositForm : true
/// DirectDepositSuppporting : true

class ResourceModel {
  ResourceModel({
      num? itemId, 
      String? firstName, 
      String? lastName, 
      String? status, 
      String? show, 
      String? mobilePhone, 
      String? union, 
      String? classification, 
      String? notes, 
      String? ssn, 
      String? city, 
      bool? id, 
      bool? sSCard, 
      bool? w4, 
      bool? i9, 
      bool? i9Supporting, 
      bool? directDepositForm, 
      bool? directDepositSuppporting,}){
    _itemId = itemId;
    _firstName = firstName;
    _lastName = lastName;
    _status = status;
    _show = show;
    _mobilePhone = mobilePhone;
    _union = union;
    _classification = classification;
    _notes = notes;
    _ssn = ssn;
    _city = city;
    _id = id;
    _sSCard = sSCard;
    _w4 = w4;
    _i9 = i9;
    _i9Supporting = i9Supporting;
    _directDepositForm = directDepositForm;
    _directDepositSuppporting = directDepositSuppporting;
}

  ResourceModel.fromJson(dynamic json) {
    _itemId = json['ItemId'];
    _firstName = json['FirstName'];
    _lastName = json['LastName'];
    _status = json['Status'];
    _show = json['Show'];
    _mobilePhone = json['MobilePhone'];
    _union = json['Union'];
    _classification = json['Classification'];
    _notes = json['Notes'];
    _ssn = json['SSN'];
    _city = json['City'];
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
  String? _status;
  String? _show;
  String? _mobilePhone;
  String? _union;
  String? _classification;
  String? _notes;
  String? _ssn;
  String? _city;
  bool? _id;
  bool? _sSCard;
  bool? _w4;
  bool? _i9;
  bool? _i9Supporting;
  bool? _directDepositForm;
  bool? _directDepositSuppporting;
ResourceModel copyWith({  num? itemId,
  String? firstName,
  String? lastName,
  String? status,
  String? show,
  String? mobilePhone,
  String? union,
  String? classification,
  String? notes,
  String? ssn,
  String? city,
  bool? id,
  bool? sSCard,
  bool? w4,
  bool? i9,
  bool? i9Supporting,
  bool? directDepositForm,
  bool? directDepositSuppporting,
}) => ResourceModel(  itemId: itemId ?? _itemId,
  firstName: firstName ?? _firstName,
  lastName: lastName ?? _lastName,
  status: status ?? _status,
  show: show ?? _show,
  mobilePhone: mobilePhone ?? _mobilePhone,
  union: union ?? _union,
  classification: classification ?? _classification,
  notes: notes ?? _notes,
  ssn: ssn ?? _ssn,
  city: city ?? _city,
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
  String? get status => _status;
  String? get show => _show;
  String? get mobilePhone => _mobilePhone;
  String? get union => _union;
  String? get classification => _classification;
  String? get notes => _notes;
  String? get ssn => _ssn;
  String? get city => _city;
  bool? get id => _id;
  bool? get sSCard => _sSCard;
  bool? get w4 => _w4;
  bool? get i9 => _i9;
  bool? get i9Supporting => _i9Supporting;
  bool? get directDepositForm => _directDepositForm;
  bool? get directDepositSuppporting => _directDepositSuppporting;



  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ItemId'] = _itemId;
    map['FirstName'] = _firstName;
    map['LastName'] = _lastName;
    map['Status'] = _status;
    map['Show'] = _show;
    map['MobilePhone'] = _mobilePhone;
    map['Union'] = _union;
    map['Classification'] = _classification;
    map['Notes'] = _notes;
    map['SSN'] = _ssn;
    map['City'] = _city;
    map['ID'] = _id;
    map['SSCard'] = _sSCard;
    map['W4'] = _w4;
    map['I9'] = _i9;
    map['I9Supporting'] = _i9Supporting;
    map['DirectDepositForm'] = _directDepositForm;
    map['DirectDepositSuppporting'] = _directDepositSuppporting;
    return map;
  }

  set lastName(String? value) {
    _lastName = value;
  }

  set mobilePhone(String? value) {
    _mobilePhone = value;
  }

  set classification(String? value) {
    _classification = value;
  }

  set notes(String? value) {
    _notes = value;
  }
  set firstName(String? value) {
    _firstName = value;
  }

  set union(String? value) {
    _union = value;
  }

  set city(String? value) {
    _city = value;
  }
}