
class OnBoardingDocumentImageModel{

  int? rowID;
  int? position;
  String? count;
  String? YetToSubmit;
  String? resourceKey;
  String? categoryName;
  String? imageName ;
  String? imageNote ;
  String? imagePath ;
  int? isSubmitted ;

  OnBoardingDocumentImageModel(
      {
        this.rowID,
        this.count,
        this.categoryName,
        this.imageName,
        this.imageNote,
        this.imagePath,
        this.isSubmitted,

      });

  OnBoardingDocumentImageModel.fromJson(dynamic json) {
    categoryName = json['categoryName'] ?? "";
    count = json['count'] ?? "";
    imageName = json['ImageName'] ?? "";
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

    map['Position'] = position;
    map['ResourceKey'] = resourceKey;
    map['Count'] = count;
    map['YetToSubmit'] = YetToSubmit;
    map['CatName'] = categoryName;
    map['ImageName'] = imageName;
    map['ImagePath'] = imagePath;
    map['IsSubmitted'] = isSubmitted ?? 0;

    return map;
  }


  OnBoardingDocumentImageModel.fromDBJson(dynamic json) {
    rowID = json['RowID']??0;
    resourceKey = json['ResourceKey'] ?? "";
    position =  json['Position']!=null?int.parse(json['Position'].toString()):0;
    categoryName = json['CatName'] ?? "";
    count = json['Count']!=null?json['Count'].toString():"0";
    YetToSubmit = json['YetToSubmit'] ?? "";
    imageName = json['ImageName'] ?? "";
    imagePath = json['ImagePath'] ?? "";
    isSubmitted =json['IsSubmitted'].toString()=='null'?0: int.parse(json['IsSubmitted'].toString());

  }
}