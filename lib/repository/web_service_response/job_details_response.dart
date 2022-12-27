/// JobPhotosId : 10197
/// WoNumber : "W-105681"
/// FutureShowNumber : null
/// SalesRepId : "68"
/// SourceClientId : "9702D762-E99C-E911-A84D-000D3A178DB2"
/// ExhibitorId : "F7F16932-E89C-E911-A84D-000D3A178DB2"
/// JobNumber : "W-105681"
/// ShowName : "OASIS\nTest Show 2019"
/// ExhibitorName : "B&W Fiberglass"
/// BoothNumber : "3345"
/// ShowCity : "Las\nVegas"
/// ShowStartDate : "2019-08-11T15:00:00"
/// ShowEndDate : "2019-08-12T16:00:00"
/// AdditionalEmail : "ankith.shaji@dreamorbit.com,nazia.sultana@dreamorbit.com,sarath.mr@dreamorbit.com,test1@dreamorbit.com,test2@dreamorbit.com,test3@dreamorbit.com,test5@dreamorbit.com"
/// OasisAdditionalEmail : ""
/// SNumber : null
/// ShowNumber : "S-105645"
/// SourceContactName : null
/// SourceContactMobilePhone : null
/// SourceContactEmail : null
/// SalesRepFirstName : "Josh"
/// SalesRepLastName : "Cook"
/// SalesRepOfficePhone : null
/// SalesRepCellPhone : "(630)546-2511"
/// SalesRepEmailAddress : "JCook@nthdegree.com"
/// Supervision : "Nth\nDegree"
/// SourceName : "Poretta &\nOrr"
/// TakenDateTime : "2022-04-05T13:52:59"
/// UploadDateTime : null
/// CreatedDateUtc : "0001-01-01T00:00:00"
/// CreatedBy : 0
/// ModifiedDateUtc : null
/// ModifiedBy : null
/// JobPhotoDetailsModel : [{"JobPhotoDetailsId":0,"JobPhotosId":0,"TypeValueId":"327309f1-fe5c-48e6-96be-8076fa139215","ImageCount":6,"ImageURL":"https://nthdegree2eo.sharepoint.com/:f:/s/Stage-LaborPhotos/Epf5N844CHBIkwCYhDncHdQBcEqdtm0fd_pkmcD-Q_GB-g","CategoryName":"Install\nFreight","IsDNA":false},{"JobPhotoDetailsId":0,"JobPhotosId":0,"TypeValueId":"aa2468d5-4139-4b73-876d-0ad90832f4a3","ImageCount":33,"ImageURL":"https://nthdegree2eo.sharepoint.com/:f:/s/Stage-LaborPhotos/EvHpu0MVtAZPo2cwoKLZ88ABiiVdQQm2jJBXCPzJ5VHItA","CategoryName":"Show\nReady","IsDNA":false},{"JobPhotoDetailsId":0,"JobPhotosId":0,"TypeValueId":"b9c8f682-5109-482f-bc4f-098811a52d72","ImageCount":1,"ImageURL":"https://nthdegree2eo.sharepoint.com/:f:/s/Stage-LaborPhotos/EreDICSjRkpMnsaxaw39z8AB4Y8AZ_rSrX3z4ZDjcG0LaA","CategoryName":"Special\nHandling","IsDNA":false},{"JobPhotoDetailsId":0,"JobPhotosId":0,"TypeValueId":"5fdc0198-5f6a-4819-bf34-ad0cbfdd6195","ImageCount":3,"ImageURL":"https://nthdegree2eo.sharepoint.com/:f:/s/Stage-LaborPhotos/ErY9SI3xcldLjsLmDdqt_kwB5P77fpkYDfBQjT68S_OGHQ","CategoryName":"Dismantle\nFreight","IsDNA":false},{"JobPhotoDetailsId":0,"JobPhotosId":0,"TypeValueId":"7d23877f-12b3-4ae9-9e6f-d1a284757c57","ImageCount":0,"ImageURL":"","CategoryName":"Outbound\nBOL","IsDNA":false},{"JobPhotoDetailsId":0,"JobPhotosId":0,"TypeValueId":"59d34b15-29bb-4cbb-8c9b-405379b78d47","ImageCount":0,"ImageURL":"","CategoryName":"Install\nProgress","IsDNA":false}]
/// EvaluationInstallUrl : null
/// EvaluationDismantleUrl : null
/// PhotoFlag : null
/// JobEvalFlag : null
/// ShowLocation : "Mandalay\nBay Resort & Casino"
/// ShowGC : null
/// CityOffice : "Las\nVegas"

