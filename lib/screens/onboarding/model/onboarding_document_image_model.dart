
class OnBoardingDocumentImageModel{

  int? rowID;
  String? categoryName;
  String? imageName ;
  String? imageNote ;
  String? imagePath ;
  int? isSubmitted ;

  OnBoardingDocumentImageModel(
      {
        this.rowID,
        this.categoryName,
        this.imageName,
        this.imageNote,
        this.imagePath,
        this.isSubmitted,

      });

  OnBoardingDocumentImageModel.fromJson(dynamic json) {
    categoryName = json['categoryName'] ?? "";
    imageName = json['ImageName'] ?? "";
    imageNote = json['ImageNote'] ?? "";
    imagePath = json['ImagePath'] ?? "";
    isSubmitted =json['IsSubmitted'].toString()=='null'?0: int.parse(json['IsSubmitted'].toString());

  }
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map['RowID'] = rowID;
    map['categoryName'] = categoryName;
    map['ImageName'] = imageName;
    map['ImageNote'] = imageNote;
    map['ImagePath'] = imagePath;
    map['IsSubmitted'] = isSubmitted ?? 0;


    return map;
  }

  Map<String, dynamic> toDb() {
    final map = <String, dynamic>{};
    map['categoryName'] = categoryName;
    map['ImageName'] = imageName;
    map['ImageNote'] = imageNote;
    map['ImagePath'] = imagePath;
    map['IsSubmitted'] = isSubmitted ?? 0;

    return map;
  }
}