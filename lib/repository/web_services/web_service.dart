import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:on_sight_application/repository/api_base_helper.dart';
import 'package:on_sight_application/repository/database_managers/app_internet_manager.dart';
import 'package:on_sight_application/repository/database_managers/email_manager.dart';
import 'package:on_sight_application/repository/database_managers/image_count_manager.dart';
import 'package:on_sight_application/repository/database_managers/image_manager.dart';
import 'package:on_sight_application/repository/database_model/email.dart';
import 'package:on_sight_application/repository/database_model/field_issue_image_model.dart';
import 'package:on_sight_application/repository/database_model/image_count.dart';
import 'package:on_sight_application/repository/database_model/image_model_promo_pictures.dart';
import 'package:on_sight_application/repository/database_model/lead_sheet_image_model.dart';
import 'package:on_sight_application/repository/web_service_requests/register_user_request.dart';
import 'package:on_sight_application/repository/web_service_requests/save_exhibitor_images_request.dart';
import 'package:on_sight_application/repository/web_service_requests/submit_field_issue_request.dart';
import 'package:on_sight_application/repository/web_service_response/job_categories_response.dart';
import 'package:on_sight_application/repository/web_service_response/lead_sheet_response.dart';
import 'package:on_sight_application/screens/job_photos/model/job_key_model.dart';
import 'package:on_sight_application/screens/job_photos/model/notes_model.dart';
import 'package:on_sight_application/screens/lead_sheet/model/notes_model.dart';
import 'package:on_sight_application/screens/onboarding/model/onboarding_document_image_model.dart';
import 'package:on_sight_application/utils/connectivity.dart';
import 'package:on_sight_application/utils/constants.dart';
import 'package:on_sight_application/utils/end_point.dart';
import 'package:on_sight_application/utils/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class WebService {
//Get otp request...........................................................................
  Future<dynamic> getOtp(phoneNumber, selectedContryCode) async {
    Map<String, String> body = {
      'UsernameOrPhone': phoneNumber,
      'CountryCode': selectedContryCode,
      'ClientId': 'Temp'
    };
    var response = await ApiBaseHelper().postApiCall(EndPoint.getOTP, body);

    return response;
  }

  //Get otp request email...........................................................................
  Future<dynamic> getOtpForEmail(email) async {
    var deviceId = await FlutterUdid.udid;

    Map<String, String> body = {
      "EmailAddress":email.toString(),
      "UniqueID":deviceId.toString()
    };
    var response = await ApiBaseHelper().postApiCall(EndPoint.getOTPForEmail, body);

    return response;
  }
//Verify Otp request...........................................................................
  Future<dynamic> verifyOtpRequest(email, code) async {
    var deviceId = await FlutterUdid.udid;
    Map<String, String> body = {
      'OtpVerificationCode': code,
      'ClientId': 'Mobile',
      "EmailAddress":email.toString(),
      "UniqueID":deviceId.toString()
    };
    var response = await ApiBaseHelper().postApiCall(EndPoint.verifyOTP, body);
    return response;
  }

  //Get Profile request...........................................................................
  Future<dynamic> getProfile(showSnackbar) async {
    var response = await ApiBaseHelper().getApiCall(EndPoint.fetchProfile, showSnackbarValue: showSnackbar, isLoading: true);
    return response;
  }

  //Update Profile request...........................................................................
  Future<dynamic> updateProfileRequest(code) async {
    var response = await ApiBaseHelper().postApiCall(EndPoint.updateProfile, code);
    return response;
  }
  Future<dynamic> multipartRequest(code) async{
    var uri = Uri.parse('https://example.com/create');
    var request = http.MultipartRequest('POST', uri)
      ..fields['user'] = 'nweiz@google.com'
      ..files.add(await http.MultipartFile.fromPath(
          'package', 'build/package.tar.gz',
          //contentType: MediaType('application', 'x-tar')
      )
      );
    var response = await request.send();
    if (response.statusCode == 200) log('Uploaded!');
    return response;
  }

//Register user request...........................................................................
  Future<dynamic> registerUser(clientId, firstName, lastName, email) async {
    NewUser newUser = NewUser(firstName: firstName, lastName: lastName, emailAddress: email);
    RegisterUserRequest userRequest = RegisterUserRequest(clientId: clientId, newUser: newUser);
    var response = await ApiBaseHelper()
        .postApiCall(EndPoint.registerUser, userRequest.toJson());
    return response;
  }

