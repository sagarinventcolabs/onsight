/// JobPhotosId : 0
/// WoNumber : "W-145666"
/// FutureShowNumber : null
/// SalesRepId : "89"
/// SourceClientId : "18DEAA9C-64DB-EB11-BACB-000D3A186DBE"
/// ExhibitorId : "7FEC2EBA-0827-EC11-B6E5-000D3A579D4C"
/// JobNumber : "W-145666"
/// ShowName : "NYSCC/Society of Cosmetic Chemists 2022"
/// ExhibitorName : "Barentz"
/// BoothNumber : "507"
/// ShowCity : "New York"
/// ShowStartDate : "2022-05-03T09:00:00"
/// ShowEndDate : "2022-05-04T16:00:00"
/// AdditionalEmail : null
/// OasisAdditionalEmail : null
/// SNumber : null
/// ShowNumber : "S-136637"
/// SourceContactName : "Amy Cimpan"
/// SourceContactMobilePhone : "(702)275-3267"
/// SourceContactEmail : "amyc@exhibithappy.com"
/// SalesRepFirstName : "Rich"
/// SalesRepLastName : "Johnson"
/// SalesRepOfficePhone : null
/// SalesRepCellPhone : null
/// SalesRepEmailAddress : "RJohnson@nthdegree.com"
/// Supervision : "Other"
/// SourceName : "Steelhead Productions"
/// TakenDateTime : null
/// UploadDateTime : null
/// CreatedDateUtc : "0001-01-01T00:00:00"
/// CreatedBy : 0
/// ModifiedDateUtc : null
/// ModifiedBy : null
/// JobPhotoDetailsModel : null
/// EvaluationInstallUrl : null
/// EvaluationDismantleUrl : null
/// PhotoFlag : true
/// JobEvalFlag : true
/// ShowLocation : "Jacob K Javits Conv Center"
/// ShowGC : "Freeman Decorating Co"
/// CityOffice : "New York City"

class GetJobDetails {
  GetJobDetails({
      num? jobPhotosId, 
      String? woNumber,
      String? futureShowNumber,
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
      String? sNumber,
      String? showNumber, 
      String? sourceContactName, 
      String? sourceContactMobilePhone, 
      String? sourceContactEmail, 
      String? salesRepFirstName, 
      String? salesRepLastName,
    String? salesRepOfficePhone,
    String? salesRepCellPhone,
      String? salesRepEmailAddress, 
      String? supervision, 
      String? sourceName,
    String? takenDateTime,
    String? uploadDateTime,
      String? createdDateUtc, 
      num? createdBy,
    String? modifiedDateUtc,
    String? modifiedBy,
      bool? photoFlag, 
      bool? jobEvalFlag, 
      String? showLocation, 
      String? showGC, 
      String? cityOffice,}){
    _jobPhotosId = jobPhotosId;
    _woNumber = woNumber;
    _futureShowNumber = futureShowNumber;
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
    _sNumber = sNumber;
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
    _uploadDateTime = uploadDateTime;
    _createdDateUtc = createdDateUtc;
    _createdBy = createdBy;
    _modifiedDateUtc = modifiedDateUtc;
    _modifiedBy = modifiedBy;
    _photoFlag = photoFlag;
    _jobEvalFlag = jobEvalFlag;
    _showLocation = showLocation;
    _showGC = showGC;
    _cityOffice = cityOffice;
}

