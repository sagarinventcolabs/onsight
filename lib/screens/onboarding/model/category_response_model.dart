/// PhotoCount : 0
/// UploadURL : "https://nthdegree2eo.sharepoint.com/:f:/s/Stage-LaborPhotos/ResourceDocuments/Eh7OhWcbUJZIr361WeL9WeYBNJBLbsLcuuWwuNSz68vNoQ"
/// RowId : 5
/// Name : "I-9 C (Auth)"
/// TypeId : 6
/// Id : "25802805-c9d2-4d16-b008-085344df8763"

class CategoryResponseModel {
  CategoryResponseModel({
      num? photoCount, 
      String? uploadURL, 
      num? rowId, 
      String? name, 
      num? typeId, 
      String? id,}){
    _photoCount = photoCount;
    _uploadURL = uploadURL;
    _rowId = rowId;
    _name = name;
    _typeId = typeId;
    _id = id;
}

  CategoryResponseModel.fromJson(dynamic json) {
    _photoCount = json['PhotoCount'];
    _uploadURL = json['UploadURL'];
    _rowId = json['RowId'];
    _name = json['Name'];
    _typeId = json['TypeId'];
    _id = json['Id'];
  }
  num? _photoCount;
  String? _uploadURL;
  num? _rowId;
  String? _name;
  num? _typeId;
  String? _id;
CategoryResponseModel copyWith({  num? photoCount,
  String? uploadURL,
  num? rowId,
  String? name,
  num? typeId,
  String? id,
}) => CategoryResponseModel(  photoCount: photoCount ?? _photoCount,
  uploadURL: uploadURL ?? _uploadURL,
  rowId: rowId ?? _rowId,
  name: name ?? _name,
  typeId: typeId ?? _typeId,
  id: id ?? _id,
);
  num? get photoCount => _photoCount;
  String? get uploadURL => _uploadURL;
  num? get rowId => _rowId;
  String? get name => _name;
  num? get typeId => _typeId;
  String? get id => _id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['PhotoCount'] = _photoCount;
    map['UploadURL'] = _uploadURL;
    map['RowId'] = _rowId;
    map['Name'] = _name;
    map['TypeId'] = _typeId;
    map['Id'] = _id;
    return map;
  }

}