//Resend otp request...........................................................................
  Future<dynamic> resendOtpRequest(phoneNumber, selectedContryCode) async {
    Map<String, String> body = {
      'UsernameOrPhone': phoneNumber,
      'CountryCode': selectedContryCode,
      'ClientId': 'Temp'
    };
    var response = await ApiBaseHelper().postApiCall(EndPoint.resendOTP, body);
    return response;
  }


//Get Job detail request...........................................................................
  Future<dynamic> getJobDetailsRequest(jobNumber, downloadJobs, isLoading) async {
    var url = EndPoint.getJobDetails;
    var isDownloadAlljob = EndPointKeys.keyIsDownloadAllJob;
    var url2 = "$url$jobNumber$isDownloadAlljob$downloadJobs";
    var response = await ApiBaseHelper().getApiCall(url2, isLoading: isLoading);
    return response;
  }

//Get Latest Version...........................................................................
  Future<dynamic> getLatestVersionRequest() async {
    var platform = "android";
    if(Platform.isAndroid){
      platform = "android";
    }else{
      platform = "IOS";
    }
    var url = EndPoint.getLatestVersion+platform;
    var response = await ApiBaseHelper().getApiCall(url, isLoading: false);
    return response;
  }



//Get CategoryList request...........................................................................
  Future<dynamic> getCategoryListRequest(isLoading) async {
    var response = await ApiBaseHelper().getApiCall(EndPoint.jobCategories, isLoading: isLoading);
    return response;
  }


  //Multipart request for images...........................................................
  Future<dynamic> submitImages(List<JobCategoriesResponse> list, String jobNumber, List<Email> emailList, token, index, imageIndex) async {

    List<http.MultipartFile> listImage = [];
    final f = DateFormat('MM-dd-yyyy HH:mm:ss');
    var dateTime = f.format(DateTime.now());
    /*
    List<String> myEmailList = [];
    emailList.forEach((element) { myEmailList.add(element.additionalEmail.toString());});*/
    String emailString = (emailList.map((e) => e.additionalEmail??"").toList()).join(",");
    JobKeyModel jobKeyModel = JobKeyModel(
        jobNumber:jobNumber.toString(),
        takenDateTime: dateTime,
        additionalEmail: emailString
    );
    Map<String, String> map = Map();
    map['jobkey'] = jsonEncode(jobKeyModel);

          if(list[index].listPhotos!=null){

              String requestId = Uuid().v4();
              NotesModel notesModel = NotesModel(
                  notes: list[index].listPhotos![imageIndex].imageNote.toString(),
                  categoryName: list[index].listPhotos![imageIndex].categoryName,
                  categoryId: list[index].listPhotos![imageIndex].categoryId,
                  imageTotalCount: list[index].listPhotos!.length.toString(),
                  isEmailRequired: list[index].sendEmail?? true,
                  requestId: requestId,
                  isPromoPictures: list[index].listPhotos![imageIndex].promoFlag==1?true:false
              );
              var tempName = list[index].listPhotos![imageIndex].imageName!.split(".").first;

              map[tempName] = jsonEncode(notesModel);

           /*   File file = File(e.imagePath!);
              var byte = await file.readAsBytes();
              log(byte);
*/
             // listImage.add(http.MultipartFile.fromBytes('FileName', byte,contentType: MediaType.parse('image/jpeg'),filename: e.imagePath!.split("/").last));

              listImage.add(

                  http.MultipartFile(
                  'FileName',
                  File(list[index].listPhotos![imageIndex].imagePath!).readAsBytes().asStream(),
                  File(list[index].listPhotos![imageIndex].imagePath!).lengthSync(),
                      contentType:MediaType.parse('image/jpeg'),
                  filename: list[index].listPhotos![imageIndex].imagePath!.split("/").last),


              );


      }

      log("Map "+map.toString());
          var url = "";
    var a = await AppInternetManager().getSettingsTable() as List;
    if(a.isNotEmpty){
     var flavor = a[0]["Flavor"]??"prod";

     if(flavor=="prod"){
       url = EndPoint.uploadCategory;
     }else{
       url = EndPoint.uploadCategoryStage;
     }
    }
    var response = await ApiBaseHelper().multiPartRequest(url, map, listImage, token);
    if(response!=null){

    }

    return response;
  }


  //Multipart request for images...........................................................
  Future<dynamic> submitImagesFromDatabase(JobCategoriesResponse list, String jobNumber, List<Email> emailList, token ) async {
    List<http.MultipartFile> listImage = [];
    final f = DateFormat('MM-dd-yyyy HH:mm:ss');
    var dateTime = f.format(DateTime.now());
    String emailString = (emailList.map((e) => e.additionalEmail??"").toList()).join(",");
    JobKeyModel jobKeyModel = JobKeyModel(
        jobNumber:jobNumber.toString(),
        takenDateTime: dateTime,
        additionalEmail: emailString
    );
    Map<String, String> map = Map();
    map['jobkey'] = jsonEncode(jobKeyModel);

    if(list.listPhotos!=null){

      String requestId = Uuid().v4();
      ImageCount response = await ImageCountManager().getCountByCategoryName(list.id.toString(), jobNumber);
      var count = list.listPhotos!.length;
      if(response.totalImageCountServer!=null){
        count = response.totalImageCountServer!+list.listPhotos!.length;
      }

      NotesModel notesModel = NotesModel(
          notes: list.listPhotos!.first.imageNote.toString(),
          categoryName: list.listPhotos!.first.categoryName,
          categoryId: list.listPhotos!.first.categoryId,
          imageTotalCount: count.toString(),
          isEmailRequired: list.sendEmail?? true,
          requestId: requestId,
          isPromoPictures: list.listPhotos!.first.promoFlag==1?true:false
      );
      var tempName = list.listPhotos!.first.imageName!.split(".").first;

      map[tempName] = jsonEncode(notesModel);

      /*   File file = File(e.imagePath!);
              var byte = await file.readAsBytes();
              log(byte);
*/
      // listImage.add(http.MultipartFile.fromBytes('FileName', byte,contentType: MediaType.parse('image/jpeg'),filename: e.imagePath!.split("/").last));

      try{
        listImage.add(

          http.MultipartFile(
              'FileName',
              File(list.listPhotos!.first.imagePath!).readAsBytes().asStream(),
              File(list.listPhotos!.first.imagePath!).lengthSync(),
              contentType:MediaType.parse('image/jpeg'),
              filename: list.listPhotos!.first.imagePath!.split("/").last),


        );
      }catch(e){
        ImageManager manager = ImageManager();
        manager.deleteImage(list.listPhotos!.first.imageName!);
      }



    }

    log("Map "+map.toString());
    var url = "";
    var a = await AppInternetManager().getSettingsTable() as List;
    if(a.isNotEmpty){
      var flavor = a[0]["Flavor"]??"prod";
      if(flavor=="prod"){
        url = EndPoint.uploadCategory;
      }else{
        url = EndPoint.uploadCategoryStage;
      }
    }
    var response = await ApiBaseHelper().multiPartRequest(url, map, listImage, token);
    log("response is "+response.toString()+"^^");
    try{
      List<Email> listEmail = await EmailManager().getEmailRecord(jobNumber);
      listEmail.forEach((element) async {
        await EmailManager().updateEmail(element.additionalEmail.toString(), 2);
      });
    }catch(e){

    }

    return response;
  }

  //Get Project Evaluation detail request...........................................................................
  Future<dynamic> getProjectEvaluationRequest(jobNumber, downloadJobs) async {
    var url = EndPoint.projectEvaluationDetails;
    var url2 = "$url?jobNumber=${jobNumber}&isDownloadAllJobs=${downloadJobs}";
    var response = await ApiBaseHelper().getApiCall(url2);
    return response;
  }

  //Get Project Evaluation questions request...........................................................................
  Future<dynamic> getProjectEvaluationQuestions(jobNumber, categoryName) async {
    var url = EndPoint.getEvaluationQuestionaire;
    var url2 = "$url?jobNumber=${jobNumber}&categoryName=${categoryName}";
    var response = await ApiBaseHelper().getApiCall(url2);
    return response;
  }

  //Submit Project Evaluation questions request...........................................................................
  Future<dynamic> submitProjectEvaluationQuestions(body) async {
    var url = EndPoint.saveProjectEvaluation;
    var response = await ApiBaseHelper().postApiCall(url, body);
    return response;
  }

  //Check Project Evaluation exist or not...........................................................................
  Future<dynamic> checkProjectEvaluationQuestions(jobNumber, categoryName) async {
    var url = EndPoint.isProjectEvaluationExists;
    var url2 = "$url?jobNumber=${jobNumber}&categoryName=${categoryName}";
    var response = await ApiBaseHelper().getApiCall(url2);
    return response;
  }

  //Get Lead details request...........................................................................
  Future<dynamic> getLeadSheetDetails(showNumber, isLoading) async {
    var url = EndPoint.getLeadSheetDetails;
    var url2 = url+showNumber;
    var response = await ApiBaseHelper().getApiCall(url2, isLoading: isLoading);
    return response;
  }

  //Get Union Suggestions...........................................................................
  Future<dynamic> getUnionSuggestionsList() async {
    var url = EndPoint.getUnionListEndPoint;
    var response = await ApiBaseHelper().getApiCall(url, isLoading: true);
    return response;
  }

  //Add Exhibitor request...........................................................................
  Future<dynamic> addExhibitor({required Exhibitors model,leadNumber}) async {
    var response = await ApiBaseHelper().postApiCall(((EndPoint.addExhibitor)+leadNumber), model.toJson());
    return response;
  }

  //Update Exhibitor request...........................................................................
  Future<dynamic> updateExhibitor({required Exhibitors model,leadNumber}) async {
    var response = await ApiBaseHelper().postApiCall(((EndPoint.addExhibitor)+leadNumber), model.toJson());
    return response;
  }

  //Multipart request for images...........................................................
  Future<dynamic> submitImagesLeadSheet(SaveExhibitorImagesRequest request, LeadSheetImageModel imageList, token, priority) async {
    List<http.MultipartFile> listImage = [];
    Map<String, String> map = Map();
    NotesModelLeadSheet notesModel = NotesModelLeadSheet();
    notesModel.notes = imageList.imageNote.toString();
    var tempName = imageList.imageName!.split(".").first;
    map[tempName] = jsonEncode(notesModel);
    map[EndPointMessages.leadSheetKey] = jsonEncode(request);
    listImage.add( http.MultipartFile(
        'FileName',
        File(imageList.imagePath!).readAsBytes().asStream(),
        File(imageList.imagePath!).lengthSync(),
        contentType:MediaType.parse('image/jpeg'),
        filename: imageList.imagePath!.split("/").last));

    var response;
    bool isNetActive = await ConnectionStatus.getInstance().checkConnection();
    if(isNetActive) {
      var url = "";
      var a = await AppInternetManager().getSettingsTable() as List;
      if(a.isNotEmpty){
        var flavor = a[0]["Flavor"]??"prod";

        if(flavor=="prod"){
          url = EndPoint.saveLeadSheet+"?IsHighPriorityLead="+priority.toString();

        }else{
          url = EndPoint.saveLeadSheetStage+"?IsHighPriorityLead="+priority.toString();

        }
      }

      response = await ApiBaseHelper().multiPartRequest(
          url, map, listImage, token);
    }else{
      response = "error";
    }

    return response;
  }

  //Get Shop List Request...........................................................................
  Future<dynamic> getShopList() async {
    var response = await ApiBaseHelper().getApiCall(((EndPoint.getShopList)));
    return response;
  }

  //Get Booth Size List Request...........................................................................
  Future<dynamic> getBoothSizeList() async {
    var response = ApiBaseHelper().getApiCall(((EndPoint.getBoothSizeList)),isLoading: false);
    return response;
  }

  //Get Booth Size List Request...........................................................................
  Future<dynamic> getCompaniesList() async {
    var response = await ApiBaseHelper().getApiCall(((EndPoint.getCompaniesList)),isLoading: false);
    return response;
  }


  //Create case with comment...........................................................................
  Future<dynamic> createCaseWithCommentOnly(body) async {
    var url = EndPoint.createCommentCase;
    var response = await ApiBaseHelper().postApiCallFieldIssue(url, body);
    return response;
  }
  //Get Category document type request...........................................................................
  Future<dynamic> getCategoryDocumentType() async {
    var url = EndPoint.getDocumentType;
    var response = await ApiBaseHelper().getApiCall(url);
    return response;
  }

  //Get Job detail request...........................................................................
  Future<dynamic> getDetailsByShowNumber(showNumber, type) async {
    var url = "";
    switch(type){
      case "Show Number":
        url = "${EndPoint.getDetailsByShowNumber}$showNumber";
        break;
      case "Show Name":
        var newShowNumber = showNumber.toString().replaceAll("&", "%26");
        url = "${EndPoint.getDetailsByShowName}$newShowNumber";
        break;
      case "Exhibitor Name":
        var newShowNumber = showNumber.toString().replaceAll("&", "%26");
        url = "${EndPoint.getDetailsByExhibitorName}$newShowNumber";
        break;
    }

    var response = await ApiBaseHelper().getApiCallFieldIssue(url, isLoading: true);
    return response;
  }


  //Multipart request for images for Field Issue...........................................................
  Future<dynamic> submitImagesFieldIssue(
      SubmitFieldIssueRequest request,
      List<FieldIssueImageModel> imageList,
      token) async {

    List<http.MultipartFile> listImage = [];
    Map<String, String> map = Map();
    Map<String, String> mapfinal = Map();
    Map<String, dynamic> map1 = await request.toJson();
    map1.forEach((key, value) {
      map[key] = value.toString();
    });
    mapfinal[EndPointKeys.jobKey] = jsonEncode(map);
    imageList.forEach((element) {
      var tempName = element.imageName.toString().split(".").first;
      Map<String, String> mapp = Map();
      mapp[EndPointKeys.comments] = request.comment.toString();
      mapfinal[tempName] = jsonEncode(mapp);
      listImage.add( http.MultipartFile(
          'FileName',
          File(element.imagePath!).readAsBytes().asStream(),
          File(element.imagePath!).lengthSync(),
          contentType:MediaType.parse('image/jpeg'),
          filename: element.imagePath!.split("/").last));
    });


    var response;
    bool isNetActive = await ConnectionStatus.getInstance().checkConnection();
    if(isNetActive) {
      var url = EndPoint.createCase;
      var a = await AppInternetManager().getSettingsTable() as List;
      if(a.isNotEmpty){
        var flavor = a[0]["Flavor"]??"prod";

        if(flavor=="prod"){
          url = EndPoint.createCase;

        }else{
          url = EndPoint.createCaseStage;

        }
      }
      response = await ApiBaseHelper().multiPartRequest(
          url, mapfinal, listImage, token);
      log(response.toString());
    }else{
      response = "error";
    }

    return response;
  }

  //Multipart request for images for Field Issue...........................................................
  Future<dynamic> submitImagesFieldIssue2(
      SubmitFieldIssueRequest request,
      FieldIssueImageModel imageList,
      token) async {

    List<http.MultipartFile> listImage = [];
    Map<String, String> map = Map();
    Map<String, String> mapfinal = Map();
    Map<String, dynamic> map1 = await request.toJson();
    map1.forEach((key, value) {
      map[key] = value.toString();
    });
    mapfinal[EndPointKeys.jobKey] = jsonEncode(map);

      var tempName = imageList.imageName.toString().split(".").first;
      Map<String, String> mapp = Map();
      mapp[EndPointKeys.comments] = request.comment.toString();
      mapfinal[tempName] = jsonEncode(mapp);
      listImage.add( http.MultipartFile(
          'FileName',
          File(imageList.imagePath!).readAsBytes().asStream(),
          File(imageList.imagePath!).lengthSync(),
          contentType:MediaType.parse('image/jpeg'),
          filename: imageList.imagePath!.split("/").last));



    var response;
    bool isNetActive = await ConnectionStatus.getInstance().checkConnection();
    if(isNetActive) {
      var url = EndPoint.createCase;
      var a = await AppInternetManager().getSettingsTable() as List;
      if(a.isNotEmpty){
        var flavor = a[0]["Flavor"]??"prod";

        if(flavor=="prod"){
          url = EndPoint.createCase;

        }else{
          url = EndPoint.createCaseStage;

        }
      }
      response = await ApiBaseHelper().multiPartRequest(
          url, mapfinal, listImage, token);
      log(response.toString());
    }else{
      response = "error";
    }

    return response;
  }

  //Get Oasis Resources List ...........................................................................
  Future<dynamic> getOasisResourcesService() async {
    var url = EndPoint.oasisResourcesEndPoint;
    var response = await ApiBaseHelper().getApiCall(url);
    return response;
  }

  //Create Resources Onboarding ...........................................................................
  Future<dynamic> createResourceOnboarding(requestBody) async {
    var url = EndPoint.createResourceOnboarding;
    var response = await ApiBaseHelper().postApiCall(url, requestBody);
    return response;
  }



  //Multipart request for images for Field Issue...........................................................
  Future<dynamic> submitImagesOnboarding(
      List<OnBoardingDocumentImageModel> request, catId,resourceId,
      token) async {

    List<http.MultipartFile> listImage = [];
    Map<String, String> mapfinal = Map();

    mapfinal[EndPointKeys.resourceKey] = jsonEncode(resourceId);
    request.forEach((element) {
      var tempName = element.imageName.toString().split(".").first;
      mapfinal[tempName] = jsonEncode(catId);
      listImage.add( http.MultipartFile(
          'FileName',
          File(element.imagePath!).readAsBytes().asStream(),
          File(element.imagePath!).lengthSync(),
          contentType:MediaType.parse('image/jpeg'),
          filename: element.imagePath!.split("/").last));
    });


    var response;
    bool isNetActive = await ConnectionStatus.getInstance().checkConnection();
    if(isNetActive) {
      var url = EndPoint.uploadDocument;
      var a = await AppInternetManager().getSettingsTable() as List;
      if(a.isNotEmpty){
        var flavor = a[0]["Flavor"]??"prod";

        if(flavor=="prod"){
          url = EndPoint.uploadDocument;

        }else{
          url = EndPoint.uploadDocumentStage;

        }
      }
      response = await ApiBaseHelper().multiPartRequest(
          url, mapfinal, listImage, token);
      log(response.toString());
    }else{
      response = "error";
    }

    return response;
  }

  //Multipart request for images for Promo pictures...........................................................
  Future<dynamic> submitImagesPromoPictures(
      List<PromoImageModel> request,
      token) async {

    List<http.MultipartFile> listImage = [];
    Map<String, String> mapfinal = Map();
    mapfinal[EndPointKeys.promoKey] = jsonEncode(request.first);
    request.forEach((element) {
      var tempName = element.imageName.toString().split(".").first;
      mapfinal[tempName] = jsonEncode(element.imageNote);
      listImage.add( http.MultipartFile(
          'FileName',
          File(element.imagePath!).readAsBytes().asStream(),
          File(element.imagePath!).lengthSync(),
          contentType:MediaType.parse('image/jpeg'),
          filename: element.imagePath!.split("/").last));
    });

    var response;
    bool isNetActive = await ConnectionStatus.getInstance().checkConnection();
    if(isNetActive) {
      var url = EndPoint.addPromoPictures;
      var a = await AppInternetManager().getSettingsTable() as List;
      if(a.isNotEmpty){
        var flavor = a[0]["Flavor"]??"prod";

        if(flavor=="prod"){
          url = EndPoint.addPromoPictures;
        }else{
          url = EndPoint.addPromoPicturesStage;
        }
      }
      response = await ApiBaseHelper().multiPartRequestPromopictures(
          url, mapfinal, listImage, token);
      log(response.toString());
    }else{
      response = "No Internet";
    }

    return response;
  }

  //Delete User request...........................................................................
  Future<dynamic> deleteUserRequest(username, code) async {
   // var response = await ApiBaseHelper().postApiCall(EndPoint.disableUser, body);
    var email  = username.toString().replaceAll("+", "%2B");
    var response = await ApiBaseHelper().deleteMethod(EndPoint.deleteUser+email);
    return response;
  }


  //Get Security Flags...........................................................................
  Future<dynamic> getSecurityFlags(loading) async {
    var email = sp?.getString(Preference.USER_EMAIL)??"";
    var url = EndPoint.getSecurityFlags/*+email.toString().replaceAll("+", "%2B")*/;
    var deviceId = await FlutterUdid.udid;

    Map<String, String> body = {
      "EmailAddress":email.toString(),
      "UniqueID":deviceId
    };
    var response = await ApiBaseHelper().postApiCallLoader(url, body, isLoading: loading);
    return response;
  }


  //Get Security Flags...........................................................................
  Future<dynamic> checkSSNValidate(ssn) async {
    var url = EndPoint.ssnValidateBy+ssn;
    var response = await ApiBaseHelper().getApiCall(url, isLoading: true);
    return response;
  }
}
