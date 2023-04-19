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
import 'package:on_sight_application/utils/shared_preferences.dart';
import 'package:on_sight_application/utils/strings.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppUpdateController extends GetxController {
  late PackageInfo packageInfo;

//  String staticAppVersion = "1.0.0";
  // bool isMandatory = false;


  List<ResponseVersion> listVersion = [];
  List<SecurityFlagsModel> listFlags = [];

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

  Future<dynamic> getDashboardItems(isLoading) async {
    String  loginFlag = employee;
    sp?.putString(Preference.USERFLAG, loginFlag);
    var response = await WebService().getSecurityFlags(isLoading);
    if (response != null) {
      if(response.toString().contains(noInternetStr)){
        return ;
      }
      if (!response.toString().toLowerCase().contains(error)) {
        response.forEach((value) async {
          SecurityFlagsModel model = SecurityFlagsModel.fromJson(value);
          await DashboardManager().insertMenu(model);
          listFlags.add(model);

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
  }
}
