/// QuestionnaireDocument : {"JobID":"W-105703","ExhibitorName":"Novartis Pharma Corp - 701 344","ShowName":"KENDRA SCOTT VITRINE ASSESSMENT/PVT","StartDate":"05-22-2018","EndDate":"08-23-2018","ShowCity":"Austin"}

class Temp {
  Temp({
      QuestionnaireDocument? questionnaireDocument,}){
    _questionnaireDocument = questionnaireDocument;
}

  Temp.fromJson(dynamic json) {
    _questionnaireDocument = json['QuestionnaireDocument'] != null ? QuestionnaireDocument.fromJson(json['QuestionnaireDocument']) : null;
  }
  QuestionnaireDocument? _questionnaireDocument;
Temp copyWith({  QuestionnaireDocument? questionnaireDocument,
}) => Temp(  questionnaireDocument: questionnaireDocument ?? _questionnaireDocument,
);
  QuestionnaireDocument? get questionnaireDocument => _questionnaireDocument;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_questionnaireDocument != null) {
      map['QuestionnaireDocument'] = _questionnaireDocument?.toJson();
    }
    return map;
  }

}

/// JobID : "W-105703"
/// ExhibitorName : "Novartis Pharma Corp - 701 344"
/// ShowName : "KENDRA SCOTT VITRINE ASSESSMENT/PVT"
/// StartDate : "05-22-2018"
/// EndDate : "08-23-2018"
/// ShowCity : "Austin"

class QuestionnaireDocument {
  QuestionnaireDocument({
      String? jobID, 
      String? exhibitorName, 
      String? showName, 
      String? startDate, 
      String? endDate, 
      String? showCity,}){
    _jobID = jobID;
    _exhibitorName = exhibitorName;
    _showName = showName;
    _startDate = startDate;
    _endDate = endDate;
    _showCity = showCity;
}


  set jobID(String? value) {
    _jobID = value;
  }

  QuestionnaireDocument.fromJson(dynamic json) {
    _jobID = json['JobID'];
    _exhibitorName = json['ExhibitorName'];
    _showName = json['ShowName'];
    _startDate = json['StartDate'];
    _endDate = json['EndDate'];
    _showCity = json['ShowCity'];
  }
  String? _jobID;
  String? _exhibitorName;
  String? _showName;
  String? _startDate;
  String? _endDate;
  String? _showCity;
QuestionnaireDocument copyWith({  String? jobID,
  String? exhibitorName,
  String? showName,
  String? startDate,
  String? endDate,
  String? showCity,
}) => QuestionnaireDocument(  jobID: jobID ?? _jobID,
  exhibitorName: exhibitorName ?? _exhibitorName,
  showName: showName ?? _showName,
  startDate: startDate ?? _startDate,
  endDate: endDate ?? _endDate,
  showCity: showCity ?? _showCity,
);
  String? get jobID => _jobID;
  String? get exhibitorName => _exhibitorName;
  String? get showName => _showName;
  String? get startDate => _startDate;
  String? get endDate => _endDate;
  String? get showCity => _showCity;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['JobID'] = _jobID;
    map['ExhibitorName'] = _exhibitorName;
    map['ShowName'] = _showName;
    map['StartDate'] = _startDate;
    map['EndDate'] = _endDate;
    map['ShowCity'] = _showCity;
    return map;
  }

  set exhibitorName(String? value) {
    _exhibitorName = value;
  }

  set showName(String? value) {
    _showName = value;
  }

  set startDate(String? value) {
    _startDate = value;
  }

  set endDate(String? value) {
    _endDate = value;
  }

  set showCity(String? value) {
    _showCity = value;
  }
}