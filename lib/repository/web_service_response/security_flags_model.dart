/// MenuItems : "Job Photos"
/// isAllowed : true

class SecurityFlagsModel {
  SecurityFlagsModel({
      String? menuItems, 
      bool? isAllowed,}){
    _menuItems = menuItems;
    _isAllowed = isAllowed;
}

  SecurityFlagsModel.fromJson(dynamic json) {
    _menuItems = json['MenuItems'];
    _isAllowed = json['isAllowed'];
  }
  String? _menuItems;
  bool? _isAllowed;
SecurityFlagsModel copyWith({  String? menuItems,
  bool? isAllowed,
}) => SecurityFlagsModel(  menuItems: menuItems ?? _menuItems,
  isAllowed: isAllowed ?? _isAllowed,
);
  String? get menuItems => _menuItems;
  bool? get isAllowed => _isAllowed;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['MenuItems'] = _menuItems;
    map['isAllowed'] = _isAllowed;
    return map;
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map['MenuItems'] = _menuItems;
    map['isAllowed'] = _isAllowed==false?0:1;
    return map;
  }

}