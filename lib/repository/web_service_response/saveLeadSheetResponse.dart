/// ShowNumber : "S-105645"
/// ShowFolderUrl : "https://nthdegree2eo.sharepoint.com/:f:/s/Stage-LaborPhotos/Ek8UBa-YGyxClj5mdTa0b4MB_34AhmrvKgCwO4lhz-b04w"
/// Exhibitor : "Ara"
/// ExhibitorId : "8550"
/// ExhibitorGuid : "9c5eb379-a78b-497d-9b8c-e7daaab7d0c6"
/// ExhibitorFolderUrl : "https://nthdegree2eo.sharepoint.com/:f:/s/Stage-LaborPhotos/EjLV2-S9klVKtrf9WhcnsG4BhI6npqQTG0agRYoCGA6i0w"
/// ExhibitorPhotoCount : 21
/// UploadedPhotosSummaryList : [{"Filename":"824ae6f2-5ec5-48f7-970b-a4edc88e80fc13371436619960763991663824126976.jpg","Status":true,"Message":"Photo Uploaded successfully","UploadStatus":1,"UploadStatusString":"Success"}]

class SaveLeadSheetResponse {
  SaveLeadSheetResponse({
      String? showNumber, 
      String? showFolderUrl, 
      String? exhibitor, 
      String? exhibitorId, 
      String? exhibitorGuid, 
      String? exhibitorFolderUrl, 
      num? exhibitorPhotoCount, 
      List<UploadedPhotosSummaryList>? uploadedPhotosSummaryList,}){
    _showNumber = showNumber;
    _showFolderUrl = showFolderUrl;
    _exhibitor = exhibitor;
    _exhibitorId = exhibitorId;
    _exhibitorGuid = exhibitorGuid;
    _exhibitorFolderUrl = exhibitorFolderUrl;
    _exhibitorPhotoCount = exhibitorPhotoCount;
    _uploadedPhotosSummaryList = uploadedPhotosSummaryList;
}

  SaveLeadSheetResponse.fromJson(dynamic json) {
    _showNumber = json['ShowNumber'];
    _showFolderUrl = json['ShowFolderUrl'];
    _exhibitor = json['Exhibitor'];
    _exhibitorId = json['ExhibitorId'];
    _exhibitorGuid = json['ExhibitorGuid'];
    _exhibitorFolderUrl = json['ExhibitorFolderUrl'];
    _exhibitorPhotoCount = json['ExhibitorPhotoCount'];
    if (json['UploadedPhotosSummaryList'] != null) {
      _uploadedPhotosSummaryList = [];
      json['UploadedPhotosSummaryList'].forEach((v) {
        _uploadedPhotosSummaryList?.add(UploadedPhotosSummaryList.fromJson(v));
      });
    }
  }
  String? _showNumber;
  String? _showFolderUrl;
  String? _exhibitor;
  String? _exhibitorId;
  String? _exhibitorGuid;
  String? _exhibitorFolderUrl;
  num? _exhibitorPhotoCount;
  List<UploadedPhotosSummaryList>? _uploadedPhotosSummaryList;
SaveLeadSheetResponse copyWith({  String? showNumber,
  String? showFolderUrl,
  String? exhibitor,
  String? exhibitorId,
  String? exhibitorGuid,
  String? exhibitorFolderUrl,
  num? exhibitorPhotoCount,
  List<UploadedPhotosSummaryList>? uploadedPhotosSummaryList,
}) => SaveLeadSheetResponse(  showNumber: showNumber ?? _showNumber,
  showFolderUrl: showFolderUrl ?? _showFolderUrl,
  exhibitor: exhibitor ?? _exhibitor,
  exhibitorId: exhibitorId ?? _exhibitorId,
  exhibitorGuid: exhibitorGuid ?? _exhibitorGuid,
  exhibitorFolderUrl: exhibitorFolderUrl ?? _exhibitorFolderUrl,
  exhibitorPhotoCount: exhibitorPhotoCount ?? _exhibitorPhotoCount,
  uploadedPhotosSummaryList: uploadedPhotosSummaryList ?? _uploadedPhotosSummaryList,
);
  String? get showNumber => _showNumber;
  String? get showFolderUrl => _showFolderUrl;
  String? get exhibitor => _exhibitor;
  String? get exhibitorId => _exhibitorId;
  String? get exhibitorGuid => _exhibitorGuid;
  String? get exhibitorFolderUrl => _exhibitorFolderUrl;
  num? get exhibitorPhotoCount => _exhibitorPhotoCount;
  List<UploadedPhotosSummaryList>? get uploadedPhotosSummaryList => _uploadedPhotosSummaryList;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ShowNumber'] = _showNumber;
    map['ShowFolderUrl'] = _showFolderUrl;
    map['Exhibitor'] = _exhibitor;
    map['ExhibitorId'] = _exhibitorId;
    map['ExhibitorGuid'] = _exhibitorGuid;
    map['ExhibitorFolderUrl'] = _exhibitorFolderUrl;
    map['ExhibitorPhotoCount'] = _exhibitorPhotoCount;
    if (_uploadedPhotosSummaryList != null) {
      map['UploadedPhotosSummaryList'] = _uploadedPhotosSummaryList?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// Filename : "824ae6f2-5ec5-48f7-970b-a4edc88e80fc13371436619960763991663824126976.jpg"
/// Status : true
/// Message : "Photo Uploaded successfully"
/// UploadStatus : 1
/// UploadStatusString : "Success"

class UploadedPhotosSummaryList {
  UploadedPhotosSummaryList({
      String? filename, 
      bool? status, 
      String? message, 
      num? uploadStatus, 
      String? uploadStatusString,}){
    _filename = filename;
    _status = status;
    _message = message;
    _uploadStatus = uploadStatus;
    _uploadStatusString = uploadStatusString;
}

  UploadedPhotosSummaryList.fromJson(dynamic json) {
    _filename = json['Filename'];
    _status = json['Status'];
    _message = json['Message'];
    _uploadStatus = json['UploadStatus'];
    _uploadStatusString = json['UploadStatusString'];
  }
  String? _filename;
  bool? _status;
  String? _message;
  num? _uploadStatus;
  String? _uploadStatusString;
UploadedPhotosSummaryList copyWith({  String? filename,
  bool? status,
  String? message,
  num? uploadStatus,
  String? uploadStatusString,
}) => UploadedPhotosSummaryList(  filename: filename ?? _filename,
  status: status ?? _status,
  message: message ?? _message,
  uploadStatus: uploadStatus ?? _uploadStatus,
  uploadStatusString: uploadStatusString ?? _uploadStatusString,
);
  String? get filename => _filename;
  bool? get status => _status;
  String? get message => _message;
  num? get uploadStatus => _uploadStatus;
  String? get uploadStatusString => _uploadStatusString;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Filename'] = _filename;
    map['Status'] = _status;
    map['Message'] = _message;
    map['UploadStatus'] = _uploadStatus;
    map['UploadStatusString'] = _uploadStatusString;
    return map;
  }

}