/// Notes : "Pics for INSTALL FREIGHT"
/// CategoryName : "Install Freight"
/// CategoryId : "327309F1-FE5C-48E6-96BE-8076FA139215"
/// ImageTotalCount : "10"
/// IsEmailRequired : true
/// RequestId : "a9c1b118-e2a0-4625-9757-82e64859969e"

class NotesModel {
  NotesModel({
      String? notes, 
      String? categoryName, 
      String? categoryId, 
      String? imageTotalCount, 
      bool? isEmailRequired, 
      bool? isPromoPictures,
      String? requestId,}){
    _notes = notes;
    _categoryName = categoryName;
    _categoryId = categoryId;
    _imageTotalCount = imageTotalCount;
    _isEmailRequired = isEmailRequired;
    _isPromoPictures = isPromoPictures;
    _requestId = requestId;
}

  NotesModel.fromJson(dynamic json) {
    _notes = json['Notes'];
    _categoryName = json['CategoryName'];
    _categoryId = json['CategoryId'];
    _imageTotalCount = json['ImageTotalCount'];
    _isEmailRequired = json['IsEmailRequired'];
    _isPromoPictures = json['IsPromoPictures']??false;
    _requestId = json['RequestId'];
  }
  String? _notes;
  String? _categoryName;
  String? _categoryId;
  String? _imageTotalCount;
  bool? _isEmailRequired;
  bool? _isPromoPictures;
  String? _requestId;
NotesModel copyWith({  String? notes,
  String? categoryName,
  String? categoryId,
  String? imageTotalCount,
  bool? isEmailRequired,
  bool? isPromoPictures,
  String? requestId,
}) => NotesModel(  notes: notes ?? _notes,
  categoryName: categoryName ?? _categoryName,
  categoryId: categoryId ?? _categoryId,
  imageTotalCount: imageTotalCount ?? _imageTotalCount,
  isEmailRequired: isEmailRequired ?? _isEmailRequired,
  isPromoPictures: promoFlag ?? _isPromoPictures,
  requestId: requestId ?? _requestId,
);
  String? get notes => _notes;
  String? get categoryName => _categoryName;
  String? get categoryId => _categoryId;
  String? get imageTotalCount => _imageTotalCount;
  bool? get isEmailRequired => _isEmailRequired;
  bool? get promoFlag => _isPromoPictures;
  String? get requestId => _requestId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Notes'] = _notes;
    map['CategoryName'] = _categoryName;
    map['CategoryId'] = _categoryId;
    map['ImageTotalCount'] = _imageTotalCount;
    map['IsEmailRequired'] = _isEmailRequired;
    map['RequestId'] = _requestId;
    map['IsPromoPictures'] = _isPromoPictures;
    return map;
  }
}