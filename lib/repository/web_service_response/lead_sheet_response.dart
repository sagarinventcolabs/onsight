/// ShowNumber : "S-105645"
/// ShowDetails : {"ShowName":"VAPE\nSHOWCASE","StartDate":"2018-07-16T04:00:00Z","EndDate":"2018-07-16T04:00:00Z","ShowCity":"Atlanta","ShowGC":"FREEMAN\nDECORATING\nCO","ShowGuid":"25e3195b-cb85-49a8-b374-1762ababce6f","Id":"1922"}
/// Exhibitors : [{"ExhibitorName":"Test","BoothSize":"","BoothNumber":"","Shop":"","SetupCompany":"","Notes":"","FolderUrl":"","ExhibitorImageCount":0,"ExhibitorGuid":"7a5e5de4-6bc0-4422-94c4-38cdc3f9fb4a","ExhibitorId":"8092","IsHighPriority":false,"ShowName":null},{"ExhibitorName":"abc","BoothSize":"20*20","BoothNumber":"123","Shop":"SACKS\nEXHIBITS","SetupCompany":"SHO-LINK","Notes":"red","FolderUrl":"","ExhibitorImageCount":0,"ExhibitorGuid":"0f95d4ed-439a-439e-8ef6-c99921791c8e","ExhibitorId":"8549","IsHighPriority":false,"ShowName":null},{"ExhibitorName":"Ara","BoothSize":"20*20","BoothNumber":"KA01","Shop":"DERSE","SetupCompany":"EAGLE","Notes":"dest","FolderUrl":"","ExhibitorImageCount":0,"ExhibitorGuid":"9c5eb379-a78b-497d-9b8c-e7daaab7d0c6","ExhibitorId":"8550","IsHighPriority":false,"ShowName":null}]

class LeadSheetResponse {
  LeadSheetResponse({
      String? showNumber, 
      ShowDetails? showDetails, 
      List<Exhibitors>? exhibitors,}){
    _showNumber = showNumber;
    _showDetails = showDetails;
    _exhibitors = exhibitors;
}

