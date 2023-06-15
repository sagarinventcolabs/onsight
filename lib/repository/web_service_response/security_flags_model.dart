/// MenuItems : "Job Photos"
/// isAllowed : true

class SecurityFlagsModel {
  SecurityFlagsModel({
      String? menuItems, 
      String? levelFlag,
      bool? isAllowed,
      int? UpdateWO,

  }){
    _menuItems = menuItems;
    _isAllowed = isAllowed;
    _UpdateWO = UpdateWO;
}

  SecurityFlagsModel.fromJson(dynamic json) {
    _menuItems = json['MenuItems'];
    _isAllowed = json['isAllowed'];
    _levelFlag = json['Flag'];
    _UpdateWO = json['UpdateWO']??0;
  }
  String? _menuItems;
  String? _levelFlag;
  bool? _isAllowed;
  int? _UpdateWO;
SecurityFlagsModel copyWith({  String? menuItems,
  bool? isAllowed,
}) => SecurityFlagsModel(  menuItems: menuItems ?? _menuItems,
  isAllowed: isAllowed ?? _isAllowed,
  levelFlag: levelFlag ?? _levelFlag,
  UpdateWO: _UpdateWO ?? _UpdateWO,
);
  String? get menuItems => _menuItems;
  String? get levelFlag => _levelFlag;
  bool? get isAllowed => _isAllowed;
  int? get UpdateWO => _UpdateWO;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['MenuItems'] = _menuItems;
    map['isAllowed'] = _isAllowed;
    map['isUpdateWO'] = _UpdateWO;
    map['Flag'] = _levelFlag;
    return map;
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map['MenuItems'] = _menuItems;
    map['isAllowed'] = _isAllowed==false?0:1;
    return map;
  }

}