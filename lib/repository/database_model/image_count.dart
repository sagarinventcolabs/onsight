class ImageCount{
  int? rowId ;
  String? categoryId;
  String? jobNumber;
  int? totalImageCount;
  int? totalImageCountServer;
  String? imageLink;


  ImageCount(
      {this.rowId,
      this.categoryId,
        this.jobNumber,
        this.totalImageCount,
        this.totalImageCountServer,
        this.imageLink,
      });

  ImageCount.fromJson(Map<String, dynamic> json) {
    rowId= json['RowID'];
    categoryId = json['CategoryId'];
    jobNumber = json['JobNumber'];
    totalImageCount = json['TotalImageCount'];
    totalImageCountServer = json['TotalImageCountServer'];
    imageLink = json['ImageLink'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowID'] = this.rowId;
    data['CategoryId'] = this.categoryId;
    data['JobNumber'] = this.jobNumber;
    data['TotalImageCount'] = this.totalImageCount;
    data['TotalImageCountServer'] = this.totalImageCountServer;
    data['ImageLink'] = this.imageLink;

    return data;
  }
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
   // map['RowID'] = rowId;
    map['CategoryId'] = categoryId;
    map['JobNumber'] = jobNumber;
    map['TotalImageCount'] = totalImageCount;
    map['TotalImageCountServer'] = totalImageCountServer;
    map['ImageLink'] = imageLink;

    return map;
  }

  ImageCount.fromMapObject(Map<String, dynamic> map) {
    rowId = map['RowID'];
    categoryId = map['CategoryId'];
    jobNumber = map['JobNumber'];
    totalImageCount = map['TotalImageCount'];
    totalImageCountServer = map['TotalImageCountServer'];
    imageLink = map['ImageLink'];
  }
}