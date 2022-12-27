

import 'package:on_sight_application/repository/database_model/email.dart';
import 'package:on_sight_application/repository/web_service_requests/temp.dart';
import 'package:on_sight_application/repository/web_service_response/get_project_evaluation_questions_response.dart';

class RequestModelQuestionarie{

  GetProjectEvaluationQuestionsResponse? categoryDetails;
  dynamic additionalEmail;
  QuestionnaireDocument? document;


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['CategoryDetails'] = categoryDetails!=null?categoryDetails!.toJson():"";
    map['AdditionalEmail'] = additionalEmail;
    map['QuestionnaireDocument'] = document!=null?document!.toJson():"";

    return map;
  }
}

