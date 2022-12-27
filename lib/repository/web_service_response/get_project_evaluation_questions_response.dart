import 'package:flutter/material.dart';

/// JobID : "S092016"
/// CategoryName : "Install"
/// CategoryRowID : 1
/// Comments : ""
/// QuestionnaireDataList : [{"QuestionID":"951a808f-d28a-413d-af84-48d623e01683","Question":"Was\nfreight on\ntime?","RowID":1,"AnswerType":true,"IsMandatory":true,"DetailsRequiredFor":false,"Answer":null,"Details":null},{"QuestionID":"9aff6dfc-bee1-4de8-9fd5-bbe2ff6f2c21","Question":"Did\nyou have set-up/electrical\ndrawings?","RowID":2,"AnswerType":true,"IsMandatory":true,"DetailsRequiredFor":false,"Answer":null,"Details":null},{"QuestionID":"f88e1cf2-3a92-492d-9d58-3ce2d4d9d4d1","Question":"Were\nthe drawings\ncorrect?","RowID":3,"AnswerType":true,"IsMandatory":true,"DetailsRequiredFor":false,"Answer":null,"Details":null},{"QuestionID":"856c7bcc-c854-4beb-b08c-2cefc53b6153","Question":"Any\nissues with the\ncarpet?","RowID":4,"AnswerType":true,"IsMandatory":true,"DetailsRequiredFor":true,"Answer":null,"Details":null},{"QuestionID":"8ba24e4e-194e-4461-9923-ccf72349ae38","Question":"Any\nissues with the hanging\nsign?","RowID":5,"AnswerType":true,"IsMandatory":true,"DetailsRequiredFor":true,"Answer":null,"Details":null},{"QuestionID":"fff3c4e9-e4b9-43ae-b663-aa0c78d252f3","Question":"Any\ndamages to exhibit\nproperties?","RowID":6,"AnswerType":true,"IsMandatory":true,"DetailsRequiredFor":true,"Answer":null,"Details":null},{"QuestionID":"9951b1d8-a58b-42d8-831a-c45e85dfc2fa","Question":"Were\nall services\nordered?","RowID":7,"AnswerType":true,"IsMandatory":true,"DetailsRequiredFor":false,"Answer":null,"Details":null},{"QuestionID":"6df16566-40af-4e28-afe7-f88591ea1a5f","Question":"Were\nany extra services ordered\non-site?","RowID":8,"AnswerType":true,"IsMandatory":true,"DetailsRequiredFor":true,"Answer":null,"Details":null},{"QuestionID":"36d83ebc-adcd-4c64-9ee5-f8e59e1e0720","Question":"Did\nset up start on\ntime?","RowID":9,"AnswerType":true,"IsMandatory":true,"DetailsRequiredFor":false,"Answer":null,"Details":null},{"QuestionID":"8e6e7aa6-31cd-4f81-8754-940f8cd9e969","Question":"Was\nsource client satisfied with\ninstall?","RowID":10,"AnswerType":true,"IsMandatory":true,"DetailsRequiredFor":false,"Answer":null,"Details":null}]

class GetProjectEvaluationQuestionsResponse {
  GetProjectEvaluationQuestionsResponse({
      String? jobID, 
      String? categoryName, 
      num? categoryRowID, 
      String? comments, 
      List<QuestionnaireDataList>? questionnaireDataList,}){
    _jobID = jobID;
    _categoryName = categoryName;
    _categoryRowID = categoryRowID;
    _comments = comments;
    _questionnaireDataList = questionnaireDataList;
}

  GetProjectEvaluationQuestionsResponse.fromJson(dynamic json) {
    _jobID = json['JobID'];
    _categoryName = json['CategoryName'];
    _categoryRowID = json['CategoryRowID'];
    _comments = json['Comments'];
    if (json['QuestionnaireDataList'] != null) {
      _questionnaireDataList = [];
      json['QuestionnaireDataList'].forEach((v) {
        _questionnaireDataList?.add(QuestionnaireDataList.fromJson(v));
      });
    }
  }

  GetProjectEvaluationQuestionsResponse.saveInDB(dynamic json) {
    _jobID = json['JobID'];
    _categoryName = json['CategoryName'];
    _categoryRowID = json['CategoryRowID'];
    _comments = json['Comments'];
  }
  String? _jobID;
  String? _categoryName;
  num? _categoryRowID;
  String? _comments;
  List<QuestionnaireDataList>? _questionnaireDataList;
GetProjectEvaluationQuestionsResponse copyWith({  String? jobID,
  String? categoryName,
  num? categoryRowID,
  String? comments,
  List<QuestionnaireDataList>? questionnaireDataList,
}) => GetProjectEvaluationQuestionsResponse(  jobID: jobID ?? _jobID,
  categoryName: categoryName ?? _categoryName,
  categoryRowID: categoryRowID ?? _categoryRowID,
  comments: comments ?? _comments,
  questionnaireDataList: questionnaireDataList ?? _questionnaireDataList,
);
  String? get jobID => _jobID;
  String? get categoryName => _categoryName;
  num? get categoryRowID => _categoryRowID;
  String? get comments => _comments;
  List<QuestionnaireDataList>? get questionnaireDataList => _questionnaireDataList;


  set jobID(String? value) {
    _jobID = value;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['JobID'] = _jobID;
    map['CategoryName'] = _categoryName;
    map['CategoryRowID'] = _categoryRowID;
    map['Comments'] = _comments;
    if (_questionnaireDataList != null) {
      map['QuestionnaireDataList'] = _questionnaireDataList?.map((v) => v.toJson()).toList();
    }
    return map;
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map['JobID'] = _jobID;
    map['CategoryName'] = _categoryName;
    map['CategoryRowID'] = _categoryRowID;
    map['Comments'] = _comments;
    return map;
  }

