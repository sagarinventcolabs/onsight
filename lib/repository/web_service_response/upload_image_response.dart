/// JobNumber : "W-105681"
/// JobFolderUrl : "https://nthdegree2eo.sharepoint.com/:f:/s/Stage-LaborPhotos/Evc_R3m7k_RKuTClTdgI7SEB_oZymYAGw9LA72ezjpK8Rg"
/// AccidentJobFolderUrl : ""
/// CategoryModelDetails : [{"CategoryId":"327309f1-fe5c-48e6-96be-8076fa139215","CategoryName":"Install\nFreight","ImageCount":14,"ImageUrl":"https://nthdegree2eo.sharepoint.com/:f:/s/Stage-LaborPhotos/Epf5N844CHBIkwCYhDncHdQBcEqdtm0fd_pkmcD-Q_GB-g","PhotoUploadSummaryDetails":[{"FileName":"Raaaaaaaaaa11.jpg","Message":"Photo\nUploaded successfully","UploadStatus":1,"UploadStatusString":"Success"}]}]
/// IsJobFolderMovedInNewLibrary : false

class UploadImageResponse {
  UploadImageResponse({
      String? jobNumber, 
      String? jobFolderUrl, 
      String? accidentJobFolderUrl, 
      List<CategoryModelDetails>? categoryModelDetails, 
      bool? isJobFolderMovedInNewLibrary,}){
    _jobNumber = jobNumber;
    _jobFolderUrl = jobFolderUrl;
    _accidentJobFolderUrl = accidentJobFolderUrl;
    _categoryModelDetails = categoryModelDetails;
    _isJobFolderMovedInNewLibrary = isJobFolderMovedInNewLibrary;
}

  UploadImageResponse.fromJson(dynamic json) {
    _jobNumber = json['JobNumber'];
    _jobFolderUrl = json['JobFolderUrl'];
    _accidentJobFolderUrl = json['AccidentJobFolderUrl'];
    if (json['CategoryModelDetails'] != null) {
      _categoryModelDetails = [];
      json['CategoryModelDetails'].forEach((v) {
        _categoryModelDetails?.add(CategoryModelDetails.fromJson(v));
      });
    }
    _isJobFolderMovedInNewLibrary = json['IsJobFolderMovedInNewLibrary'];
  }
  String? _jobNumber;
  String? _jobFolderUrl;
  String? _accidentJobFolderUrl;
  List<CategoryModelDetails>? _categoryModelDetails;
  bool? _isJobFolderMovedInNewLibrary;
UploadImageResponse copyWith({  String? jobNumber,
  String? jobFolderUrl,
  String? accidentJobFolderUrl,
  List<CategoryModelDetails>? categoryModelDetails,
  bool? isJobFolderMovedInNewLibrary,
}) => UploadImageResponse(  jobNumber: jobNumber ?? _jobNumber,
  jobFolderUrl: jobFolderUrl ?? _jobFolderUrl,
  accidentJobFolderUrl: accidentJobFolderUrl ?? _accidentJobFolderUrl,
  categoryModelDetails: categoryModelDetails ?? _categoryModelDetails,
  isJobFolderMovedInNewLibrary: isJobFolderMovedInNewLibrary ?? _isJobFolderMovedInNewLibrary,
);
  String? get jobNumber => _jobNumber;
  String? get jobFolderUrl => _jobFolderUrl;
  String? get accidentJobFolderUrl => _accidentJobFolderUrl;
  List<CategoryModelDetails>? get categoryModelDetails => _categoryModelDetails;
  bool? get isJobFolderMovedInNewLibrary => _isJobFolderMovedInNewLibrary;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['JobNumber'] = _jobNumber;
    map['JobFolderUrl'] = _jobFolderUrl;
    map['AccidentJobFolderUrl'] = _accidentJobFolderUrl;
    if (_categoryModelDetails != null) {
      map['CategoryModelDetails'] = _categoryModelDetails?.map((v) => v.toJson()).toList();
    }
    map['IsJobFolderMovedInNewLibrary'] = _isJobFolderMovedInNewLibrary;
    return map;
  }

}

