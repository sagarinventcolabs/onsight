import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:on_sight_application/repository/database_managers/email_manager.dart';
import 'package:on_sight_application/repository/database_model/email.dart';
import 'package:on_sight_application/repository/web_service_response/project_evaluation_detials_response.dart';
import 'package:on_sight_application/repository/web_services/web_service.dart';
import 'package:on_sight_application/routes/app_pages.dart';
import 'package:on_sight_application/utils/strings.dart';

class ProjectEvaluationController extends GetxController {
  WebService service = WebService();
  RxBool isValidJobNumber = true.obs;
  RxList<Email> emailList = <Email>[].obs;
  RxBool isValidEmail = false.obs;
  RxBool isValidEmailS = false.obs;
  RxInt value = 0.obs;
  RxBool enableButton = false.obs;
  RxList<JobPhotosModel> jobPhotosModellist = <JobPhotosModel>[].obs;

  addEmail(addEmail, jobNumber, onProgress) async {
    EmailManager emailManager = EmailManager();
    Email email = Email();
    email.jobNumber = jobNumber.toString().toUpperCase();
    email.additionalEmail = addEmail;
    email.emailOnProgress = onProgress;
    await emailManager.insertAdditionalEmail(email);
    getEmail(jobNumber.toString().toUpperCase());
    update();
  }

  deleteEmail(index) async {
    EmailManager emailManager = EmailManager();
    Email email = emailList.elementAt(index);
    await emailManager.deleteEmail(
        email.additionalEmail.toString(), email.jobNumber.toString());
    getEmail(email.jobNumber);
    update();
  }

  getEmail(jobNumber) async {
    emailList.clear();
    EmailManager emailManager = EmailManager();
    emailList.value = await emailManager.getEmailRecord(jobNumber.toString().toUpperCase());
    update();
  }

  Future<dynamic> getProjectEvaluationDetails(jobNumber, downloadJobs) async {
    var response = await service.getProjectEvaluationRequest(jobNumber, downloadJobs);
    if (response != null) {
      if (!response.toString().contains(error)) {
        jobPhotosModellist.clear();
        ProjectEvaluationDetialsResponse projectEvaluationDetialsResponse = ProjectEvaluationDetialsResponse.fromJson(response);
        if(projectEvaluationDetialsResponse.jobPhotosModel!=null) {
          for (var element in projectEvaluationDetialsResponse.jobPhotosModel!) {

          if(element.jobNumber.toString().toLowerCase()==jobNumber.toString().toLowerCase()){
            jobPhotosModellist.add(element);
            break;
          }
          }
          await EmailManager().deleteEmailFromAPI(jobNumber.toString().toUpperCase());
          for (var element in jobPhotosModellist) {
            var aditionalEmail = element.additionalEmail;
            if (aditionalEmail != null) {
              List<String> emailL = aditionalEmail.split(",");
              for (var el in emailL) {
                if (el.isNotEmpty) {
                  await addEmail(el, jobNumber, 0);
                }
              }
            }
          }
        }
        Get.toNamed(Routes.projectEvaluationDetailsScreen);
      }
    }
    return response;
  }


  Future<dynamic> getProjectEvaluation(jobNumber, downloadJobs) async {
    var response = await service.getProjectEvaluationRequest(jobNumber, downloadJobs);
    if (response != null) {
      if (!response.toString().contains(error)) {
        jobPhotosModellist.clear();
        ProjectEvaluationDetialsResponse projectEvaluationDetialsResponse = ProjectEvaluationDetialsResponse.fromJson(response);
        if(projectEvaluationDetialsResponse.jobPhotosModel!=null) {
          for (var element in projectEvaluationDetialsResponse.jobPhotosModel!) {
            if(element.jobNumber.toString().toLowerCase()==jobNumber.toString().toLowerCase()){
              jobPhotosModellist.add(element);
              break;
            }
          }
          await EmailManager().deleteEmailFromAPI(jobNumber.toString().toUpperCase());

          for (var element in jobPhotosModellist) {
            var aditionalEmail = element.additionalEmail;
            if (aditionalEmail != null) {
              List<String> emailL = aditionalEmail.split(",");

              for (var el in emailL) {
                if (el.isNotEmpty) {
                  await addEmail(el, jobNumber, 0);
                }
              }
            }
          }
        }
      }
    }
    return response;
  }



  updateIsValid(value) {
    isValidJobNumber.value = value;
    update();
  }

/// Format Date Function.......
  formatTime(input){
    final f = DateFormat('MM/dd/yyyy');
    var result = "";
    try{
      result = f.format(DateTime.parse(input));
    }catch(e){

    }

    return result;
  }
}
