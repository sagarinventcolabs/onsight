import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:on_sight_application/repository/database_managers/app_update_manager.dart';
import 'package:on_sight_application/repository/database_model/version_model.dart';
import 'package:on_sight_application/repository/web_services/web_service.dart';
import 'package:on_sight_application/screens/dashboard/model/response_version.dart';
import 'package:on_sight_application/utils/dialogs.dart';
import 'package:on_sight_application/utils/strings.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppUpdateController extends GetxController{

  late PackageInfo packageInfo;
//  String staticAppVersion = "1.0.0";
 // bool isMandatory = false;

  RxBool jobPhotoVisibility = true.obs;
  RxBool projectEevaluationVisibility = true.obs;
  RxBool leadSheetVisibility = true.obs;
  RxBool promoPictureVisibility = true.obs;
  RxBool onboardingVisibility = true.obs;
  RxBool fieldIssueVisibility = true.obs;

  List<ResponseVersion> listVersion = [];

  @override
  void onInit() {
    super.onInit();
   getLatestVersion();
  }

  showUpdateDialog(version, releaseType) async {
    packageInfo = await PackageInfo.fromPlatform();
    debugPrint("App Version - ${packageInfo.version}");
    debugPrint("Api Version - ${version}");
    checkVersion(version,packageInfo.version);

    if(checkVersion(version,packageInfo.version)){
      if(releaseType==(critical.toLowerCase())){
        AppUpdateManager appUpdateManager = AppUpdateManager();
        await appUpdateManager.insertVersion(version.toString(),releaseType.toString() );
        VersionDetails versionDetails = await appUpdateManager.getVersionDetails(version.toString());
        if(versionDetails.updateStatus!=1) {
          mandatoryUpdateDialogAction(Get.context!, version.toString());
        }
      }else{
        AppUpdateManager appUpdateManager = AppUpdateManager();
        await appUpdateManager.insertVersion(version.toString(),releaseType.toString() );
        VersionDetails versionDetails = await appUpdateManager.getVersionDetails(version.toString());
        if(versionDetails.updateStatus!=1) {
          optionalUpdateDialogAction(Get.context!, version.toString());
        }
      }
    }else{
      debugPrint("App Is Up To Date");
    }
  }

  bool checkVersion(String newVersion, String currentVersion){
    List<String> currentV = currentVersion.split(".");
    List<String> newV = newVersion.split(".");

    bool a = false;
    for (var i = 0 ; i <= 2; i++){
      a = int.parse(newV[i]) > int.parse(currentV[i]);
      if(int.parse(newV[i]) != int.parse(currentV[i])) break;
    }
    return a;
  }

  /// API function for getting latest version
  Future<dynamic> getLatestVersion() async {
    var response = await WebService().getLatestVersionRequest();
    if (response != null) {
      if (!response.toString().toLowerCase().contains(error)) {

        if(response.length>0) {
          for (var i = 0; i < response.length; i++) {
            ResponseVersion version = ResponseVersion.fromJson(response, i);
            listVersion.add(version);
          }
        }
        if(listVersion.isNotEmpty)
        showUpdateDialog(listVersion.first.versionNumber.toString(), listVersion.first.releaseType?.toLowerCase());
        return response;
      }
    }
  }

  /// API function for getting security flags
  Future<dynamic> getSecurityFlags() async {
    var response = await WebService().getSecurityFlags();
    if (response != null) {
      if (!response.toString().toLowerCase().contains(error)) {

      }
    }
  }
}