class JobDetailsResponse {
  JobDetailsResponse({
      num? jobPhotosId, 
      String? woNumber, 
      String? salesRepId,
      String? sourceClientId, 
      String? exhibitorId, 
      String? jobNumber, 
      String? showName, 
      String? exhibitorName, 
      String? boothNumber, 
      String? showCity, 
      String? showStartDate, 
      String? showEndDate, 
      String? additionalEmail, 
      String? oasisAdditionalEmail, 
      String? showNumber,
    String?  sourceContactName,
    String?  sourceContactMobilePhone,
    String?  sourceContactEmail,
      String? salesRepFirstName, 
      String? salesRepLastName,
    String?  salesRepOfficePhone,
      String? salesRepCellPhone, 
      String? salesRepEmailAddress, 
      String? supervision, 
      String? sourceName, 
      String? takenDateTime,
      String? createdDateUtc, 
      num? createdBy, 
      List<JobPhotoDetailsModel>? jobPhotoDetailsModel,
      String? showLocation, 
      String? cityOffice,}){
    _jobPhotosId = jobPhotosId;
    _woNumber = woNumber;
    _salesRepId = salesRepId;
    _sourceClientId = sourceClientId;
    _exhibitorId = exhibitorId;
    _jobNumber = jobNumber;
    _showName = showName;
    _exhibitorName = exhibitorName;
    _boothNumber = boothNumber;
    _showCity = showCity;
    _showStartDate = showStartDate;
    _showEndDate = showEndDate;
    _additionalEmail = additionalEmail;
    _oasisAdditionalEmail = oasisAdditionalEmail;
    _showNumber = showNumber;
    _sourceContactName = sourceContactName;
    _sourceContactMobilePhone = sourceContactMobilePhone;
    _sourceContactEmail = sourceContactEmail;
    _salesRepFirstName = salesRepFirstName;
    _salesRepLastName = salesRepLastName;
    _salesRepOfficePhone = salesRepOfficePhone;
    _salesRepCellPhone = salesRepCellPhone;
    _salesRepEmailAddress = salesRepEmailAddress;
    _supervision = supervision;
    _sourceName = sourceName;
    _takenDateTime = takenDateTime;
    _createdDateUtc = createdDateUtc;
    _createdBy = createdBy;
    _showLocation = showLocation;
    _cityOffice = cityOffice;
}