  GetJobDetails.fromJson(dynamic json, i) {
    _jobPhotosId = json[i]['JobPhotosId'];
    _woNumber = json[i]['WoNumber'];
    _futureShowNumber = json[i]['FutureShowNumber'];
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
    _sNumber = json[i]['SNumber'];
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
    _uploadDateTime = json[i]['UploadDateTime'];
    _createdDateUtc = json[i]['CreatedDateUtc'];
    _createdBy = json[i]['CreatedBy'];
    _modifiedDateUtc = json[i]['ModifiedDateUtc'];
    _modifiedBy = json[i]['ModifiedBy'];
    _jobPhotoDetailsModel = json[i]['JobPhotoDetailsModel'];
    _evaluationInstallUrl = json[i]['EvaluationInstallUrl'];
    _evaluationDismantleUrl = json[i]['EvaluationDismantleUrl'];
    _photoFlag = json[i]['PhotoFlag'];
    _jobEvalFlag = json[i]['JobEvalFlag'];
    _showLocation = json[i]['ShowLocation'];
    _showGC = json[i]['ShowGC'];
    _cityOffice = json[i]['CityOffice'];
  }
  num? _jobPhotosId;
  String? _woNumber;
  dynamic _futureShowNumber;
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
  dynamic _additionalEmail;
  dynamic _oasisAdditionalEmail;
  dynamic _sNumber;
  String? _showNumber;
  String? _sourceContactName;
  String? _sourceContactMobilePhone;
  String? _sourceContactEmail;
  String? _salesRepFirstName;
  String? _salesRepLastName;
  dynamic _salesRepOfficePhone;
  dynamic _salesRepCellPhone;
  String? _salesRepEmailAddress;
  String? _supervision;
  String? _sourceName;
  dynamic _takenDateTime;
  dynamic _uploadDateTime;
  String? _createdDateUtc;
  num? _createdBy;
  dynamic _modifiedDateUtc;
  dynamic _modifiedBy;
  dynamic _jobPhotoDetailsModel;
  dynamic _evaluationInstallUrl;
  dynamic _evaluationDismantleUrl;
  bool? _photoFlag;
  bool? _jobEvalFlag;
  String? _showLocation;
  String? _showGC;
  String? _cityOffice;
GetJobDetails copyWith({  num? jobPhotosId,
  String? woNumber,
  dynamic futureShowNumber,
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
  dynamic additionalEmail,
  dynamic oasisAdditionalEmail,
  dynamic sNumber,
  String? showNumber,
  String? sourceContactName,
  String? sourceContactMobilePhone,
  String? sourceContactEmail,
  String? salesRepFirstName,
  String? salesRepLastName,
  dynamic salesRepOfficePhone,
  dynamic salesRepCellPhone,
  String? salesRepEmailAddress,
  String? supervision,
  String? sourceName,
  dynamic takenDateTime,
  dynamic uploadDateTime,
  String? createdDateUtc,
  num? createdBy,
  dynamic modifiedDateUtc,
  dynamic modifiedBy,
  dynamic jobPhotoDetailsModel,
  dynamic evaluationInstallUrl,
  dynamic evaluationDismantleUrl,
  bool? photoFlag,
  bool? jobEvalFlag,
  String? showLocation,
  String? showGC,
  String? cityOffice,
}) => GetJobDetails(  jobPhotosId: jobPhotosId ?? _jobPhotosId,
  woNumber: woNumber ?? _woNumber,
  futureShowNumber: futureShowNumber ?? _futureShowNumber,
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
  sNumber: sNumber ?? _sNumber,
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
  uploadDateTime: uploadDateTime ?? _uploadDateTime,
  createdDateUtc: createdDateUtc ?? _createdDateUtc,
  createdBy: createdBy ?? _createdBy,
  modifiedDateUtc: modifiedDateUtc ?? _modifiedDateUtc,
  modifiedBy: modifiedBy ?? _modifiedBy,
  photoFlag: photoFlag ?? _photoFlag,
  jobEvalFlag: jobEvalFlag ?? _jobEvalFlag,
  showLocation: showLocation ?? _showLocation,
  showGC: showGC ?? _showGC,
  cityOffice: cityOffice ?? _cityOffice,
);
  num? get jobPhotosId => _jobPhotosId;
  String? get woNumber => _woNumber;
  dynamic get futureShowNumber => _futureShowNumber;
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
  dynamic get additionalEmail => _additionalEmail;
  dynamic get oasisAdditionalEmail => _oasisAdditionalEmail;
  dynamic get sNumber => _sNumber;
  String? get showNumber => _showNumber;
  String? get sourceContactName => _sourceContactName;
  String? get sourceContactMobilePhone => _sourceContactMobilePhone;
  String? get sourceContactEmail => _sourceContactEmail;
  String? get salesRepFirstName => _salesRepFirstName;
  String? get salesRepLastName => _salesRepLastName;
  dynamic get salesRepOfficePhone => _salesRepOfficePhone;
  dynamic get salesRepCellPhone => _salesRepCellPhone;
  String? get salesRepEmailAddress => _salesRepEmailAddress;
  String? get supervision => _supervision;
  String? get sourceName => _sourceName;
  dynamic get takenDateTime => _takenDateTime;
  dynamic get uploadDateTime => _uploadDateTime;
  String? get createdDateUtc => _createdDateUtc;
  num? get createdBy => _createdBy;
  dynamic get modifiedDateUtc => _modifiedDateUtc;
  dynamic get modifiedBy => _modifiedBy;
  bool? get photoFlag => _photoFlag;
  bool? get jobEvalFlag => _jobEvalFlag;
  String? get showLocation => _showLocation;
  String? get showGC => _showGC;
  String? get cityOffice => _cityOffice;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['JobPhotosId'] = _jobPhotosId;
    map['WoNumber'] = _woNumber;
    map['FutureShowNumber'] = _futureShowNumber;
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
    map['SNumber'] = _sNumber;
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
    map['UploadDateTime'] = _uploadDateTime;
    map['CreatedDateUtc'] = _createdDateUtc;
    map['CreatedBy'] = _createdBy;
    map['ModifiedDateUtc'] = _modifiedDateUtc;
    map['ModifiedBy'] = _modifiedBy;
    map['JobPhotoDetailsModel'] = _jobPhotoDetailsModel;
    map['EvaluationInstallUrl'] = _evaluationInstallUrl;
    map['EvaluationDismantleUrl'] = _evaluationDismantleUrl;
    map['PhotoFlag'] = _photoFlag;
    map['JobEvalFlag'] = _jobEvalFlag;
    map['ShowLocation'] = _showLocation;
    map['ShowGC'] = _showGC;
    map['CityOffice'] = _cityOffice;
    return map;
  }

}