  LeadSheetResponse.fromJson(dynamic json) {
    _showNumber = json['ShowNumber'];
    _showDetails = json['ShowDetails'] != null ? ShowDetails.fromJson(json['ShowDetails']) : null;
    if (json['Exhibitors'] != null) {
      _exhibitors = [];
      json['Exhibitors'].forEach((v) {
        _exhibitors?.add(Exhibitors.fromJson(v));
      });
    }
  }
  String? _showNumber;
  ShowDetails? _showDetails;
  List<Exhibitors>? _exhibitors;
LeadSheetResponse copyWith({  String? showNumber,
  ShowDetails? showDetails,
  List<Exhibitors>? exhibitors,
}) => LeadSheetResponse(  showNumber: showNumber ?? _showNumber,
  showDetails: showDetails ?? _showDetails,
  exhibitors: exhibitors ?? _exhibitors,
);
  String? get showNumber => _showNumber;
  ShowDetails? get showDetails => _showDetails;
  List<Exhibitors>? get exhibitors => _exhibitors;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ShowNumber'] = _showNumber;
    if (_showDetails != null) {
      map['ShowDetails'] = _showDetails?.toJson();
    }
    if (_exhibitors != null) {
      map['Exhibitors'] = _exhibitors?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// ExhibitorName : "Test"
/// BoothSize : ""
/// BoothNumber : ""
/// Shop : ""
/// SetupCompany : ""
/// Notes : ""
/// FolderUrl : ""
/// ExhibitorImageCount : 0
/// ExhibitorGuid : "7a5e5de4-6bc0-4422-94c4-38cdc3f9fb4a"
/// ExhibitorId : "8092"
/// IsHighPriority : false
/// ShowName : null

class Exhibitors {
  Exhibitors({
      String? exhibitorName, 
      String? boothSize, 
      String? boothNumber, 
      String? shop, 
      String? setupCompany, 
      String? notes, 
      String? folderUrl, 
      int? exhibitorImageCount,
      String? exhibitorGuid, 
      String? exhibitorId, 
      bool? isHighPriority, 
      String? showName,
      int? yetToSubmit
  }){
    _exhibitorName = exhibitorName;
    _boothSize = boothSize;
    _boothNumber = boothNumber;
    _shop = shop;
    _setupCompany = setupCompany;
    _notes = notes;
    _folderUrl = folderUrl;
    _exhibitorImageCount = exhibitorImageCount;
    _exhibitorGuid = exhibitorGuid;
    _exhibitorId = exhibitorId;
    _isHighPriority = isHighPriority;
    _showName = showName;
    _yetToSubmit = yetToSubmit;
}

  Exhibitors.fromJson(dynamic json) {
    _exhibitorName = json['ExhibitorName'];
    _boothSize = json['BoothSize'];
    _boothNumber = json['BoothNumber'];
    _shop = json['Shop'];
    _setupCompany = json['SetupCompany'];
    _notes = json['Notes'];
    _folderUrl = json['FolderUrl'];
    _exhibitorImageCount = json['ExhibitorImageCount'];
    _exhibitorGuid = json['ExhibitorGuid'];
    _exhibitorId = json['ExhibitorId'];
    _isHighPriority = json['IsHighPriority'];
    _showName = json['ShowName'];
  }


  Exhibitors.fromDb(dynamic json) {
    _showNumber = json['ShowNumber'];
    _exhibitorName = json['ExhibitorName'];
    _boothSize = json['BoothSize'];
    _boothNumber = json['BoothNumber'];
    _shop = json['Shop'];
    _setupCompany = json['SetupCompany'];
    _notes = json['Notes'];
    _folderUrl = json['FolderUrl'];
    _exhibitorImageCount = json['ExhibitorImageCount'];
    _exhibitorGuid = json['ExhibitorGuid'];
    _exhibitorId = json['ExhibitorId'];
    _isHighPriority = json['IsHighPriority']!=null?json['IsHighPriority']==1?true:false:false;
    _showName = json['ShowName'];
    _yetToSubmit = json['YetToSubmit'];
  }
  String? _exhibitorName;
  String? _boothSize;
  String? _boothNumber;
  String? _shop;
  String? _setupCompany;
  String? _notes;
  String? _folderUrl;
  int? _exhibitorImageCount;
  String? _exhibitorGuid;
  String? _exhibitorId;
  bool? _isHighPriority;
  String? _showName;
  String? _showNumber;
  int? _yetToSubmit;
Exhibitors copyWith({  String? exhibitorName,
  String? boothSize,
  String? boothNumber,
  String? shop,
  String? setupCompany,
  String? notes,
  String? folderUrl,
  int? exhibitorImageCount,
  String? exhibitorGuid,
  String? exhibitorId,
  bool? isHighPriority,
  String? showName,
}) => Exhibitors(  exhibitorName: exhibitorName ?? _exhibitorName,
  boothSize: boothSize ?? _boothSize,
  boothNumber: boothNumber ?? _boothNumber,
  shop: shop ?? _shop,
  setupCompany: setupCompany ?? _setupCompany,
  notes: notes ?? _notes,
  folderUrl: folderUrl ?? _folderUrl,
  exhibitorImageCount: exhibitorImageCount ?? _exhibitorImageCount,
  exhibitorGuid: exhibitorGuid ?? _exhibitorGuid,
  exhibitorId: exhibitorId ?? _exhibitorId,
  isHighPriority: isHighPriority ?? _isHighPriority,
  showName: showName ?? _showName,
);
  String? get exhibitorName => _exhibitorName;
  String? get boothSize => _boothSize;
  String? get boothNumber => _boothNumber;
  String? get shop => _shop;
  String? get setupCompany => _setupCompany;
  String? get notes => _notes;
  String? get folderUrl => _folderUrl;
  int? get exhibitorImageCount => _exhibitorImageCount;
  String? get exhibitorGuid => _exhibitorGuid;
  String? get exhibitorId => _exhibitorId;
  bool? get isHighPriority => _isHighPriority;
  String? get showName => _showName;
  int? get yetToSubmit => _yetToSubmit;

  String? get showNumber => _showNumber;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ExhibitorName'] = _exhibitorName;
    map['BoothSize'] = _boothSize;
    map['BoothNumber'] = _boothNumber;
    map['Shop'] = _shop;
    map['SetupCompany'] = _setupCompany;
    map['Notes'] = _notes;
    map['FolderUrl'] = _folderUrl;
    map['ExhibitorImageCount'] = _exhibitorImageCount;
    map['ExhibitorGuid'] = _exhibitorGuid;
    map['ExhibitorId'] = _exhibitorId;
    map['IsHighPriority'] = _isHighPriority;
    map['ShowName'] = _showName;
    return map;
  }

  set showNumber(String? value) {
    _showNumber = value;
  }

  set exhibitorImageCount(int? value) {
    _exhibitorImageCount = value;
  }

  set folderUrl(String? value) {
    _folderUrl = value;
  }

  set boothSize(String? value) {
    _boothSize = value;
  }

  set yetToSubmit(int? value) {
    _yetToSubmit = value;
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map['ShowNumber'] = _showNumber;
    map['ExhibitorName'] = _exhibitorName;
    map['BoothSize'] = _boothSize;
    map['BoothNumber'] = _boothNumber;
    map['Shop'] = _shop;
    map['SetupCompany'] = _setupCompany;
    map['Notes'] = _notes;
    map['FolderUrl'] = _folderUrl;
    map['ExhibitorImageCount'] = _exhibitorImageCount;
    map['ExhibitorGuid'] = _exhibitorGuid;
    map['ExhibitorId'] = _exhibitorId;
    map['YetToSubmit'] = _yetToSubmit;
    map['IsHighPriority'] = _isHighPriority;
    return map;
  }

}

/// ShowName : "VAPE\nSHOWCASE"
/// StartDate : "2018-07-16T04:00:00Z"
/// EndDate : "2018-07-16T04:00:00Z"
/// ShowCity : "Atlanta"
/// ShowGC : "FREEMAN\nDECORATING\nCO"
/// ShowGuid : "25e3195b-cb85-49a8-b374-1762ababce6f"
/// Id : "1922"

class ShowDetails {
  ShowDetails({
      String? showName, 
      String? startDate, 
      String? endDate, 
      String? showCity, 
      String? showGC, 
      String? showGuid, 
      String? id,}){
    _showName = showName;
    _startDate = startDate;
    _endDate = endDate;
    _showCity = showCity;
    _showGC = showGC;
    _showGuid = showGuid;
    _id = id;
}

