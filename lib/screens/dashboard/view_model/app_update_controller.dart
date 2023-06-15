import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:on_sight_application/repository/database_managers/app_update_manager.dart';
import 'package:on_sight_application/repository/database_managers/dashboard_manager.dart';
import 'package:on_sight_application/repository/database_model/version_model.dart';
import 'package:on_sight_application/repository/web_service_response/security_flags_model.dart';
import 'package:on_sight_application/repository/web_services/web_service.dart';
import 'package:on_sight_application/screens/dashboard/model/response_version.dart';
import 'package:on_sight_application/utils/constants.dart';
import 'package:on_sight_application/utils/dialogs.dart';
import 'package:on_sight_application/utils/functions/functions.dart';
import 'package:on_sight_application/utils/shared_preferences.dart';
import 'package:on_sight_application/utils/strings.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AppUpdateController extends GetxController {
  late PackageInfo packageInfo;
  RefreshController refreshController =
  RefreshController(initialRefresh: true);
//  String staticAppVersion = "1.0.0";
  // bool isMandatory = false;


  List<ResponseVersion> listVersion = [];
  RxList<SecurityFlagsModel> listFlags = <SecurityFlagsModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    getLatestVersion();
  }

  showUpdateDialog(version, releaseType) async {
    packageInfo = await PackageInfo.fromPlatform();
    debugPrint("App Version - ${packageInfo.version}");
    debugPrint("Api Version - ${version}");
    checkVersion(version, packageInfo.version);

    if (checkVersion(version, packageInfo.version)) {
      if (releaseType == (critical.toLowerCase())) {
        AppUpdateManager appUpdateManager = AppUpdateManager();
        await appUpdateManager.insertVersion(
            version.toString(), releaseType.toString());
        VersionDetails versionDetails =
            await appUpdateManager.getVersionDetails(version.toString());
        if (versionDetails.updateStatus != 1) {
          mandatoryUpdateDialogAction(Get.context!, version.toString());
        }
      } else {
        AppUpdateManager appUpdateManager = AppUpdateManager();
        await appUpdateManager.insertVersion(
            version.toString(), releaseType.toString());
        VersionDetails versionDetails =
            await appUpdateManager.getVersionDetails(version.toString());
        if (versionDetails.updateStatus != 1) {
          optionalUpdateDialogAction(Get.context!, version.toString());
        }
      }
    } else {
      debugPrint("App Is Up To Date");
    }
  }

  bool checkVersion(String newVersion, String currentVersion) {
    List<String> currentV = currentVersion.split(".");
    List<String> newV = newVersion.split(".");

    bool a = false;
    for (var i = 0; i <= 2; i++) {
      a = int.parse(newV[i]) > int.parse(currentV[i]);
      if (int.parse(newV[i]) != int.parse(currentV[i])) break;
    }
    return a;
  }

  /// API function for getting latest version
  Future<dynamic> getLatestVersion() async {
    var response = await WebService().getLatestVersionRequest();
    if (response != null) {
      if (!response.toString().toLowerCase().contains(error) && response.toString() != noInternetStr) {
        if (response.length > 0) {
          for (var i = 0; i < response.length; i++) {
            ResponseVersion version = ResponseVersion.fromJson(response, i);
            listVersion.add(version);
          }
        }
        if (listVersion.isNotEmpty)
          showUpdateDialog(listVersion.first.versionNumber.toString(),
              listVersion.first.releaseType?.toLowerCase());
        return response;
      }
    }
  }

  /// API function for getting security flags

  void onRefresh() async{
    // monitor network fetch
    await getDashboardItems(true);
    // if failed,use refreshFailed()
    refreshController.refreshCompleted();
  }









  void onLoading() async{
    // monitor network fetch
    await getDashboardItems(true);
    refreshController.loadComplete();
    update();
  }
  Future<dynamic> getDashboardItems(isLoading) async {


    var response = await WebService().getSecurityFlags(false);
    if (response != null) {
      if(response.toString().contains(noInternetStr)){
        return ;
      }
      if (!response.toString().toLowerCase().contains(error)) {
        listFlags.clear();
        print("Lenght900===> ${listFlags.length}");
        response.forEach((value) async {
          SecurityFlagsModel model = SecurityFlagsModel.fromJson(value);
          print(model.levelFlag);
          sp?.putString(Preference.USERFLAG, model.levelFlag??"");
          await DashboardManager().insertMenu(model);
          listFlags.add(model);
          print("ListLength "+listFlags.length.toString());
          dataStreamController.sink.add([]);
          dataStreamController.sink.add(listFlags);

     /*     switch (model.menuItems) {
            case jobPhotos:
              jobPhotoVisibility.value = model.isAllowed??false;
              update();
              break;
            case projectEvaluation:
              projectEevaluationVisibility.value = model.isAllowed??false;
              update();
              break;
            case leadSheet:
              leadSheetVisibility.value = model.isAllowed??false;
              update();
              break;
            case onboarding:
              onboardingVisibility.value = model.isAllowed??false;
              update();
              break;
            case promoPictures:
              promoPictureVisibility.value = model.isAllowed??false;
              update();
            break;
            case fieldIssues:
              fieldIssueVisibility.value = model.isAllowed??false;
              update();
              break;
          }*/
        });
      }
    }
    refreshController.loadComplete();
  }




  //
  // checkSSL() async {
  //   List<String> listSHA = [];
  //   listSHA.add("38 45 03 EB 3C 83 04 96 C3 4B BB 6A 9B 5A 8A 9B A9 74 45 53");
  //   listSHA.add("B5 D9 DB E6 06 92 2F DC 3F 3B 32 E4 98 28 8C A2 6B 7E 00 69 BF C0 63 2B BB 1A B3 0C C0 05 5A 4A");
  //   String checkSSN = await SslPinningPlugin.check(
  //       serverURL: "https://onsight-stage.nthdegree.com/",
  //       sha: SHA.SHA256,
  //       allowedSHAFingerprints: listSHA,
  //       timeout: 1000);
  //
  //   print("Check SSN  result======> ${checkSSN}");
  // }
}
