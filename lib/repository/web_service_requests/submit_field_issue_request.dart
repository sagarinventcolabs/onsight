/// Title : "test"
/// Description : "test"
/// WorkOrderNumber : "W-105682"
/// ShowNumber : "S-104321"
/// UserFirstName : "Roopesh"
/// UserLastName : "Test"
/// UserFullName : null
/// CategoryId : 961360000

class SubmitFieldIssueRequest {
  SubmitFieldIssueRequest({
      String? title, 
      String? catName,
      String description = "",
      String? workOrderNumber, 
      String? showNumber, 
      String? userFirstName, 
      String? userLastName, 
      dynamic userFullName, 
      num? categoryId,
      String comment = "",

  }){
    _title = title;
    _description = description;
    _workOrderNumber = workOrderNumber;
    _showNumber = showNumber;
    _userFirstName = userFirstName;
    _userLastName = userLastName;
    _userFullName = userFullName;
    _categoryId = categoryId;
    _comment = comment;
}

  SubmitFieldIssueRequest.fromJson(dynamic json) {
    _title = json['Title'];
    _description = json['Description']??"";
    _workOrderNumber = json['WorkOrderNumber'];
    _showNumber = json['ShowNumber'];
    _userFirstName = json['UserFirstName'];
    _userLastName = json['UserLastName'];
    _userFullName = json['UserFullName'];
    _categoryId = json['CategoryId'];
    _comment = json['Comments']??"";
    _catName= json['CatName']??"";
  }
  String? _title;
  String? _description;
  String? _workOrderNumber;
  String? _showNumber;
  String? _userFirstName;
  String? _userLastName;
  String? _userFullName;
  num? _categoryId;
  String? _comment;
  String? _catName;

  String? get title => _title;
  String? get description => _description;
  String? get workOrderNumber => _workOrderNumber;
  String? get showNumber => _showNumber;
  String? get userFirstName => _userFirstName;
  String? get userLastName => _userLastName;
  String? get userFullName => _userFullName;
  num? get categoryId => _categoryId;
  String? get comment => _comment;
  String? get catName => _catName;


  set title(String? value) {
    _title = value;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Title'] = _title;
    map['Description'] = _description??"";
    map['WorkOrderNumber'] = _workOrderNumber;
    map['ShowNumber'] = _showNumber;
    map['UserFirstName'] = _userFirstName;
    map['UserLastName'] = _userLastName;
    map['UserFullName'] = _userFullName;
    map['CategoryId'] = _categoryId;
    map['Comments'] = _comment??"";
    map['CatName'] = _catName??"";
    return map;
  }

  set description(String? value) {
    _description = value??"";
  }

  set workOrderNumber(String? value) {
    _workOrderNumber = value;
  }

  set showNumber(String? value) {
    _showNumber = value;
  }

  set userFirstName(String? value) {
    _userFirstName = value;
  }

  set userLastName(String? value) {
    _userLastName = value;
  }

  set userFullName(dynamic value) {
    _userFullName = value;
  }

  set categoryId(num? value) {
    _categoryId = value;
  }

  set comment(String? value) {
    _comment = value??"";
  }

  set catName(String? value) {
    _catName = value??"";
  }
}