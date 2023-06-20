import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:on_sight_application/generated/assets.dart';
import 'package:on_sight_application/repository/database_managers/dashboard_manager.dart';
import 'package:on_sight_application/repository/database_managers/email_manager.dart';
import 'package:on_sight_application/repository/database_managers/image_count_manager.dart';
import 'package:on_sight_application/repository/database_managers/image_manager.dart';
import 'package:on_sight_application/repository/database_model/email.dart';
import 'package:on_sight_application/repository/database_model/image_count.dart';
import 'package:on_sight_application/repository/web_service_response/job_categories_response.dart';
import 'package:on_sight_application/repository/web_service_response/job_details_response.dart';
import 'package:on_sight_application/repository/web_services/web_service.dart';
import 'package:on_sight_application/routes/app_pages.dart';
import 'package:on_sight_application/screens/project_evaluation/view_model/project_evaluation_controller.dart';
import 'package:on_sight_application/utils/strings.dart';
import 'package:on_sight_application/utils/widgets/jobphoto_grid_container.dart';


class JobPhotosController extends GetxController{

  /// Webservice Instance to call API Functions
  WebService service = WebService();
  /// Category List Variable
  RxList<JobCategoriesResponse> categoryList = <JobCategoriesResponse>[].obs;
  /// Is Valid Job Number Variable
  RxBool isValidJobNumber= true.obs;
  /// Email List Variable
  RxList<Email> emailList = <Email>[].obs;
  /// Email Validation variable to check email is valid or not
  RxBool isValidEmail = true.obs;
  RxBool isValidEmailS = false.obs;
  RxBool emailButton = false.obs;
  /// variable to enable or disable submit button
  RxBool enableButton = false.obs;
  /// variable for suggestion box controller
  Rx<SuggestionsBoxController> suggestionsBoxController =  SuggestionsBoxController().obs;
  /// variable for show hide suggestion below text field of job number
  RxInt value = 0.obs;
  /// variable for job number
  RxString jobNumber2 = "".obs;
  /// Current Tab index
  RxInt tabCurrentIndex = 0.obs;
  RxList<JobDetailsResponse> list = <JobDetailsResponse>[].obs;

  RxBool isVisibleDailyTime = false.obs;
  RxBool isVisibleRankings = false.obs;
  RxBool isVisibleJobPhotos = false.obs;
  RxBool isVisibleEvaluation = false.obs;
  RxBool isVisibleBasicInfo = false.obs;

  @override
  void onInit() {
    super.onInit();
    value.value = 1;
    getVisibility();
    update();

  }

  /// function for adding email in database
  addEmail(emaill, jobNumber, onProgress)async{
    EmailManager emailManager = EmailManager();
    Email email = Email();
    email.jobNumber =jobNumber.toString().toUpperCase();
    email.additionalEmail = emaill;
    email.emailOnProgress = onProgress;
    await emailManager.insertAdditionalEmail(email);
    getEmail(jobNumber);
    update();
  }

/// function for deleting email from database
  deleteEmail(index) async {

    EmailManager emailManager = EmailManager();
    Email email = emailList.elementAt(index);
    await emailManager.deleteEmail(email.additionalEmail.toString(), email.jobNumber.toString());
    getEmail(email.jobNumber.toString().toUpperCase());
    update();
  }

/// function for getting email from database
  getEmail(jobNumber)async{
    emailList.clear();
    EmailManager emailManager = EmailManager();
    emailList.value =  await emailManager.getEmailRecord(jobNumber.toString().toUpperCase());
    update();
  }