  JobDetailsResponse.fromJson(dynamic json, i) {
    _jobPhotosId = json[i]['JobPhotosId'];
    _woNumber = json[i]['WoNumber'];
    _salesRepId = json[i]['SalesRepId'];
    _sourceClientId = json[i]['SourceClientId'];
    _exhibitorId = json[i]['ExhibitorId'];
    _jobNumber = json[i]['JobNumber'];
    _showName = json[i]['ShowName'];
    _exhibitorName = json[i]['ExhibitorName'];
    _boothNumber = json[i]['BoothNumber'];
    _showCity = json[i]['ShowCity'];
    _showStartDate = json[i]['ShowStartDate'];
    _showEndDate = json[i]['ShowEndDate'];
    _additionalEmail = json[i]['AdditionalEmail'];
    _oasisAdditionalEmail = json[i]['OasisAdditionalEmail'];
    _showNumber = json[i]['ShowNumber'];
    _sourceContactName = json[i]['SourceContactName'];
    _sourceContactMobilePhone = json[i]['SourceContactMobilePhone'];
    _sourceContactEmail = json[i]['SourceContactEmail'];
    _salesRepFirstName = json[i]['SalesRepFirstName'];
    _salesRepLastName = json[i]['SalesRepLastName'];
    _salesRepOfficePhone = json[i]['SalesRepOfficePhone'];
    _salesRepCellPhone = json[i]['SalesRepCellPhone'];
    _salesRepEmailAddress = json[i]['SalesRepEmailAddress'];
    _supervision = json[i]['Supervision'];
    _sourceName = json[i]['SourceName'];
    _takenDateTime = json[i]['TakenDateTime'];
    _createdDateUtc = json[i]['CreatedDateUtc'];
    _createdBy = json[i]['CreatedBy'];

    if (json[i]['JobPhotoDetailsModel'] != null) {
      _jobPhotoDetailsModel = [];
      json[i]['JobPhotoDetailsModel'].forEach((v) {
        _jobPhotoDetailsModel?.add(JobPhotoDetailsModel.fromJson(v));
      });
    }

    _showLocation = json[i]['ShowLocation'];
    _cityOffice = json[i]['CityOffice'];
  }
  num? _jobPhotosId;
  String? _woNumber;
  String? _salesRepId;
  String? _sourceClientId;
  String? _exhibitorId;
  String? _jobNumber;
  String? _showName;
  String? _exhibitorName;
  String? _boothNumber;
  String? _showCity;
  String? _showStartDate;
  String? _showEndDate;
  String? _additionalEmail;
  String? _oasisAdditionalEmail;
  String? _showNumber;
  String? _sourceContactName;
  String? _sourceContactMobilePhone;
  String? _sourceContactEmail;
  String? _salesRepFirstName;
  String? _salesRepLastName;
  String? _salesRepOfficePhone;
  String? _salesRepCellPhone;
  String? _salesRepEmailAddress;
  String? _supervision;
  String? _sourceName;
  String? _takenDateTime;
  String? _createdDateUtc;
  num? _createdBy;
  List<JobPhotoDetailsModel>? _jobPhotoDetailsModel;
  String? _showLocation;
  String? _cityOffice;
JobDetailsResponse copyWith({  num? jobPhotosId,
  String? woNumber,
  String? salesRepId,
  String? sourceClientId,
  String? exhibitorId,
  String? jobNumber,
  String? showName,
  String? exhibitorName,
  String? boothNumber,
  String? showCity,
  String? showStartDate,
  String? showEndDate,
  String? additionalEmail,
  String? oasisAdditionalEmail,
  String?  sNumber,
  String? showNumber,
  String?  sourceContactName,
  String?  sourceContactMobilePhone,
  String?  sourceContactEmail,
  String? salesRepFirstName,
  String? salesRepLastName,
  String?  salesRepOfficePhone,
  String? salesRepCellPhone,
  String? salesRepEmailAddress,
  String? supervision,
  String? sourceName,
  String? takenDateTime,
  String? createdDateUtc,
  num? createdBy,
  List<JobPhotoDetailsModel>? jobPhotoDetailsModel,
  String? showLocation,
  String? cityOffice,
}) => JobDetailsResponse(  jobPhotosId: jobPhotosId ?? _jobPhotosId,
  woNumber: woNumber ?? _woNumber,
  salesRepId: salesRepId ?? _salesRepId,
  sourceClientId: sourceClientId ?? _sourceClientId,
  exhibitorId: exhibitorId ?? _exhibitorId,
  jobNumber: jobNumber ?? _jobNumber,
  showName: showName ?? _showName,
  exhibitorName: exhibitorName ?? _exhibitorName,
  boothNumber: boothNumber ?? _boothNumber,
  showCity: showCity ?? _showCity,
  showStartDate: showStartDate ?? _showStartDate,
  showEndDate: showEndDate ?? _showEndDate,
  additionalEmail: additionalEmail ?? _additionalEmail,
  oasisAdditionalEmail: oasisAdditionalEmail ?? _oasisAdditionalEmail,
  showNumber: showNumber ?? _showNumber,
  sourceContactName: sourceContactName ?? _sourceContactName,
  sourceContactMobilePhone: sourceContactMobilePhone ?? _sourceContactMobilePhone,
  sourceContactEmail: sourceContactEmail ?? _sourceContactEmail,
  salesRepFirstName: salesRepFirstName ?? _salesRepFirstName,
  salesRepLastName: salesRepLastName ?? _salesRepLastName,
  salesRepOfficePhone: salesRepOfficePhone ?? _salesRepOfficePhone,
  salesRepCellPhone: salesRepCellPhone ?? _salesRepCellPhone,
  salesRepEmailAddress: salesRepEmailAddress ?? _salesRepEmailAddress,
  supervision: supervision ?? _supervision,
  sourceName: sourceName ?? _sourceName,
  takenDateTime: takenDateTime ?? _takenDateTime,
  createdDateUtc: createdDateUtc ?? _createdDateUtc,
  createdBy: createdBy ?? _createdBy,

  jobPhotoDetailsModel: jobPhotoDetailsModel ?? _jobPhotoDetailsModel,

  showLocation: showLocation ?? _showLocation,
  cityOffice: cityOffice ?? _cityOffice,
);
  num? get jobPhotosId => _jobPhotosId;
  String? get woNumber => _woNumber;
  String? get salesRepId => _salesRepId;
  String? get sourceClientId => _sourceClientId;
  String? get exhibitorId => _exhibitorId;
  String? get jobNumber => _jobNumber;
  String? get showName => _showName;
  String? get exhibitorName => _exhibitorName;
  String? get boothNumber => _boothNumber;
  String? get showCity => _showCity;
  String? get showStartDate => _showStartDate;
  String? get showEndDate => _showEndDate;
  String? get additionalEmail => _additionalEmail;
  String? get oasisAdditionalEmail => _oasisAdditionalEmail;
  String? get showNumber => _showNumber;
  String?  get sourceContactName => _sourceContactName;
  String?  get sourceContactMobilePhone => _sourceContactMobilePhone;
  String?  get sourceContactEmail => _sourceContactEmail;
  String? get salesRepFirstName => _salesRepFirstName;
  String? get salesRepLastName => _salesRepLastName;
  String?  get salesRepOfficePhone => _salesRepOfficePhone;
  String? get salesRepCellPhone => _salesRepCellPhone;
  String? get salesRepEmailAddress => _salesRepEmailAddress;
  String? get supervision => _supervision;
  String? get sourceName => _sourceName;
  String? get takenDateTime => _takenDateTime;
  String? get createdDateUtc => _createdDateUtc;
  num? get createdBy => _createdBy;
  List<JobPhotoDetailsModel>? get jobPhotoDetailsModel => _jobPhotoDetailsModel;
  String? get showLocation => _showLocation;
  String? get cityOffice => _cityOffice;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['JobPhotosId'] = _jobPhotosId;
    map['WoNumber'] = _woNumber;
    map['SalesRepId'] = _salesRepId;
    map['SourceClientId'] = _sourceClientId;
    map['ExhibitorId'] = _exhibitorId;
    map['JobNumber'] = _jobNumber;
    map['ShowName'] = _showName;
    map['ExhibitorName'] = _exhibitorName;
    map['BoothNumber'] = _boothNumber;
    map['ShowCity'] = _showCity;
    map['ShowStartDate'] = _showStartDate;
    map['ShowEndDate'] = _showEndDate;
    map['AdditionalEmail'] = _additionalEmail;
    map['OasisAdditionalEmail'] = _oasisAdditionalEmail;
    map['ShowNumber'] = _showNumber;
    map['SourceContactName'] = _sourceContactName;
    map['SourceContactMobilePhone'] = _sourceContactMobilePhone;
    map['SourceContactEmail'] = _sourceContactEmail;
    map['SalesRepFirstName'] = _salesRepFirstName;
    map['SalesRepLastName'] = _salesRepLastName;
    map['SalesRepOfficePhone'] = _salesRepOfficePhone;
    map['SalesRepCellPhone'] = _salesRepCellPhone;
    map['SalesRepEmailAddress'] = _salesRepEmailAddress;
    map['Supervision'] = _supervision;
    map['SourceName'] = _sourceName;
    map['TakenDateTime'] = _takenDateTime;
    map['CreatedDateUtc'] = _createdDateUtc;
    map['CreatedBy'] = _createdBy;

