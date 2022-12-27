import 'package:on_sight_application/repository/database_model/image_model.dart';

/// Id : "b9c8f682-5109-482f-bc4f-098811a52d72"
/// TypeId : 2
/// Name : "Special\nHandling"
/// RowId : 8

class JobCategoriesResponse {
  JobCategoriesResponse({
      String? id, 
      num? typeId, 
      String? name, 
      num? rowId,
      var yetToSubmit,
      var submitted,
      var url,
      List<ImageModel>? listPhotos,
  bool? isChecked = false,
    bool? sendEmail = true
  }){
    _id = id;
    _typeId = typeId;
    _name = name;
    _rowId = rowId;
    _isChecked = isChecked;
    _sendEmail = sendEmail;
    _yetToSubmit = yetToSubmit;
    _submitted = submitted;
    _url = url;
    _listPhotos = listPhotos;
}

  JobCategoriesResponse.fromJson(dynamic json, i) {
    _id = json[i]['Id'];
    _typeId = json[i]['TypeId'];
    _name = json[i]['Name'];
    _rowId = json[i]['RowId'];
    _isChecked = json[i]['isChecked'];
    _sendEmail = json[i]['sendEmail'];
    _yetToSubmit = json[i]['yetToSubmit'];
    _submitted = json[i]['submitted'];
    _url = json[i]['url'];
     if (json[i]['listPhotos'] != null) {
      _listPhotos = [];
      json[i]['listPhotos'].forEach((v) {
        _listPhotos?.add(ImageModel.fromJson(v));
      });
    };

  }
  String? _id;
  num? _typeId;
  String? _name;
  num? _rowId;
  bool? _isChecked;
  bool? _sendEmail;
  var _yetToSubmit;
  var _submitted;
  var _url;
  List<ImageModel>? _listPhotos;
JobCategoriesResponse copyWith({  String? id,
  num? typeId,
  String? name,
  num? rowId,
  bool? isChecked,
  bool? sendEmail,
  var yetToSubmit,
  var submitted,
  var url,
  List<ImageModel>? listPhotos
}) => JobCategoriesResponse(  id: id ?? _id,
  typeId: typeId ?? _typeId,
  name: name ?? _name,
  rowId: rowId ?? _rowId,
  isChecked: isChecked ?? _isChecked,
  sendEmail: sendEmail ?? _sendEmail,
  yetToSubmit: yetToSubmit ?? _yetToSubmit,
  submitted: submitted ?? _submitted,
  url: url ?? _url,
  listPhotos: listPhotos ?? _listPhotos,
);
  String? get id => _id;
  num? get typeId => _typeId;
  String? get name => _name;
  num? get rowId => _rowId;
  bool? get isChecked => _isChecked;
  bool? get sendEmail => _sendEmail;
  dynamic get yetToSubmit => _yetToSubmit;
  dynamic get submitted => _submitted;
  dynamic get url => _url;
  List<ImageModel>? get listPhotos => _listPhotos;


  Map<String, dynamic> toJson() {

    final map = <String, dynamic>{};
    map['Id'] = _id;
    map['TypeId'] = _typeId;
    map['Name'] = _name;
    map['RowId'] = _rowId;
    map['isChecked'] = _isChecked;
    map['sendEmail'] = sendEmail;
    map['yetToSubmit'] = _yetToSubmit;
    map['submitted'] = _submitted;
    map['url'] = _url;
    map['listPhotos'] = _listPhotos!=null?_listPhotos!.map((e) => e.toMap()).toList():null;
    return map;
  }


  set id(String? value) {
    _id = value;
  }

  Map<String, dynamic> toMap() {

    final map = <String, dynamic>{};
    map['Id'] = _id;
    map['TypeId'] = _typeId;
    map['Name'] = _name;
    map['RowId'] = _rowId;
    map['isChecked'] = _isChecked;
    map['sendEmail'] = sendEmail;
    map['yetToSubmit'] = _yetToSubmit;
    map['submitted'] = _submitted;
    map['url'] = _url;
    return map;
  }
  set isChecked(bool? value) {
    _isChecked = value;
  }

  set listPhotos(List<ImageModel>? value) {
    _listPhotos = value;
  }

  set submitted(value) {
    _submitted = value;
  }

  set yetToSubmit(value) {
    _yetToSubmit = value;
  }

  set sendEmail(bool? value) {
    _sendEmail = value;
  }
  set url(dynamic value) {
    _url = value;
  }

  set name(String? value) {
    _name = value;
  }
}