  /// API function for getting job detail
  Future<dynamic> getJobDetails(jobNumber, downloadJobs, isLoading, route) async{
    jobNumber2.value = jobNumber.toString();
    update();
    var response = await service.getJobDetailsRequest(jobNumber, downloadJobs, isLoading);
    log(response.toString());
    if(response!=null) {
      if (!response.toString().contains("error") & !response.toString().contains(noInternetStr)) {
        list.clear();
        if (response.length > 0) {
          for (var i = 0; i < response.length; i++) {
            JobDetailsResponse responseModel = JobDetailsResponse.fromJson(
                response, i);
            if (responseModel.jobNumber.toString().toLowerCase() ==
                jobNumber.toString().toLowerCase()) {
              list.add(responseModel);
              break;
            }
          }

          /*        if(categoryList.isNotEmpty){
            categoryList.forEach((element) {
              for (var e in list) {
                if(e.jobNumber==jobNumber){
                  if (e.jobPhotoDetailsModel != null) {

                  }
                }
              }
            });
          }*/
          if (categoryList.isNotEmpty) {
            ImageManager manager = ImageManager();
            ImageCountManager imageCountManager = ImageCountManager();
            for (var element in categoryList) {

              element.listPhotos =
              await manager.getImageByCategoryIdandJobNumber(
                  element.id.toString().trim(),
                  list.first.jobNumber.toString());

              for (var e in list) {
                if (e.jobNumber == jobNumber) {
                  if (e.jobPhotoDetailsModel != null) {
                    for (var i in e.jobPhotoDetailsModel!) {
                      if (i.categoryName.toString() ==
                          element.name.toString()) {
                        element.submitted = i.imageCount;
                        element.url = i.imageURL;
                        //  responseModel.submitted = i.imageCount;
                        // responseModel.url = i.imageURL;
                        // categoryManager.updateCategory(responseModel);
                        ImageCount countModel = ImageCount();
                        countModel.categoryId = element.id;
                        countModel.jobNumber = jobNumber;
                        countModel.imageLink = i.imageURL;
                        countModel.totalImageCountServer = int.parse(i.imageCount.toString());
                        countModel.totalImageCount = 0;
                        imageCountManager.insertImageCount(countModel);
                      } else {

                      }
                    }
                  } else {
                    element.submitted = 0;
                    element.url = "";
                  }
                }
              }
            }
            list.refresh();
            categoryList.refresh();
            update();
          }
          if (route != fromCat){
            await EmailManager().deleteEmailFromAPI(jobNumber.toString().toUpperCase());

            for (var element in list) {
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
    }
      return response;

  }

  /// API Call to get category list
  Future<dynamic> getCategoryList() async{

    var response = await service.getCategoryListRequest(true);


    if(response!=null) {
      if(!response.toString().contains(noInternetStr)){

        if (response.length > 0) {
          if(categoryList.length<response.length){
            categoryList.clear();
            for (var i = 0; i < response.length; i++) {
              JobCategoriesResponse responseModel = JobCategoriesResponse.fromJson(response, i);
              if(responseModel.id=="327309f1-fe5c-48e6-96be-8076fa139215" ||responseModel.id=="5fdc0198-5f6a-4819-bf34-ad0cbfdd6195" ){

                responseModel.sendEmail = false;
              }else{
                responseModel.sendEmail = true;
              }
              categoryList.add(responseModel);
              categoryList.sort((a,b){
                return a.rowId.toString().compareTo(b.rowId.toString());
              });

       /*       CategoryManager categoryManager = CategoryManager();
              responseModel.isChecked = false;
              await categoryManager.insertCategory(responseModel);

              ImageManager manager = ImageManager();

              for (var element in categoryList) {
                element.listPhotos =
                await manager.getImageByCategoryIdandJobNumber(
                    element.id.toString().trim(),
                    list.first.jobNumber.toString());

                for (var e in list) {
                  if (e.jobNumber.toString() == JobNumber.value.toString()){
                    if (e.jobPhotoDetailsModel != null) {
                      for (var i in e.jobPhotoDetailsModel!) {
                        if (i.categoryName.toString() ==
                            element.name.toString()) {

                          element.submitted = i.imageCount;
                          element.url = i.imageURL;
                          responseModel.submitted = i.imageCount;
                          responseModel.url = i.imageURL;
                          categoryManager.updateCategory(responseModel);

                        }
                      }
                    }
                  }
                }
              }
            }
          }else{
            for (var i = 0; i < response.length; i++) {
              JobCategoriesResponse responseModel = JobCategoriesResponse
                  .fromJson(response, i);
              CategoryManager categoryManager = CategoryManager();

              ImageManager manager = ImageManager();

              for (var element in categoryList) {
                print(list.first.jobNumber.toString());
                element.listPhotos =
                await manager.getImageByCategoryIdandJobNumber(
                    element.id.toString().trim(),
                    list.first.jobNumber.toString());

                for (var e in list) {
                  if (e.jobNumber.toString() == JobNumber.toString()) {
                    if (e.jobPhotoDetailsModel != null) {
                      for (var i in e.jobPhotoDetailsModel!) {
                        if (i.categoryName.toString() ==
                            element.name.toString()) {
                          element.submitted = i.imageCount;
                          element.url = i.imageURL;
                          responseModel.submitted = i.imageCount;
                          responseModel.url = i.imageURL;
                          categoryManager.updateCategory(responseModel);
                        }
                      }
                    }
                  }
                }

          }*/
            }

          }
          categoryList.refresh();
        }
      }
    }
    update();
    return response;
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

/*
  Future<dynamic> uploadImages() async{

    var response = await service.submitImages(categoryList.value, JobNumber.value, emailList.value);

    if(response!=null) {

    }
    update();
    return response;
  }
*/

  updateChecked(index, value){
    categoryList[index].isChecked = value;
    categoryList.refresh();
    update();
  }

  updateIsValid(value){
    isValidJobNumber.value = value;
    update();

  }

  updateSendEmailChecked(index, value)async{
    categoryList[index].sendEmail = value;
    ImageManager manager = ImageManager();
    if(value==true){
      await manager.updateSendEmail(1, categoryList[index].id);

    }else{
      await manager.updateSendEmail(0, categoryList[index].id);

    }
    categoryList.refresh();
    update();
  }

  void getVisibility() async{
    isVisibleDailyTime.value = await DashboardManager().getMenuVisibility(dailyTime)==0?false:true;
    isVisibleRankings.value = await DashboardManager().getMenuVisibility(starRanking)==0?false:true;
    isVisibleJobPhotos.value = await DashboardManager().getMenuVisibility(jobPhotos)==0?false:true;
    isVisibleEvaluation.value = await DashboardManager().getMenuVisibility(projectEvaluation)==0?false:true;
    isVisibleBasicInfo.value = await DashboardManager().getMenuVisibility(basicJobInfo)==0?false:true;
  }

  bool getVisibilityTitle(title){
    bool visible = false;
    switch (title){
      case dailyTime:
        visible  =  isVisibleDailyTime.value;
        break;
      case rankings:
        visible  =  isVisibleRankings.value;
        break;
      case jobPhotos:
        visible  =  isVisibleJobPhotos.value;
        break;
      case evaluation:
        visible  =  isVisibleEvaluation.value;
        break;

      default:
        visible = false;


    }
    return visible;
  }

  List<Widget> getWidgetList(){
    List<Widget> list = [];
    if(isVisibleDailyTime.isTrue){
      list.add(JobPhotoGridContainer(title: dailyTime, lightIcon: Assets.daily_time, darkIcon: Assets.daily_time,onTap:(){}));
    }
    if(isVisibleRankings.isTrue){
      list.add(JobPhotoGridContainer(title: rankings, lightIcon: Assets.ranking, darkIcon: Assets.ranking,onTap:(){}));
    }
    if(isVisibleJobPhotos.isTrue){
      list.add(JobPhotoGridContainer(title: jobPhotos, lightIcon: Assets.job_photo, darkIcon: Assets.job_photo,onTap:(){Get.toNamed(Routes.jobPhotoCategoryScreen);}));
    }
    if(isVisibleEvaluation.isTrue){
      list.add(  JobPhotoGridContainer(title: evaluation, lightIcon: Assets.evalution, darkIcon: Assets.evalution,onTap:() async {
        ProjectEvaluationController projectEvaluationController = Get.put(ProjectEvaluationController());
        await projectEvaluationController.getProjectEvaluationDetails(jobNumber2.value, false);


      }
      ));
    }
    print("LenghtWidgetList : ${list.length}");
    return list;
  }


}