  set categoryName(String? value) {
    _categoryName = value;
  }

  set categoryRowID(num? value) {
    _categoryRowID = value;
  }

  set comments(String? value) {
    _comments = value;
  }

  set questionnaireDataList(List<QuestionnaireDataList>? value) {
    _questionnaireDataList = value;
  }
}

/// QuestionID : "951a808f-d28a-413d-af84-48d623e01683"
/// Question : "Was\nfreight on\ntime?"
/// RowID : 1
/// AnswerType : true
/// IsMandatory : true
/// DetailsRequiredFor : false
/// Answer : null
/// Details : null

class QuestionnaireDataList {
  QuestionnaireDataList({
      String? questionID, 
      String? question, 
      num? rowID, 
      bool? answerType, 
      bool? isMandatory, 
      bool? detailsRequiredFor,
      dynamic answer, 
      dynamic details,
    var selected = -1,
  bool visible = false,
  TextEditingController? explainController,
    bool isListening = false,
    String? categoryName
}){
    _questionID = questionID;
    _question = question;
    _rowID = rowID;
    _answerType = answerType;
    _isMandatory = isMandatory;
    _detailsRequiredFor = detailsRequiredFor;
    _answer = answer;
    _details = details;
    _selected = selected;
    _visible = visible;
    _isListening = isListening;
    _explainController = explainController;
    _categoryName = categoryName;

}

  QuestionnaireDataList.fromJson(dynamic json) {
    _questionID = json['QuestionID'];
    _question = json['Question'];
    _rowID = json['RowID'];
    _answerType = json['AnswerType'];
    _isMandatory = json['IsMandatory'];
    _detailsRequiredFor = json['DetailsRequiredFor'];
    _answer = json['Answer'];
    _details = json['Details'];
    _selected = json['selected']??-1;
    _visible = json['visible']??false;
    _explainController?.text = json['explain']??"";
    _categoryName = json['CategoryName']??"";
  }

  QuestionnaireDataList.fromDatabase(dynamic json) {
    _questionID = json['QuestionID'];
    _question = json['Question'];
    _rowID = json['RowID'];
    _answerType = json['AnswerType']==null?false:json['AnswerType']==1?true:false;
    _isMandatory = json['IsMandatory']==null?false:json['IsMandatory']==1?true:false;
    _detailsRequiredFor =json['DetailsRequiredFor']==null?false:json['DetailsRequiredFor']==1?true:false;
    _answer =json['Answer']==null?false:json['Answer']==1?true:false;
    _details = json['Details'];
    _selected = json['selected']??-1;
    _visible =json['visible']==null?false:json['visible']==1?true:false;
    _explainController?.text = json['explain']??"";
    _categoryName = json['CategoryName']??"";
  }

  String? _questionID;
  String? _question;
  num? _rowID;
  bool? _answerType;
  bool? _isMandatory;
  bool? _detailsRequiredFor;
  dynamic _answer;
  dynamic _details;
  var _selected ;
  bool _visible = false;
  bool _isListening = false;
  TextEditingController? _explainController = TextEditingController(text: "");
  String? _categoryName;
QuestionnaireDataList copyWith({  String? questionID,
  String? question,
  num? rowID,
  bool? answerType,
  bool? isMandatory,
  bool? detailsRequiredFor,
  dynamic answer,
  dynamic details,
  var selected,
}) => QuestionnaireDataList(  questionID: questionID ?? _questionID,
  question: question ?? _question,
  rowID: rowID ?? _rowID,
  answerType: answerType ?? _answerType,
  isMandatory: isMandatory ?? _isMandatory,
  detailsRequiredFor: detailsRequiredFor ?? _detailsRequiredFor,
  answer: answer ?? _answer,
  details: details ?? _details,
);
  String? get questionID => _questionID;
  String? get question => _question;
  num? get rowID => _rowID;
  bool? get answerType => _answerType;
  bool? get isMandatory => _isMandatory;
  bool? get detailsRequiredFor => _detailsRequiredFor;
  dynamic get answer => _answer;
  dynamic get details => _details;
  dynamic get selected => _selected;
  bool get visible => _visible;
  bool get isListening => _isListening;
  TextEditingController? get explainController => _explainController;
  String? get categoryName => _categoryName;

  set selected(value) {
    _selected = value;
  }

  set visible(bool value) {
    _visible = value;
  }
  set answer(dynamic value) {
    _answer = value;
  }

  set details(dynamic value) {
    _details = value;
  }


  set isListening(bool value) {
    _isListening = value;
  }


  set categoryName(String? value) {
    _categoryName = value;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['QuestionID'] = _questionID;
    map['Question'] = _question;
    map['RowID'] = _rowID;
    map['AnswerType'] = _answerType;
    map['IsMandatory'] = _isMandatory;
    map['DetailsRequiredFor'] = _detailsRequiredFor;
    map['Answer'] = _answer;
    map['Details'] = _details;
    map['selected'] = _selected;
    map['visible'] = _visible;
    map['explain'] = _explainController!=null?_explainController!.text.toString():"";
    return map;
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map['QuestionID'] = _questionID;
    map['Question'] = _question;
    map['RowID'] = _rowID;
    map['AnswerType'] = _answerType;
    map['IsMandatory'] = _isMandatory;
    map['DetailsRequiredFor'] = _detailsRequiredFor;
    map['Answer'] = _answer;
    map['Details'] = _details;
    map['selected'] = _selected;
    map['visible'] = _visible;
    map['CategoryName'] = _categoryName;
    return map;
  }
}