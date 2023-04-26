/// MenuItems : "Job Photos"
/// isAllowed : true

class SecurityFlagsModel {
  SecurityFlagsModel({
      String? menuItems, 
      String? levelFlag,
      bool? isAllowed,

  }){
    _menuItems = menuItems;
    _isAllowed = isAllowed;
}

  SecurityFlagsModel.fromJson(dynamic json) {
    _menuItems = json['MenuItems'];
    _isAllowed = json['isAllowed'];
    _levelFlag = json['Flag'];
  }
  String? _menuItems;
  String? _levelFlag;
  bool? _isAllowed;
SecurityFlagsModel copyWith({  String? menuItems,
  bool? isAllowed,
}) => SecurityFlagsModel(  menuItems: menuItems ?? _menuItems,
  isAllowed: isAllowed ?? _isAllowed,
  levelFlag: levelFlag ?? _levelFlag,
);
  String? get menuItems => _menuItems;
  String? get levelFlag => _levelFlag;
  bool? get isAllowed => _isAllowed;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['MenuItems'] = _menuItems;
    map['isAllowed'] = _isAllowed;
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