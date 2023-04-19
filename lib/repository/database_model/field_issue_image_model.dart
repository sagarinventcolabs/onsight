
class FieldIssueImageModel{

  int? rowID;
  String? woNumber;
  String? imageName ;
  String? imageNote ;
  String? imagePath ;
  int? isSubmitted ;

  FieldIssueImageModel(
      {
        this.rowID,
        this.woNumber,
        this.imageName,
        this.imageNote,
        this.imagePath,
        this.isSubmitted,

      });

  FieldIssueImageModel.fromJson(dynamic json) {
    rowID = json['RowID'] ?? 0;
    woNumber = json['WoNumber'] ?? "";
    imageName = json['ImageName'] ?? "";
    imageNote = json['ImageNote'] ?? "";
    imagePath = json['ImagePath'] ?? "";
    isSubmitted =json['IsSubmitted'].toString()=='null'?0: int.parse(json['IsSubmitted'].toString());

  }
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
      map['RowID'] = rowID;
      map['WoNumber'] = woNumber;
      map['ImageName'] = imageName;
      map['ImageNote'] = imageNote;
      map['ImagePath'] = imagePath;
      map['IsSubmitted'] = isSubmitted ?? 0;


    return map;
  }

  Map<String, dynamic> toDb() {
    final map = <String, dynamic>{};
    map['WoNumber'] = woNumber;
    map['ImageName'] = imageName;
    map['ImageNote'] = imageNote;
    map['ImagePath'] = imagePath;
    map['IsSubmitted'] = isSubmitted ?? 0;

    return map;
  }
}