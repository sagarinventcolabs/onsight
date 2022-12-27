/// ShowNumber : "18CH10ACR"
/// ShowDetailInput : {"ShowName":"AM COLL RHEUMATOLOGY","StartDate":"2018-07-16T04:00:00Z","EndDate":"2018-07-16T04:00:00Z","ShowCity":"Chicago             ","ShowGC":"BREDE/ALLIED CONVENTION SVCS  ","ShowGuid":"0542565b-15fc-43d9-9d23-80c202dfecb0","Id":"316"}
/// ExhibitorInput : {"ExhibitorName":"Exhibitor Andy Test#18CH10ACR","BoothSize":"200*200","BoothNumber":"200","Shop":"shop200","SetupCompany":"C200","Notes":"Andy Test Exhibitor_QA","FolderUrl":"","ExhibitorImageCount":0,"ExhibitorGuid":"f71b1f3a-34b5-4c56-b890-ab0174ad26e9","ExhibitorId":"695"}

class SaveExhibitorImagesRequest {
  SaveExhibitorImagesRequest({
      String? showNumber, 
      ShowDetailInput? showDetailInput, 
      ExhibitorInput? exhibitorInput,}){
    _showNumber = showNumber;
    _showDetailInput = showDetailInput;
    _exhibitorInput = exhibitorInput;
}

  SaveExhibitorImagesRequest.fromJson(dynamic json) {
    _showNumber = json['ShowNumber'];
    _showDetailInput = json['ShowDetailInput'] != null ? ShowDetailInput.fromJson(json['ShowDetailInput']) : null;
    _exhibitorInput = json['ExhibitorInput'] != null ? ExhibitorInput.fromJson(json['ExhibitorInput']) : null;
  }
  String? _showNumber;
  ShowDetailInput? _showDetailInput;
  ExhibitorInput? _exhibitorInput;
SaveExhibitorImagesRequest copyWith({  String? showNumber,
  ShowDetailInput? showDetailInput,
  ExhibitorInput? exhibitorInput,
}) => SaveExhibitorImagesRequest(  showNumber: showNumber ?? _showNumber,
  showDetailInput: showDetailInput ?? _showDetailInput,
  exhibitorInput: exhibitorInput ?? _exhibitorInput,
);
  String? get showNumber => _showNumber;
  ShowDetailInput? get showDetailInput => _showDetailInput;
  ExhibitorInput? get exhibitorInput => _exhibitorInput;

  set showNumber(String? value) {
    _showNumber = value;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ShowNumber'] = _showNumber;
    if (_showDetailInput != null) {
      map['ShowDetailInput'] = _showDetailInput?.toJson();
    }
    if (_exhibitorInput != null) {
      map['ExhibitorInput'] = _exhibitorInput?.toJson();
    }
    return map;
  }

  set showDetailInput(ShowDetailInput? value) {
    _showDetailInput = value;
  }

  set exhibitorInput(ExhibitorInput? value) {
    _exhibitorInput = value;
  }
}

/// ExhibitorName : "Exhibitor Andy Test#18CH10ACR"
/// BoothSize : "200*200"
/// BoothNumber : "200"
/// Shop : "shop200"
/// SetupCompany : "C200"
/// Notes : "Andy Test Exhibitor_QA"
/// FolderUrl : ""
/// ExhibitorImageCount : 0
/// ExhibitorGuid : "f71b1f3a-34b5-4c56-b890-ab0174ad26e9"
/// ExhibitorId : "695"

class ExhibitorInput {
  ExhibitorInput({
      String? exhibitorName, 
      String? boothSize, 
      String? boothNumber, 
      String? shop, 
      String? setupCompany, 
      String? notes, 
      String? folderUrl, 
      num? exhibitorImageCount, 
      String? exhibitorGuid, 
      String? exhibitorId,}){
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
}

  ExhibitorInput.fromJson(dynamic json) {
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
  }
  String? _exhibitorName;
  String? _boothSize;
  String? _boothNumber;
  String? _shop;
  String? _setupCompany;
  String? _notes;
  String? _folderUrl;
  num? _exhibitorImageCount;
  String? _exhibitorGuid;
  String? _exhibitorId;
ExhibitorInput copyWith({  String? exhibitorName,
  String? boothSize,
  String? boothNumber,
  String? shop,
  String? setupCompany,
  String? notes,
  String? folderUrl,
  num? exhibitorImageCount,
  String? exhibitorGuid,
  String? exhibitorId,
}) => ExhibitorInput(  exhibitorName: exhibitorName ?? _exhibitorName,
  boothSize: boothSize ?? _boothSize,
  boothNumber: boothNumber ?? _boothNumber,
  shop: shop ?? _shop,
  setupCompany: setupCompany ?? _setupCompany,
  notes: notes ?? _notes,
  folderUrl: folderUrl ?? _folderUrl,
  exhibitorImageCount: exhibitorImageCount ?? _exhibitorImageCount,
  exhibitorGuid: exhibitorGuid ?? _exhibitorGuid,
  exhibitorId: exhibitorId ?? _exhibitorId,
);
  String? get exhibitorName => _exhibitorName;
  String? get boothSize => _boothSize;
  String? get boothNumber => _boothNumber;
  String? get shop => _shop;
  String? get setupCompany => _setupCompany;
  String? get notes => _notes;
  String? get folderUrl => _folderUrl;
  num? get exhibitorImageCount => _exhibitorImageCount;
  String? get exhibitorGuid => _exhibitorGuid;
  String? get exhibitorId => _exhibitorId;

  set exhibitorImageCount(num? value) {
    _exhibitorImageCount = value;
  }

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
    return map;
  }

}

/// ShowName : "AM COLL RHEUMATOLOGY"
/// StartDate : "2018-07-16T04:00:00Z"
/// EndDate : "2018-07-16T04:00:00Z"
/// ShowCity : "Chicago             "
/// ShowGC : "BREDE/ALLIED CONVENTION SVCS  "
/// ShowGuid : "0542565b-15fc-43d9-9d23-80c202dfecb0"
/// Id : "316"

class ShowDetailInput {
  ShowDetailInput({
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

  ShowDetailInput.fromJson(dynamic json) {
    _showName = json['ShowName'];
    _startDate = json['StartDate'];
    _endDate = json['EndDate'];
    _showCity = json['ShowCity'];
    _showGC = json['ShowGC'];
    _showGuid = json['ShowGuid'];
    _id = json['Id'];
  }
  String? _showName;
  String? _startDate;
  String? _endDate;
  String? _showCity;
  String? _showGC;
  String? _showGuid;
  String? _id;
ShowDetailInput copyWith({  String? showName,
  String? startDate,
  String? endDate,
  String? showCity,
  String? showGC,
  String? showGuid,
  String? id,
}) => ShowDetailInput(  showName: showName ?? _showName,
  startDate: startDate ?? _startDate,
  endDate: endDate ?? _endDate,
  showCity: showCity ?? _showCity,
  showGC: showGC ?? _showGC,
  showGuid: showGuid ?? _showGuid,
  id: id ?? _id,
);
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

}