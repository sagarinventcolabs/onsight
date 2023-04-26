/// Id : "25802805-c9d2-4d16-b008-085344df8763"
/// TypeId : 6
/// Name : "I-9 C\n(Auth)"
/// RowId : 5

class CatModel {
  CatModel({
      String? id, 
      num? typeId, 
      String? name, 
      int? rowId,}){
    _id = id;
    _typeId = typeId;
    _name = name;
    _rowId = rowId;
}

  CatModel.fromJson(dynamic json) {
    _id = json['Id'];
    _typeId = json['TypeId'];
    _name = json['Name'];
    _rowId = json['RowId'];
  }
  String? _id;
  num? _typeId;
  String? _name;
  int? _rowId;
CatModel copyWith({  String? id,
  num? typeId,
  String? name,
  int? rowId,
}) => CatModel(  id: id ?? _id,
  typeId: typeId ?? _typeId,
  name: name ?? _name,
  rowId: rowId ?? _rowId,
);
  String? get id => _id;
  num? get typeId => _typeId;
  String? get name => _name;
  int? get rowId => _rowId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Id'] = _id;
    map['TypeId'] = _typeId;
    map['Name'] = _name;
    map['RowId'] = _rowId;
    return map;
  }

}