    if (_jobPhotoDetailsModel != null) {
      map['JobPhotoDetailsModel'] = _jobPhotoDetailsModel?.map((v) => v.toJson()).toList();
    }


    map['ShowLocation'] = _showLocation;
    map['CityOffice'] = _cityOffice;
    return map;
  }

}

/// JobPhotoDetailsId : 0
/// JobPhotosId : 0
/// TypeValueId : "327309f1-fe5c-48e6-96be-8076fa139215"
/// ImageCount : 6
/// ImageURL : "https://nthdegree2eo.sharepoint.com/:f:/s/Stage-LaborPhotos/Epf5N844CHBIkwCYhDncHdQBcEqdtm0fd_pkmcD-Q_GB-g"
/// CategoryName : "Install\nFreight"
/// IsDNA : false

class JobPhotoDetailsModel {
  JobPhotoDetailsModel({
      num? jobPhotoDetailsId, 
      num? jobPhotosId, 
      String? typeValueId, 
      num? imageCount, 
      String? imageURL, 
      String? categoryName, 
      bool? isDNA,}){
    _jobPhotoDetailsId = jobPhotoDetailsId;
    _jobPhotosId = jobPhotosId;
    _typeValueId = typeValueId;
    _imageCount = imageCount;
    _imageURL = imageURL;
    _categoryName = categoryName;
    _isDNA = isDNA;
}