/// CategoryId : "327309f1-fe5c-48e6-96be-8076fa139215"
/// CategoryName : "Install\nFreight"
/// ImageCount : 14
/// ImageUrl : "https://nthdegree2eo.sharepoint.com/:f:/s/Stage-LaborPhotos/Epf5N844CHBIkwCYhDncHdQBcEqdtm0fd_pkmcD-Q_GB-g"
/// PhotoUploadSummaryDetails : [{"FileName":"Raaaaaaaaaa11.jpg","Message":"Photo\nUploaded successfully","UploadStatus":1,"UploadStatusString":"Success"}]

class CategoryModelDetails {
  CategoryModelDetails({
      String? categoryId, 
      String? categoryName, 
      num? imageCount, 
      String? imageUrl, 
      List<PhotoUploadSummaryDetails>? photoUploadSummaryDetails,}){
    _categoryId = categoryId;
    _categoryName = categoryName;
    _imageCount = imageCount;
    _imageUrl = imageUrl;
    _photoUploadSummaryDetails = photoUploadSummaryDetails;
}

  CategoryModelDetails.fromJson(dynamic json) {
    _categoryId = json['CategoryId'];
    _categoryName = json['CategoryName'];
    _imageCount = json['ImageCount'];
    _imageUrl = json['ImageUrl'];
    if (json['PhotoUploadSummaryDetails'] != null) {
      _photoUploadSummaryDetails = [];
      json['PhotoUploadSummaryDetails'].forEach((v) {
        _photoUploadSummaryDetails?.add(PhotoUploadSummaryDetails.fromJson(v));
      });
    }
  }
  String? _categoryId;
  String? _categoryName;
  num? _imageCount;
  String? _imageUrl;
  List<PhotoUploadSummaryDetails>? _photoUploadSummaryDetails;
CategoryModelDetails copyWith({  String? categoryId,
  String? categoryName,
  num? imageCount,
  String? imageUrl,
  List<PhotoUploadSummaryDetails>? photoUploadSummaryDetails,
}) => CategoryModelDetails(  categoryId: categoryId ?? _categoryId,
  categoryName: categoryName ?? _categoryName,
  imageCount: imageCount ?? _imageCount,
  imageUrl: imageUrl ?? _imageUrl,
  photoUploadSummaryDetails: photoUploadSummaryDetails ?? _photoUploadSummaryDetails,
);
  String? get categoryId => _categoryId;
  String? get categoryName => _categoryName;
  num? get imageCount => _imageCount;
  String? get imageUrl => _imageUrl;
  List<PhotoUploadSummaryDetails>? get photoUploadSummaryDetails => _photoUploadSummaryDetails;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['CategoryId'] = _categoryId;
    map['CategoryName'] = _categoryName;
    map['ImageCount'] = _imageCount;
    map['ImageUrl'] = _imageUrl;
    if (_photoUploadSummaryDetails != null) {
      map['PhotoUploadSummaryDetails'] = _photoUploadSummaryDetails?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// FileName : "Raaaaaaaaaa11.jpg"
/// Message : "Photo\nUploaded successfully"
/// UploadStatus : 1
/// UploadStatusString : "Success"

class PhotoUploadSummaryDetails {
  PhotoUploadSummaryDetails({
      String? fileName, 
      String? message, 
      num? uploadStatus, 
      String? uploadStatusString,}){
    _fileName = fileName;
    _message = message;
    _uploadStatus = uploadStatus;
    _uploadStatusString = uploadStatusString;
}

  PhotoUploadSummaryDetails.fromJson(dynamic json) {
    _fileName = json['FileName'];
    _message = json['Message'];
    _uploadStatus = json['UploadStatus'];
    _uploadStatusString = json['UploadStatusString'];
  }
  String? _fileName;
  String? _message;
  num? _uploadStatus;
  String? _uploadStatusString;
PhotoUploadSummaryDetails copyWith({  String? fileName,
  String? message,
  num? uploadStatus,
  String? uploadStatusString,
}) => PhotoUploadSummaryDetails(  fileName: fileName ?? _fileName,
  message: message ?? _message,
  uploadStatus: uploadStatus ?? _uploadStatus,
  uploadStatusString: uploadStatusString ?? _uploadStatusString,
);
  String? get fileName => _fileName;
  String? get message => _message;
  num? get uploadStatus => _uploadStatus;
  String? get uploadStatusString => _uploadStatusString;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['FileName'] = _fileName;
    map['Message'] = _message;
    map['UploadStatus'] = _uploadStatus;
    map['UploadStatusString'] = _uploadStatusString;
    return map;
  }

}