  ShowDetails.fromJson(dynamic json) {
    _showName = json['ShowName'];
    _startDate = json['StartDate'];
    _endDate = json['EndDate'];
    _showCity = json['ShowCity'];
    _showGC = json['ShowGC'];
    _showGuid = json['ShowGuid'];
    _id = json['Id'];
  }

  ShowDetails.fromDb(dynamic json) {
    _showNumber = json['ShowNumber'];
    _showName = json['ShowName'];
    _startDate = json['StartDate'];
    _endDate = json['EndDate'];
    _showCity = json['ShowCity'];
    _showGC = json['ShowGC'];
    _showGuid = json['ShowGuid'];
    _id = json['Id'];
  }
  String? _showNumber;
  String? _showName;
  String? _startDate;
  String? _endDate;
  String? _showCity;
  String? _showGC;
  String? _showGuid;
  String? _id;
ShowDetails copyWith({  String? showName,
  String? startDate,
  String? endDate,
  String? showCity,
  String? showGC,
  String? showGuid,
  String? id,
}) => ShowDetails(  showName: showName ?? _showName,
  startDate: startDate ?? _startDate,
  endDate: endDate ?? _endDate,
  showCity: showCity ?? _showCity,
  showGC: showGC ?? _showGC,
  showGuid: showGuid ?? _showGuid,
  id: id ?? _id,
);
  String? get showNumber => _showNumber;
  String? get showName => _showName;
  String? get startDate => _startDate;
  String? get endDate => _endDate;
  String? get showCity => _showCity;
  String? get showGC => _showGC;
  String? get showGuid => _showGuid;
  String? get id => _id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ShowName'] = _showName;
    map['StartDate'] = _startDate;
    map['EndDate'] = _endDate;
    map['ShowCity'] = _showCity;
    map['ShowGC'] = _showGC;
    map['ShowGuid'] = _showGuid;
    map['Id'] = _id;
    return map;
  }

  set showNumber(String? value) {
    _showNumber = value;
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map['ShowNumber'] = _showNumber;
    map['ShowName'] = _showName;
    map['StartDate'] = _startDate;
    map['EndDate'] = _endDate;
    map['ShowCity'] = _showCity;
    map['ShowGC'] = _showGC;
    map['ShowGuid'] = _showGuid;
    map['Id'] = _id;
    return map;
  }

}