  JobPhotoDetailsModel.fromJson(dynamic json) {
    _jobPhotoDetailsId = json['JobPhotoDetailsId'];
    _jobPhotosId = json['JobPhotosId'];
    _typeValueId = json['TypeValueId'];
    _imageCount = json['ImageCount'];
    _imageURL = json['ImageURL'];
    _categoryName = json['CategoryName'];
    _isDNA = json['IsDNA'];
  }
  num? _jobPhotoDetailsId;
  num? _jobPhotosId;
  String? _typeValueId;
  num? _imageCount;
  String? _imageURL;
  String? _categoryName;
  bool? _isDNA;
JobPhotoDetailsModel copyWith({  num? jobPhotoDetailsId,
  num? jobPhotosId,
  String? typeValueId,
  num? imageCount,
  String? imageURL,
  String? categoryName,
  bool? isDNA,
}) => JobPhotoDetailsModel(  jobPhotoDetailsId: jobPhotoDetailsId ?? _jobPhotoDetailsId,
  jobPhotosId: jobPhotosId ?? _jobPhotosId,
  typeValueId: typeValueId ?? _typeValueId,
  imageCount: imageCount ?? _imageCount,
  imageURL: imageURL ?? _imageURL,
  categoryName: categoryName ?? _categoryName,
  isDNA: isDNA ?? _isDNA,
);
  num? get jobPhotoDetailsId => _jobPhotoDetailsId;
  num? get jobPhotosId => _jobPhotosId;
  String? get typeValueId => _typeValueId;
  num? get imageCount => _imageCount;
  String? get imageURL => _imageURL;
  String? get categoryName => _categoryName;
  bool? get isDNA => _isDNA;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['JobPhotoDetailsId'] = _jobPhotoDetailsId;
    map['JobPhotosId'] = _jobPhotosId;
    map['TypeValueId'] = _typeValueId;
    map['ImageCount'] = _imageCount;
    map['ImageURL'] = _imageURL;
    map['CategoryName'] = _categoryName;
    map['IsDNA'] = _isDNA;
    return map;
  }

}