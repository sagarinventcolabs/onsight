import 'dart:io';
import 'package:battery_info/battery_info_plugin.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:launch_review/launch_review.dart';
import 'package:on_sight_application/generated/assets.dart';
import 'package:on_sight_application/repository/database_managers/app_internet_manager.dart';
import 'package:on_sight_application/repository/database_managers/app_update_manager.dart';
import 'package:on_sight_application/repository/database_model/field_issue_image_model.dart';
import 'package:on_sight_application/repository/database_model/image_model.dart';
import 'package:on_sight_application/repository/database_model/image_model_promo_pictures.dart';
import 'package:on_sight_application/repository/database_model/lead_sheet_image_model.dart';
import 'package:on_sight_application/repository/database_model/version_model.dart';
import 'package:on_sight_application/routes/app_pages.dart';
import 'package:on_sight_application/screens/field_issue/view_model/photo_comment_controller.dart';
import 'package:on_sight_application/screens/job_photos/view_model/job_photos_controller.dart';
import 'package:on_sight_application/screens/job_photos/view_model/upload_job_photos_controller.dart';
import 'package:on_sight_application/screens/lead_sheet/view_model/leadsheet_image_controller.dart';
import 'package:on_sight_application/screens/onboarding/model/onboarding_document_image_model.dart';
import 'package:on_sight_application/screens/onboarding/view_model/onboarding_photos_controller.dart';
import 'package:on_sight_application/screens/project_evaluation/view_model/project_evaluation_controller.dart';
import 'package:on_sight_application/screens/project_evaluation/view_model/project_evaluation_install_controller.dart';
import 'package:on_sight_application/screens/promo_pictures/view_model/promo_pictures_controller.dart';
import 'package:on_sight_application/screens/promo_pictures/view_model/upload_promo_pictures_controller.dart';
import 'package:on_sight_application/utils/constants.dart';
import 'package:on_sight_application/utils/dimensions.dart';
import 'package:on_sight_application/utils/shared_preferences.dart';
import 'package:on_sight_application/utils/strings.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path/path.dart';
import 'functions/functions.dart';

showLoader(context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return const WillPopScope(
        onWillPop: _onWillPop,
        child: SizedBox(
          height: 50,
          width: 50,
          child: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(ColourConstants.white),
            ),
          ),
        ),
      );
    },
  );
}

checkBatteryStatus() async {
  AppInternetManager appInternetManager = AppInternetManager();
  var a = await appInternetManager.getSettingsTable();
  debugPrint("Lower One - BatterySaverStatus From Background Service" + a[0][batterySaverStatus].toString());
  if (a[0][batterySaverStatus] == 1) {
    int? batteryLevel;
    if (Platform.isAndroid) {
      debugPrint("-->  Android Battery Level: -->${(await BatteryInfoPlugin().androidBatteryInfo)?.batteryLevel.toString()??""}");
  batteryLevel = (await BatteryInfoPlugin().androidBatteryInfo)?.batteryLevel;
  }else if(Platform.isIOS){
  debugPrint("-->  IOS Battery Level: -->${(await BatteryInfoPlugin().iosBatteryInfo)?.batteryLevel.toString()??""}");
  batteryLevel = (await BatteryInfoPlugin().iosBatteryInfo)?.batteryLevel;
  }
  if ((batteryLevel??100) < 15) {
  Get.closeAllSnackbars();
  Get.showSnackbar(GetSnackBar(title: alert, message: lowBatteryMsg,duration: Duration(seconds: 3),));
  }
}
}


Future<bool> _onWillPop() async {
  return false;
}

internetConnectionDialog(context) {
  Widget okButton = InkWell(
    onTap: () {
      Navigator.pop(context);
    },
    child: Container(
      height: 50,
      width: double.infinity,
      margin: const EdgeInsets.only(top: 25),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: ColourConstants.black,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text(ok, style: TextStyle(fontSize: Dimensions.font20, color: ColourConstants.white)),
      ),
    ),
  );
  Dialog alert = Dialog(
    backgroundColor: ColourConstants.transparent,
    // contentPadding: EdgeInsets.zero,
    insetPadding: EdgeInsets.zero,
    child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 50),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: ColourConstants.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Image.asset(
                Assets.imagesNointernet,
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(height: 20),
            okButton
          ],
        )),
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

defaultDialog(BuildContext context,
    {String? title, Function()? onTap, bool? cancelable}) {
  showDialog(
    context: context,
    barrierDismissible: cancelable ?? true,
    builder: (context) {
      return AlertDialog(
        backgroundColor: ColourConstants.transparent,
        contentPadding: EdgeInsets.zero,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        content: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(
              color: Get.isDarkMode ? ColourConstants.grey700 : ColourConstants.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                title.toString() != "null"
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Text(title.toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: Dimensions.font20,
                                      color: Get.isDarkMode ? ColourConstants.white : ColourConstants.black,
                                      fontWeight: Get.isDarkMode ? FontWeight.w400 : FontWeight.w500))),
                        ],
                      )
                    : const SizedBox(
                        height: 10,
                      ),
                InkWell(
                  onTap: onTap ??
                      () {
                        Get.back();
                      },
                  child: Container(
                      margin: const EdgeInsets.only(top: 25),
                      width: 160,
                      height: 48,
                      decoration: BoxDecoration(
                        color: ColourConstants.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(ok,
                            style: TextStyle(
                                fontSize: Dimensions.font18, color: ColourConstants.white)),
                      )),
                ),
              ],
            )),
      );
    },
  );
}

String? encodeQueryParameters(Map<String, String> params) {
  return params.entries
      .map((MapEntry<String, String> e) =>
  '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
      .join('&');
}

securityDialog(BuildContext context,
    {Function()? onTap, bool? cancelable}) {
  showDialog(
    context: context,
    barrierDismissible: cancelable ?? true,
    builder: (context) {
      return WillPopScope(
        onWillPop: _onWillPop,
        child: AlertDialog(
          backgroundColor: ColourConstants.transparent,
          contentPadding: EdgeInsets.zero,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          content: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                color: Get.isDarkMode ? ColourConstants.grey700 : ColourConstants.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text.rich(
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: Dimensions.font20,
                                color: Get.isDarkMode ? ColourConstants.white : ColourConstants.black,
                                fontWeight: FontWeight.w500),
                          TextSpan(children: [
                            TextSpan(text: rootJailBreakMsg1),
                            TextSpan(text: supportNumber,recognizer: new TapGestureRecognizer()..onTap = ()async{
                              final Uri phoneLaunchUri = Uri(
                                scheme: 'tel',
                                path: supportNumber,
                              );

                              if (!await launchUrl(phoneLaunchUri)) {
                              throw 'Could not launch mobile';
                              }
                            },style: TextStyle(color: ColourConstants.blue)),
                            TextSpan(text: orStr),
                            TextSpan(text: supportEmail,recognizer: new TapGestureRecognizer()..onTap = ()async{
                              final Uri emailLaunchUri = Uri(
                                scheme: mailto,
                                path: supportEmail,
                                query: encodeQueryParameters(<String, String>{
                                  subject: nthDegreeOnSight,
                                }),
                              );
                              if (!await launchUrl(emailLaunchUri)) {
                              throw 'Could not launch email';
                              }
                            },style: TextStyle(color: ColourConstants.blue)),
                            TextSpan(text: rootJailBreakMsg2),
                          ]),
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: onTap ??
                            () {
                          Get.back();
                        },
                    child: Container(
                        margin: const EdgeInsets.only(top: 25),
                        width: 160,
                        height: 48,
                        decoration: BoxDecoration(
                          color: ColourConstants.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(ok,
                              style: TextStyle(
                                  fontSize: Dimensions.font18, color: ColourConstants.white)),
                        )),
                  ),
                ],
              )),
        ),
      );
    },
  );
}

dialogAction(BuildContext context,
    {String? title, String? alert, Function()? onTapYes, Function()? onTapNo}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        backgroundColor: ColourConstants.transparent,
        contentPadding: EdgeInsets.zero,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        content: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(
              color: Get.isDarkMode ? ColourConstants.grey900 : ColourConstants.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                 alert!=null?  Text(alert,textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: Dimensions.font14, fontWeight: FontWeight.normal),):const SizedBox(height: 0,width: 0,),
                const SizedBox(height: 10),
                title != null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Text(title.toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: Dimensions.font18,
                                      fontWeight: FontWeight.w500))),
                        ],
                      )
                    : const SizedBox(
                        height: 10,
                      ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: onTapNo ??
                          () {
                            Get.back();
                          },
                      child: Container(
                          margin: const EdgeInsets.only(top: 25),
                          width: 120,
                          height: 48,
                          decoration: BoxDecoration(
                            color: ColourConstants.unselectContainerColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(No,
                                style: TextStyle(
                                    fontSize: Dimensions.font18,
                                    color: ColourConstants.black)),
                          )),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: onTapYes ??
                          () {
                            Get.back();
                          },
                      child: Container(
                          margin: const EdgeInsets.only(top: 25),
                          width: 120,
                          height: 48,
                          decoration: BoxDecoration(
                            color: ColourConstants.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(Yes,
                                style: TextStyle(
                                    fontSize: Dimensions.font18,
                                    color: ColourConstants.white)),
                          )),
                    ),
                  ],
                )
              ],
            )),
      );
    },
  );
}

optionalUpdateDialogAction(BuildContext context, Version,
    {Function()? onTapYes, Function()? onTapNo}) async{
  AppUpdateManager appUpdateManager = AppUpdateManager();
  VersionDetails versionDetails = await appUpdateManager.getVersionDetails(Version.toString());
  debugPrint(versionDetails.toMap().toString());
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        backgroundColor: ColourConstants.transparent,
        contentPadding: EdgeInsets.zero,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        content: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(
              color: Get.isDarkMode ? ColourConstants.grey900 : ColourConstants.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                Container(height: 90,width: 90,
                   // decoration: BoxDecoration(shape: BoxShape.circle,color: ColourConstants.primary),
                    child: Image.asset(Assets.Connection_lost),
                  ),
                const SizedBox(height: 10),
                Text(appUpdateAvailable,textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: Dimensions.font14, fontWeight: FontWeight.normal),),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                        child: Text(doYouWantToUpdateTheApp,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: Dimensions.font18,
                                fontWeight: FontWeight.w500))),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: onTapNo ??
                              () async{
                            await appUpdateManager.updateStatus(Version, 1);
                            Get.back();
                          },
                      child: Container(
                          margin: const EdgeInsets.only(top: 25),
                          width: 120,
                          height: 48,
                          decoration: BoxDecoration(
                            color: ColourConstants.unselectContainerColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(notNow,
                                style: TextStyle(
                                    fontSize: Dimensions.font17,
                                    color: ColourConstants.black)),
                          )),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: onTapYes ??
                              () async {
                                await appUpdateManager.updateStatus(Version, 2);
                                LaunchReview.launch(androidAppId: packageName,
                                    iOSAppId: iosAppId);
                          },
                      child: Container(
                          margin: const EdgeInsets.only(top: 25),
                          width: 120,
                          height: 48,
                          decoration: BoxDecoration(
                            color: ColourConstants.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(updateStr,
                                style: TextStyle(
                                    fontSize: Dimensions.font17,
                                    color: ColourConstants.white)),
                          )),
                    ),
                  ],
                )
              ],
            )),
      );
    },
  );
}

singleImageDialog({required BuildContext context,required String image}){
  showDialog(context: Get.context!, builder: (ctx){
    return StatefulBuilder(builder: (builderCtx,setState){
      return Scaffold(
        backgroundColor: ColourConstants.black,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(backgroundColor: ColourConstants.primary,elevation: 0, automaticallyImplyLeading: false,  leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: ColourConstants.white,
            size: 25,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        ),
        body: Container(
            width: double.infinity,height: double.infinity,
            child: PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: (BuildContext context, int index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider: FileImage(File(image)),
                  initialScale: PhotoViewComputedScale.contained * 0.8,
                  maxScale: 1.0,
                );
              },
              itemCount: 1,

              loadingBuilder: (context, event) => Center(
                child: Container(
                  width: 20.0,
                  height: 20.0,
                  child: CircularProgressIndicator(),
                ),
              ),
            )
        ),
        bottomNavigationBar: GestureDetector(
          onTap: (){
            Get.back();
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 50,
              margin: EdgeInsets.only(bottom: MediaQuery.of(Get.context!).size.height/24,top: 10),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  color: ColourConstants.primary
              ),
              child: Center(child: Text(cLOSE, style: TextStyle(color: ColourConstants.white, fontWeight: FontWeight.w400, fontSize: Dimensions.font16),)),
            ),
          ),
        ),
      );
    });
  });
}

mandatoryUpdateDialogAction(BuildContext context,Version,
    {Function()? onTap, bool? cancelable}) {
  AppUpdateManager appUpdateManager = AppUpdateManager();

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return WillPopScope(
        onWillPop: _onWillPop,
        child: AlertDialog(
          backgroundColor: ColourConstants.transparent,
          contentPadding: EdgeInsets.zero,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          content: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                color: Get.isDarkMode ? ColourConstants.grey900 : ColourConstants.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  Container(height: 90,width: 90,
                     // decoration: BoxDecoration(shape: BoxShape.circle,color: ColourConstants.primary),
                    child: Image.asset(Assets.app_update_icon),),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Text(appUpdateAvailable,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: Dimensions.font20,
                                  fontWeight: FontWeight.w400))),
                    ],
                  ),
                  InkWell(
                    onTap: onTap ??
                            () async {
                              await appUpdateManager.updateStatus(Version, 2);
                              LaunchReview.launch(androidAppId: packageName,
                                  iOSAppId: iosAppId);
                        },
                    child: Container(
                        margin: const EdgeInsets.only(top: 15,right: 22,left: 22),
                        width: double.infinity,
                        height: 48,
                        decoration: BoxDecoration(
                          color: ColourConstants.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(updateNowStr,
                              style: TextStyle(
                                  fontSize: Dimensions.font17, color: ColourConstants.white)),
                        )),
                  ),
                ],
              )),
        ),
      );
    },
  );
}

 Widget bottomSheetWidget(route, id, jobNumber, key) {
  UploadJobPhotosController uploadJobPhotosC;
  if (Get.isRegistered<UploadJobPhotosController>()) {
    uploadJobPhotosC = Get.find<UploadJobPhotosController>();
  } else {
    uploadJobPhotosC = Get.put(UploadJobPhotosController());
  }
  JobPhotosController controller = Get.find<JobPhotosController>();
  var i = controller.categoryList.indexWhere((element) => element.id == id);
  Theme.of(Get.context!) == Brightness.dark;
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: ColourConstants.bottomSheetGrey,
              borderRadius: BorderRadius.circular(25)),
          height: 5,
          width: 40,
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(addPhoto,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Get.isDarkMode ? ColourConstants.white : ColourConstants.black,
                    fontWeight: Get.isDarkMode ? FontWeight.w300 : FontWeight.w400,
                    fontSize: Dimensions.font18)),
          ],
        ),
        const SizedBox(height: 25),
        Row(
          children: [
            GestureDetector(
                onTap: () async {
                  AnalyticsFireEvent(CameraOrGallery, input: {
                    CameraOrGallery:Camera,
                  });
                  final ImagePicker picker = ImagePicker();
                  var path = await uploadJobPhotosC.createFolderInAppDocDir(camFolder);
                  final XFile? picImage =
                      // Capture a photo from camera
                      await picker.pickImage(source: ImageSource.camera,imageQuality: imageQualityRatio);

                  if (picImage != null) {
                    File file = File(picImage.path);
                    String fileName = "${basename(picImage.path).split(".").first}${DateTime.now().millisecondsSinceEpoch}.jpg";
                    File newFile = await file.copy(path + fileName);

                    ImageModel imageModel = ImageModel(
                        imagePath: newFile.path,
                        imageName: fileName,
                        isPhotoAdded: 0,
                        jobNumber: jobNumber,
                        categoryId: id,
                        categoryName: controller.categoryList[i].name,
                        isSubmitted: 0);

                    uploadJobPhotosC.jobPhotosList.add(imageModel);

                    uploadJobPhotosC.jobPhotosList.refresh();
                    uploadJobPhotosC.enableButton.value = true;
                    uploadJobPhotosC.update();
                  }
                 if (uploadJobPhotosC.jobPhotosList.isEmpty) {
                    Get.back();
                  } else {
                    if (route == Routes.uploadJobPhotosNote) {
                      Get.back();
                    } else {
                      Get.back();
                      Get.toNamed(Routes.uploadJobPhotosNote,
                          arguments: [id, jobNumber, key]);
                    }
                  }
                },
                child: Image.asset(
                  Assets.ic_add_photo,
                  height: 40,
                  width: 40,
                ),
            ),
            const SizedBox(width: 16),
            GestureDetector(
                onTap: () async {
                  List<ImageModel> localList = [];
                  AnalyticsFireEvent(CameraOrGallery, input: {
                    CameraOrGallery:Gallery,
                  });
                  final ImagePicker picker = ImagePicker();
                  // Capture a photo from gallery
                  final List<XFile>? picImage = await picker.pickMultiImage(imageQuality: imageQualityRatio);
                  if (picImage != null) {
                    if (picImage.isNotEmpty) {
                      for (var element in picImage) {
                        File file = File(element.path);
                        String fileName = basename(element.path);
                        ImageModel imageModel = ImageModel(
                            imagePath: file.path,
                            imageName: fileName,
                            isPhotoAdded: 0,
                            jobNumber: jobNumber,
                            categoryId: id,
                            categoryName: controller.categoryList[i].name,
                            isSubmitted: 0);
                        localList.add(imageModel);
                        // uploadJobPhotosC.jobPhotosList.add(imageModel);
                        // uploadJobPhotosC.jobPhotosList.refresh();
                        uploadJobPhotosC.enableButton.value = true;
                        uploadJobPhotosC.update();
                      }
                    }
                  }
                  if (localList.isEmpty) {
                    Get.back();
                  }
                  else {
                    if (route == Routes.uploadJobPhotosNote) {
                      int localIndex = 0;
                      Get.back();
                      showDialog(context: Get.context!, builder: (ctx){
                        return StatefulBuilder(builder: (builderCtx,setState){
                          return Scaffold(
                            backgroundColor: ColourConstants.black,
                            resizeToAvoidBottomInset: true,
                            appBar: AppBar(actions: [
                              GestureDetector(onTap: (){
                                Get.back();
                                uploadJobPhotosC.jobPhotosList.addAll(localList);
                              },child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Text(ADD,style: TextStyle(color: ColourConstants.white),),
                                  ),
                                ],
                              ))],
                              backgroundColor: ColourConstants.primary,
                              elevation: 0,
                              automaticallyImplyLeading: false,
                              leading: IconButton(
                                
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                color: ColourConstants.white,
                                size: 25,
                              ),
                              onPressed: () {
                                Get.back();
                              },
                            ),
                            ),
                            body: Container(
                                width: double.infinity,height: double.infinity,
                                child: PhotoViewGallery.builder(
                                  scrollPhysics: const BouncingScrollPhysics(),
                                  builder: (BuildContext context, int index) {
                                    return PhotoViewGalleryPageOptions(
                                      imageProvider: FileImage(File(localList[index].imagePath??"")),
                                      initialScale: PhotoViewComputedScale.contained * 0.8,
                                      maxScale: 1.0,
                                    );
                                  },
                                  itemCount: localList.length,

                                  loadingBuilder: (context, event) => Center(
                                    child: Container(
                                      width: 20.0,
                                      height: 20.0,
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                  // backgroundDecoration: ColourConstants.black,
                                  // pageController: widget.pageController,
                                  onPageChanged: (index){
                                    localIndex = index;
                                  },
                                )
                            ),
                            bottomNavigationBar: GestureDetector(
                              onTap: (){
                                if (localList.length > 1) {
                                  localList.removeAt(localIndex);
                                  setState((){});
                                }else{
                                  localList.removeAt(localIndex);
                                  setState((){});
                                  Get.back();
                                  Get.back();
                                }
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Container(
                                  height: 50,
                                  margin: EdgeInsets.only(bottom: MediaQuery.of(Get.context!).size.height/24,top: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                                      color: ColourConstants.primary
                                  ),
                                  child: Center(child: Text(removeStr, style: TextStyle(color: ColourConstants.white, fontWeight: FontWeight.w400, fontSize: Dimensions.font16),)),
                                ),
                              ),
                            ),
                          );
                        });
                      });
                    }
                    else {
                      int localIndex = 0;
                      Get.back();
                      showDialog(context: Get.context!, builder: (ctx){
                        return StatefulBuilder(builder: (builderCtx,setState){
                          return Scaffold(
                            backgroundColor: ColourConstants.black,
                            resizeToAvoidBottomInset: true,
                            appBar: AppBar(actions: [
                              GestureDetector(onTap: (){
                                Get.back();
                                uploadJobPhotosC.jobPhotosList.addAll(localList);
                                uploadJobPhotosC.jobPhotosList.refresh();
                                uploadJobPhotosC.update();
                                Get.toNamed(Routes.uploadJobPhotosNote,
                                    arguments: [id, jobNumber, key]);
                              },child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Text(ADD,style: TextStyle(color: ColourConstants.white),),
                                  ),
                                ],
                              ))],backgroundColor: ColourConstants.primary,elevation: 0,automaticallyImplyLeading: false,
                              leading: IconButton(
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                color: ColourConstants.white,
                                size: 25,
                              ),
                              onPressed: () {
                                Get.back();
                              },
                            ),
                            ),
                            body: Container(
                                width: double.infinity,height: double.infinity,
                                child: PhotoViewGallery.builder(
                                  scrollPhysics: const BouncingScrollPhysics(),
                                  builder: (BuildContext context, int index) {
                                    return PhotoViewGalleryPageOptions(
                                      imageProvider: FileImage(File(localList[index].imagePath??"")),
                                      initialScale: PhotoViewComputedScale.contained * 0.8,
                                      maxScale: 1.0,
                                    );
                                  },
                                  itemCount: localList.length,

                                  loadingBuilder: (context, event) => Center(
                                    child: Container(
                                      width: 20.0,
                                      height: 20.0,
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                  // backgroundDecoration: ColourConstants.black,
                                  // pageController: widget.pageController,
                                  onPageChanged: (index){
                                    localIndex = index;
                                  },
                                )
                            ),
                            bottomNavigationBar: GestureDetector(
                              onTap: (){
                                if (localList.length > 1) {
                                  localList.removeAt(localIndex);
                                  setState((){});
                                }else{
                                  localList.removeAt(localIndex);
                                  setState((){});
                                  Get.back();
                                }
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Container(
                                  height: 50,
                                  margin: EdgeInsets.only(bottom: MediaQuery.of(Get.context!).size.height/24,top: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                                      color: ColourConstants.primary
                                  ),
                                  child: Center(child: Text(removeStr, style: TextStyle(color: ColourConstants.white, fontWeight: FontWeight.w400, fontSize: Dimensions.font16),)),
                                ),
                              ),
                            ),
                          );
                        });
                      });
                    }
                  }
                },
                child: Image.asset(
                  Assets.ic_gallery,
                  height: 40,
                  width: 40,
                ))
          ],
        ),
        const SizedBox(height: 50),
      ],
    ),
  );
}

 Widget bottomSheetImagePickerFieldIssue(String s) {
  PhotoCommentController controller = Get.find<PhotoCommentController>();
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: ColourConstants.bottomSheetGrey,
              borderRadius: BorderRadius.circular(25)),
          height: 5,
          width: 40,
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(addPhoto,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Get.isDarkMode ? ColourConstants.white :  ColourConstants.black,
                    fontWeight: FontWeight.w400,
                    fontSize: Dimensions.font18),
            ),
          ],
        ),
        const SizedBox(height: 25),
        Row(
          children: [
            GestureDetector(
                onTap: () async {
                  final ImagePicker picker = ImagePicker();

                  var path = await createFolderInAppDocDir(camFolder);
                  final XFile? picImage =
                      // Capture a photo from camera
                      await picker.pickImage(source: ImageSource.camera,imageQuality: imageQualityRatio);

                  if (picImage != null) {
                    File file = File(picImage.path);
                    final bytes = (await file.readAsBytes()).lengthInBytes;
                    final kb = bytes / 1024;
                    final mb = kb / 1024;
                    debugPrint("Size of Image --> "+"${mb.toString()}");
                    String fileName = "${basename(picImage.path).split(".").first}${DateTime.now().millisecondsSinceEpoch}.jpg";
                    File newFile = await file.copy(path + fileName);
                    FieldIssueImageModel model = FieldIssueImageModel();
                    model.imageName = basename(newFile.path);
                    model.imagePath = newFile.path;
                    controller.photoList.add(model);
                    controller.photoList.refresh();
                    controller.enableButton.value = true;
                    controller.update();
                    if(s==add) {
                      Get.back();
                      Get.toNamed(
                          Routes.fieldIssueCategoryScreen, arguments: Photo);
                    }else{
                      Get.back();
                    }
                  }
                },
                child: Image.asset(
                  Assets.ic_add_photo,
                  height: 40,
                  width: 40,
                )),
            const SizedBox(width: 16),
            GestureDetector(
                onTap: () async {
                  int localIndex = 0;
                  List<FieldIssueImageModel> localList = [];
                  final ImagePicker picker = ImagePicker();
                  // Capture a photo from gallery
                  final List<XFile>? picImage = await picker.pickMultiImage(imageQuality: imageQualityRatio);
                  if (picImage != null) {
                    if (picImage.isNotEmpty) {
                      for (var element in picImage) {
                        File file = File(element.path);
                        FieldIssueImageModel model = FieldIssueImageModel();
                        model.imageName = basename(file.path);
                        model.imagePath = file.path;
                        localList.add(model);
                        controller.enableButton.value = true;
                      }
                      if(s==add) {
                        Get.back();
                        showDialog(context: Get.context!, builder: (ctx){
                          return StatefulBuilder(builder: (builderCtx,setState){
                            return Scaffold(
                              backgroundColor: ColourConstants.black,
                              resizeToAvoidBottomInset: true,
                              appBar: AppBar(actions: [
                                GestureDetector(onTap: (){
                                  Get.back();
                                  controller.photoList.addAll(localList);
                                  controller.photoList.refresh();
                                  controller.update();
                                  Get.toNamed(Routes.fieldIssueCategoryScreen, arguments: Photo);
                                },child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Text(ADD,style: TextStyle(color: ColourConstants.white),),
                                    ),
                                   ],
                                  ),
                                 ),
                                ],backgroundColor: ColourConstants.primary,elevation: 0,automaticallyImplyLeading: false,  leading: IconButton(
                                icon: const Icon(
                                  Icons.arrow_back_ios,
                                  color: ColourConstants.white,
                                  size: 25,
                                ),
                                onPressed: () {
                                  Get.back();
                                },
                              ),
                              ),
                              body: Container(
                                  width: double.infinity,height: double.infinity,
                                  child: PhotoViewGallery.builder(
                                    scrollPhysics: const BouncingScrollPhysics(),
                                    builder: (BuildContext context, int index) {
                                      return PhotoViewGalleryPageOptions(
                                        imageProvider: FileImage(File(localList[index].imagePath??"")),
                                        initialScale: PhotoViewComputedScale.contained * 0.8,
                                        maxScale: 1.0,
                                      );
                                    },
                                    itemCount: localList.length,

                                    loadingBuilder: (context, event) => Center(
                                      child: Container(
                                        width: 20.0,
                                        height: 20.0,
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                                    // backgroundDecoration: ColourConstants.black,
                                    // pageController: widget.pageController,
                                    onPageChanged: (index){
                                      localIndex = index;
                                    },
                                  )
                              ),
                              bottomNavigationBar: GestureDetector(
                                onTap: (){
                                  if (localList.length > 1) {
                                    localList.removeAt(localIndex);
                                    setState((){});
                                  }else{
                                    localList.removeAt(localIndex);
                                    setState((){});
                                    Get.back();
                                    // Get.back();
                                  }
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Container(
                                    height: 50,
                                    margin: EdgeInsets.only(bottom: MediaQuery.of(Get.context!).size.height/24,top: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                                        color: ColourConstants.primary
                                    ),
                                    child: Center(child: Text(removeStr, style: TextStyle(color: ColourConstants.white, fontWeight: FontWeight.w400, fontSize: Dimensions.font16),)),
                                  ),
                                ),
                              ),
                            );
                          });
                        });
                      }else{
                        Get.back();
                        showDialog(context: Get.context!, builder: (ctx){
                          return StatefulBuilder(builder: (builderCtx,setState){
                            return Scaffold(
                              backgroundColor: ColourConstants.black,
                              resizeToAvoidBottomInset: true,
                              appBar: AppBar(actions: [
                                GestureDetector(onTap: (){
                                  controller.photoList.addAll(localList);
                                  controller.photoList.refresh();
                                  controller.update();
                                  Get.back();
                                },child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Text(ADD,style: TextStyle(color: ColourConstants.white),),
                                    ),
                                  ],
                                ))],backgroundColor: ColourConstants.primary,elevation: 0,automaticallyImplyLeading: false,  leading: IconButton(
                                icon: const Icon(
                                  Icons.arrow_back_ios,
                                  color: ColourConstants.white,
                                  size: 25,
                                ),
                                onPressed: () {
                                  Get.back();
                                },
                              ),
                              ),
                              body: Container(
                                  width: double.infinity,height: double.infinity,
                                  child: PhotoViewGallery.builder(
                                    scrollPhysics: const BouncingScrollPhysics(),
                                    builder: (BuildContext context, int index) {
                                      return PhotoViewGalleryPageOptions(
                                        imageProvider: FileImage(File(localList[index].imagePath??"")),
                                        initialScale: PhotoViewComputedScale.contained * 0.8,
                                        maxScale: 1.0,
                                      );
                                    },
                                    itemCount: localList.length,

                                    loadingBuilder: (context, event) => Center(
                                      child: Container(
                                        width: 20.0,
                                        height: 20.0,
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                                    onPageChanged: (index){
                                      localIndex = index;
                                    },
                                  )
                              ),
                              bottomNavigationBar: GestureDetector(
                                onTap: (){
                                  if (localList.length > 1) {
                                    localList.removeAt(localIndex);
                                    setState((){});
                                  }else{
                                    localList.removeAt(localIndex);
                                    setState((){});
                                    Get.back();
                                    // Get.back();
                                  }
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Container(
                                    height: 50,
                                    margin: EdgeInsets.only(bottom: MediaQuery.of(Get.context!).size.height/24,top: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                                        color: ColourConstants.primary
                                    ),
                                    child: Center(child: Text(removeStr, style: TextStyle(color: ColourConstants.white, fontWeight: FontWeight.w400, fontSize: Dimensions.font16),)),
                                  ),
                                ),
                              ),
                            );
                          });
                        });
                      }
                    }
                  }

                },
                child: Image.asset(
                  Assets.ic_gallery,
                  height: 40,
                  width: 40,
                ))
          ],
        ),
        const SizedBox(height: 50),
      ],
    ),
  );
}

Widget bottomSheetImagePickerLeadSheet(String route,String id,String s) {
  Theme.of(Get.context!) == Brightness.dark;
  LeadSheetImageController controller ;
  if (Get.isRegistered<LeadSheetImageController>()) {
    controller = Get.find<LeadSheetImageController>();
  } else {
    controller = Get.put(LeadSheetImageController());
  }
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: Theme.of(Get.context!).bottomSheetTheme.backgroundColor,
              borderRadius: BorderRadius.circular(25)),
          height: 5,
          width: 40,
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(addPhoto,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Get.isDarkMode ? ColourConstants.white : ColourConstants.black,
                    fontWeight: Get.isDarkMode ? FontWeight.w300 : FontWeight.w400,

                    fontSize: Dimensions.font18)),
          ],
        ),
        const SizedBox(height: 25),
        Row(
          children: [
            GestureDetector(
                onTap: () async {
                  AnalyticsFireEvent(CameraOrGallery,
                    input: {
                    CameraOrGallery:Camera,
                  });
                  final ImagePicker picker = ImagePicker();

                  var path = await createFolderInAppDocDir(camFolder);
                  final XFile? picImage =
                  // Capture a photo from camera
                  await picker.pickImage(
                      source: ImageSource.camera,
                      imageQuality: imageQualityRatio);

                  if (picImage != null) {
                    File file = File(picImage.path);
                    String fileName = "${basename(picImage.path).split(".").first}${DateTime.now().millisecondsSinceEpoch}.jpg";
                    File newFile = await file.copy(path + fileName);
                    LeadSheetImageModel model = LeadSheetImageModel();
                    model.imageName = fileName;
                    model.imagePath = newFile.path;
                    controller.photoList.add(model);
                    controller.photoList.refresh();
                    controller.enableButton.value = true;
                    controller.update();
                  if (controller.photoList.isEmpty) {
                      Get.back();
                    } else {
                      if (route == Routes.leadSheetPhotosNote) {
                        Get.back();
                      } else {
                        Get.back();
                        Get.toNamed(
                            Routes.leadSheetPhotosNote, arguments: [id,s]);
                      }
                    }
                  }
                },
                child: Image.asset(
                  Assets.ic_add_photo,
                  height: 40,
                  width: 40,
                )),

            const SizedBox(width: 16),
            GestureDetector(
                onTap: () async {
                  List<LeadSheetImageModel> localList = [];
                  AnalyticsFireEvent(CameraOrGallery, input: {
                    CameraOrGallery:Gallery,
                  });
                  final ImagePicker picker = ImagePicker();
                  // Capture a photo from gallery
                  final List<XFile>? picImage = await picker.pickMultiImage(imageQuality: imageQualityRatio);
                  if (picImage != null) {
                    if (picImage.isNotEmpty) {
                      for (var element in picImage) {
                        File file = File(element.path);
                        final bytes = (await file.readAsBytes()).lengthInBytes;
                        final kb = bytes / 1024;
                        final mb = kb / 1024;
                        debugPrint(mb.toString());
                        String fileName = basename(element.path);
                        LeadSheetImageModel model = LeadSheetImageModel();
                        model.imageName = fileName;
                        model.imagePath = file.path;
                        localList.add(model);
                        // controller.photoList.add(model);
                        // controller.photoList.refresh();
                        controller.enableButton.value = true;
                        controller.update();

                      }
                    if (localList.isEmpty) {
                        Get.back();
                      } else {
                        if (route == Routes.leadSheetPhotosNote) {
                          int localIndex = 0;
                          Get.back();
                          showDialog(context: Get.context!, builder: (ctx){
                            return StatefulBuilder(builder: (builderCtx,setState){
                              return Scaffold(
                                backgroundColor: ColourConstants.black,
                                resizeToAvoidBottomInset: true,
                                appBar: AppBar(actions: [
                                  GestureDetector(onTap: (){
                                    Get.back();
                                    controller.photoList.addAll(localList);
                                    controller.photoList.refresh();
                                    controller.update();
                                  },child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(right: 10),
                                        child: Text(ADD,style: TextStyle(color: ColourConstants.white),),
                                      ),
                                    ],
                                  ))],backgroundColor: ColourConstants.primary,elevation: 0,automaticallyImplyLeading: false,  leading: IconButton(
                                  icon: const Icon(
                                    Icons.arrow_back_ios,
                                    color: ColourConstants.white,
                                    size: 25,
                                  ),
                                  onPressed: () {
                                    Get.back();
                                  },
                                ),
                                ),
                                body: Container(
                                    width: double.infinity,height: double.infinity,
                                    child: PhotoViewGallery.builder(
                                      scrollPhysics: const BouncingScrollPhysics(),
                                      builder: (BuildContext context, int index) {
                                        return PhotoViewGalleryPageOptions(
                                          imageProvider: FileImage(File(localList[index].imagePath??"")),
                                          initialScale: PhotoViewComputedScale.contained * 0.8,
                                          maxScale: 1.0,
                                        );
                                      },
                                      itemCount: localList.length,

                                      loadingBuilder: (context, event) => Center(
                                        child: Container(
                                          width: 20.0,
                                          height: 20.0,
                                          child: CircularProgressIndicator(),
                                        ),
                                      ),
                                      // backgroundDecoration: ColourConstants.black,
                                      // pageController: widget.pageController,
                                      onPageChanged: (index){
                                        localIndex = index;
                                      },
                                    )
                                ),
                                bottomNavigationBar: GestureDetector(
                                  onTap: (){
                                    if (localList.length > 1) {
                                      localList.removeAt(localIndex);
                                      setState((){});
                                    }else{
                                      localList.removeAt(localIndex);
                                      setState((){});
                                      Get.back();
                                      // Get.back();
                                    }
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 20),
                                    child: Container(
                                      height: 50,
                                      margin: EdgeInsets.only(bottom: MediaQuery.of(Get.context!).size.height/24,top: 10),
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                                          color: ColourConstants.primary
                                      ),
                                      child: Center(child: Text(removeStr, style: TextStyle(color: ColourConstants.white, fontWeight: FontWeight.w400, fontSize: Dimensions.font16),)),
                                    ),
                                  ),
                                ),
                              );
                            });
                          });
                        }
                        else {
                          int localIndex = 0;
                          Get.back();
                          showDialog(context: Get.context!, builder: (ctx){
                            return StatefulBuilder(builder: (builderCtx,setState){
                              return Scaffold(
                                backgroundColor: ColourConstants.black,
                                resizeToAvoidBottomInset: true,
                                appBar: AppBar(actions: [
                                  GestureDetector(onTap: (){
                                    Get.back();
                                    controller.photoList.addAll(localList);
                                    controller.photoList.refresh();
                                    controller.update();
                                    Get.toNamed(Routes.leadSheetPhotosNote, arguments: [id,s])?.then((value) {});
                                  },child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(right: 10),
                                        child: Text(ADD,style: TextStyle(color: ColourConstants.white),),
                                      ),
                                    ],
                                  ))],backgroundColor: ColourConstants.primary,elevation: 0,automaticallyImplyLeading: false,  leading: IconButton(
                                  icon: const Icon(
                                    Icons.arrow_back_ios,
                                    color: ColourConstants.white,
                                    size: 25,
                                  ),
                                  onPressed: () {
                                    Get.back();
                                  },
                                ),
                                ),
                                body: Container(
                                    width: double.infinity,height: double.infinity,
                                    child: PhotoViewGallery.builder(
                                      scrollPhysics: const BouncingScrollPhysics(),
                                      builder: (BuildContext context, int index) {
                                        return PhotoViewGalleryPageOptions(
                                          imageProvider: FileImage(File(localList[index].imagePath??"")),
                                          initialScale: PhotoViewComputedScale.contained * 0.8,
                                          maxScale: 1.0,
                                        );
                                      },
                                      itemCount: localList.length,

                                      loadingBuilder: (context, event) => Center(
                                        child: Container(
                                          width: 20.0,
                                          height: 20.0,
                                          child: CircularProgressIndicator(),
                                        ),
                                      ),
                                      // backgroundDecoration: ColourConstants.black,
                                      // pageController: widget.pageController,
                                      onPageChanged: (index){
                                        localIndex = index;
                                      },
                                    )
                                ),
                                bottomNavigationBar: GestureDetector(
                                  onTap: (){
                                    if (localList.length > 1) {
                                      localList.removeAt(localIndex);
                                      setState((){});
                                    }else{
                                      localList.removeAt(localIndex);
                                      setState((){});
                                      // Get.back();
                                      Get.back();
                                    }
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 20),
                                    child: Container(
                                      height: 50,
                                      margin: EdgeInsets.only(bottom: MediaQuery.of(Get.context!).size.height/24,top: 10),
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                                          color: ColourConstants.primary
                                      ),
                                      child: Center(child: Text(removeStr, style: TextStyle(color: ColourConstants.white, fontWeight: FontWeight.w400, fontSize: Dimensions.font16),)),
                                    ),
                                  ),
                                ),
                              );
                            });
                          });
                        }
                      }
                    }
                  }

                },
                child: Image.asset(
                  Assets.ic_gallery,
                  height: 40,
                  width: 40,
                ))
          ],
        ),
        const SizedBox(height: 50),
      ],
    ),
  );
}

Widget bottomSheetImagePickerOnBoardingPictures(String route,index) {
  OnBoardingPhotosController controller = Get.find<OnBoardingPhotosController>();
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: ColourConstants.bottomSheetGrey,
            borderRadius: BorderRadius.circular(25)),
          height: 5,
          width: 40,
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(addPhoto,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Get.isDarkMode ? ColourConstants.white : ColourConstants.black,
                    fontWeight: FontWeight.w400,
                    fontSize: Dimensions.font18)),
          ],
        ),
        const SizedBox(height: 25),
        Row(
          children: [
            GestureDetector(
                onTap: () async {
                  final ImagePicker picker = ImagePicker();

                  var path = await createFolderInAppDocDir(camFolder);
                  final XFile? picImage =
                  // Capture a photo from camera
                  await picker.pickImage(source: ImageSource.camera,imageQuality: imageQualityRatio);

                  if (picImage != null) {
                    File file = File(picImage.path);
                    String fileName = "${basename(picImage.path).split(".").first}${DateTime.now().millisecondsSinceEpoch}.jpg";
                    File newFile = await file.copy(path + fileName);
                    OnBoardingDocumentImageModel model = OnBoardingDocumentImageModel();
                    model.imageName = fileName;
                    model.imagePath = newFile.path;
                    controller.imageList[index].image?.add(model);
                    controller.imageList.refresh();
                    debugPrint(controller.imageList[index].image?.length.toString()
                    );
                    controller.enableButton.value = true;
                    controller.update();
                    if (controller.imageList.isEmpty) {
                      Get.back();
                    } else {
                      Get.back();
                      // Get.toNamed(Routes.UploadPromoPictureScreen);
                    }
                  }
                },
                child: Image.asset(
                  Assets.ic_add_photo,
                  height: 40,
                  width: 40,
                )),
            const SizedBox(width: 16),
            GestureDetector(
                onTap: () async {
                  int localIndex = 0;
                  List<OnBoardingDocumentImageModel> localList = [];
                  final ImagePicker picker = ImagePicker();
                  // Capture a photo from gallery
                  final List<XFile>? picImage = await picker.pickMultiImage(imageQuality: imageQualityRatio);
                  if (picImage != null) {
                    if (picImage.isNotEmpty) {
                      for (var element in picImage) {
                        File file = File(element.path);
                        String fileName = basename(element.path);
                        OnBoardingDocumentImageModel model = OnBoardingDocumentImageModel();
                        model.imageName = fileName;
                        model.imagePath = file.path;
                        localList.add(model);
                        // controller.imageList[index].image?.add(model);
                        // controller.imageList.refresh();
                        controller.update();

                      }
                      if (controller.imageList.isEmpty) {
                        Get.back();
                      } else {
                        Get.back();
                        showDialog(context: Get.context!, builder: (ctx){
                          return StatefulBuilder(builder: (builderCtx,setState){
                            return Scaffold(
                              backgroundColor: ColourConstants.black,
                              resizeToAvoidBottomInset: true,
                              appBar: AppBar(actions: [
                                GestureDetector(onTap: (){
                                  controller.imageList[index].image?.addAll(localList);
                                  controller.imageList.refresh();
                                  controller.enableButton.value = true;
                                  controller.update();
                                  Get.back();
                                },child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Text(ADD,style: TextStyle(color: ColourConstants.white),),
                                    ),
                                  ],
                                ))],backgroundColor: ColourConstants.primary,elevation: 0,automaticallyImplyLeading: false,  leading: IconButton(
                                icon: const Icon(
                                  Icons.arrow_back_ios,
                                  color: ColourConstants.white,
                                  size: 25,
                                ),
                                onPressed: () {
                                  Get.back();
                                },
                              ),
                              ),
                              body: Container(
                                  width: double.infinity,height: double.infinity,
                                  child: PhotoViewGallery.builder(
                                    scrollPhysics: const BouncingScrollPhysics(),
                                    builder: (BuildContext context, int index) {
                                      return PhotoViewGalleryPageOptions(
                                        imageProvider: FileImage(File(localList[index].imagePath??"")),
                                        initialScale: PhotoViewComputedScale.contained * 0.8,
                                        maxScale: 1.0,
                                      );
                                    },
                                    itemCount: localList.length,

                                    loadingBuilder: (context, event) => Center(
                                      child: Container(
                                        width: 20.0,
                                        height: 20.0,
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                                    // backgroundDecoration: ColourConstants.black,
                                    // pageController: widget.pageController,
                                    onPageChanged: (index){
                                      localIndex = index;
                                    },
                                  )
                              ),
                              bottomNavigationBar: GestureDetector(
                                onTap: (){
                                  if (localList.length > 1) {
                                    localList.removeAt(localIndex);
                                    setState((){});
                                  }else{
                                    localList.removeAt(localIndex);
                                    setState((){});
                                    Get.back();
                                  }
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Container(
                                    height: 50,
                                    margin: EdgeInsets.only(bottom: MediaQuery.of(Get.context!).size.height/24,top: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                                        color: ColourConstants.primary
                                    ),
                                    child: Center(child: Text(removeStr, style: TextStyle(color: ColourConstants.white, fontWeight: FontWeight.w400, fontSize: Dimensions.font16),)),
                                  ),
                                ),
                              ),
                            );
                          });
                        });
                      }
                    }
                  }

                },
                child: Image.asset(
                  Assets.ic_gallery,
                  height: 40,
                  width: 40,
                ))
          ],
        ),
        const SizedBox(height: 50),
      ],
    ),
  );
}

Widget bottomSheetImagePickerPromoPictures(String route) {
  var firstName = sp?.getString(Preference.FIRST_NAME)??"";
  var lastName = sp?.getString(Preference.LAST_NAME)??"";
  PromoPicturesController controller ;
  UploadPromoPicturesController uploadPromoPicturesController ;
  if (Get.isRegistered<PromoPicturesController>()) {
    controller = Get.find<PromoPicturesController>();
  } else {
    controller = Get.put(PromoPicturesController());
  }

  if(Get.isRegistered<UploadPromoPicturesController>()){
    uploadPromoPicturesController = Get.find<UploadPromoPicturesController>();
  }else{
    uploadPromoPicturesController = Get.put(UploadPromoPicturesController());
  }
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: ColourConstants.bottomSheetGrey,
              borderRadius: BorderRadius.circular(25)),
          height: 5,
          width: 40,
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(addPhoto,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Get.isDarkMode ? Colors.white : ColourConstants.black,
                    fontWeight: Get.isDarkMode ? FontWeight.w300 : FontWeight.w400,
                    fontSize: Dimensions.font18)),
          ],
        ),
        const SizedBox(height: 25),
        Row(
          children: [
            GestureDetector(
                onTap: () async {
                  final ImagePicker picker = ImagePicker();

                  var path = await createFolderInAppDocDir(camFolder);
                  final XFile? picImage =
                  // Capture a photo from camera
                  await picker.pickImage(source: ImageSource.camera);

                  if (picImage != null) {
                    File file = File(picImage.path);
                    String fileName = "${basename(picImage.path).split(".").first}${DateTime.now().millisecondsSinceEpoch}.jpg";
                    File newFile = await file.copy(path + fileName);
                    PromoImageModel model = PromoImageModel();
                    model.imageName = fileName;
                    model.imagePath = newFile.path;
                    model.FullDate = "0001-01-01T00:00:00";
                    model.ShowName = controller.showController.text.toString();
                    model.Year = DateTime.now().year.toString();
                    model.User = firstName + lastName;
                    controller.photoList.add(model);
                    controller.photoList.refresh();
                    controller.enableButton.value = true;
                    controller.update();
                    uploadPromoPicturesController.enableButton.value = true;
                    uploadPromoPicturesController.update();
                    if (controller.photoList.isEmpty) {
                      Get.back();
                    } else {
                      Get.back();
                      Get.toNamed(Routes.UploadPromoPictureScreen);
                    }
                  }
                },
                child: Image.asset(
                  Assets.ic_add_photo,
                  height: 40,
                  width: 40,
                )),
            const SizedBox(width: 16),
            GestureDetector(
                onTap: () async {
                  Get.back();
                  List<PromoImageModel> localList = [];
                  final ImagePicker picker = ImagePicker();
                  // Capture a photo from gallery
                  final List<XFile>? picImage = await picker.pickMultiImage();
                  if (picImage != null) {
                    if (picImage.isNotEmpty) {
                      for (var element in picImage) {
                        File file = File(element.path);
                        String fileName = basename(element.path);
                        PromoImageModel model = PromoImageModel();
                        model.imageName = fileName;
                        model.imagePath = file.path;
                        model.FullDate = "0001-01-01T00:00:00";
                        model.ShowName = controller.showController.text.toString();
                        model.Year = DateTime.now().year.toString();
                        model.User = firstName + lastName;
                        localList.add(model);
                        // controller.photoList.add(model);
                        // controller.photoList.refresh();
                        controller.enableButton.value = true;
                        controller.update();

                      }
                      if (localList.isEmpty) {
                        Get.back();
                      }
                      else {
                        int localIndex = 0;
                        // Get.back();
                        showDialog(context: Get.context!, builder: (ctx){
                          return StatefulBuilder(builder: (builderCtx,setState){
                            return Scaffold(
                              backgroundColor: Colors.black,
                              resizeToAvoidBottomInset: true,
                              appBar: AppBar(actions: [
                                GestureDetector(onTap: (){
                                  Get.back();
                                  controller.enableButton.value = true;
                                  controller.photoList.addAll(localList);
                                  controller.photoList.refresh();
                                  controller.update();
                                  uploadPromoPicturesController.enableButton.value = true;
                                  uploadPromoPicturesController.update();
                                  if (route == Routes.UploadPromoPictureScreen) {
                                    controller.update();
                                  }else{
                                    Get.toNamed(Routes.UploadPromoPictureScreen)?.then((value) {
                                      controller.update();
                                    });
                                  }

                                },child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Text(ADD,style: TextStyle(color: Colors.white),),
                                    ),
                                  ],
                                ))],backgroundColor: ColourConstants.primary,elevation: 0,automaticallyImplyLeading: false,  leading: IconButton(
                                icon: const Icon(
                                  Icons.arrow_back_ios,
                                  color: ColourConstants.white,
                                  size: 25,
                                ),
                                onPressed: () {
                                  Get.back();
                                },
                              ),
                              ),
                              body: Container(
                                  width: double.infinity,height: double.infinity,
                                  child: PhotoViewGallery.builder(
                                    scrollPhysics: const BouncingScrollPhysics(),
                                    builder: (BuildContext context, int index) {
                                      return PhotoViewGalleryPageOptions(
                                        imageProvider: FileImage(File(localList[index].imagePath??"")),
                                        initialScale: PhotoViewComputedScale.contained * 0.8,
                                        maxScale: 1.0,
                                      );
                                    },
                                    itemCount: localList.length,

                                    loadingBuilder: (context, event) => Center(
                                      child: Container(
                                        width: 20.0,
                                        height: 20.0,
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                                    // backgroundDecoration: Colors.black,
                                    // pageController: widget.pageController,
                                    onPageChanged: (index){
                                      localIndex = index;
                                    },
                                  )
                              ),
                              bottomNavigationBar: GestureDetector(
                                onTap: (){
                                  if (localList.length > 1) {
                                    localList.removeAt(localIndex);
                                    setState((){});
                                  }else{
                                    localList.removeAt(localIndex);
                                    setState((){});
                                    Get.back();
                                  }
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Container(
                                    height: 50,
                                    margin: EdgeInsets.only(bottom: MediaQuery.of(Get.context!).size.height/24,top: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                                        color: ColourConstants.primary
                                    ),
                                    child: Center(child: Text(removeStr, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: Dimensions.font16),)),
                                  ),
                                ),
                              ),
                            );
                          });
                        });
                      }
                    }
                  }

                },
                child: Image.asset(
                  Assets.ic_gallery,
                  height: 40,
                  width: 40,
                ))
          ],
        ),
        const SizedBox(height: 50),
      ],
    ),
  );
}

installDismantalChooserDialog(BuildContext context,
    {String? jobNumber,  bool? cancelable}) {
  showDialog(
    context: context,
    barrierDismissible: cancelable ?? false,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        content: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Get.isDarkMode ? Colors.grey.shade900 : Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  flex: 1,
                  child:GestureDetector(
                    onTap: () async {
                      Get.back();
                      ProjectEvaluationController projectEvaluationController = Get
                          .find<ProjectEvaluationController>();
                      await projectEvaluationController
                          .getProjectEvaluation(
                          jobNumber,
                          false);
                      ProjectEvaluationInstallController
                      evaluationInstallController = Get.find<
                          ProjectEvaluationInstallController>();
                      evaluationInstallController
                          .getProjectEvaluationQuestionsDetails(
                          jobNumber.toString(),
                          "Install", route: Routes.jobPhotosDetailsScreen);
                      checkBatteryStatus();
                    },
                    child:  Padding(padding: EdgeInsets.only(top: 22.0, left: 10, bottom: 10),child:  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                            child: Text(install,
                                textAlign: TextAlign.start,
                                style:  TextStyle(
                                    fontSize: Dimensions.font16,
                                    fontWeight: FontWeight.w500))),

                      ],
                    ),),
                  )

                ),
                Divider(),
               Flexible(
                   flex: 1,
                   child: GestureDetector(
                     onTap: () async {
                       Get.back();
                       ProjectEvaluationController projectEvaluationController = Get
                           .find<ProjectEvaluationController>();
                       await projectEvaluationController
                           .getProjectEvaluation(
                           jobNumber,
                           false);
                       ProjectEvaluationInstallController
                       evaluationInstallController = Get.find<
                           ProjectEvaluationInstallController>();
                       evaluationInstallController
                           .getProjectEvaluationQuestionsDetails(
                           jobNumber
                               .toString(),
                           dismantle);
                       checkBatteryStatus();
                     },
                     child:  Padding(padding: EdgeInsets.only(bottom: 22.0, left: 10, top: 10),
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.start,
                         children: [
                           Expanded(
                               child: Text(dismantle,
                                   textAlign: TextAlign.start,
                                   style: TextStyle(
                                       fontSize: Dimensions.font16,
                                       fontWeight: FontWeight.w500))),

                         ],
                       ),),
                   )

               )
              ],
            )),
      );
    },
  );
}


bottomSheetOnboarding(BuildContext context){
  final List<String> documentList = [ID, ssCard, W4, I9, i9Supporting, directDepositForm, directDepositSupporting];


  ScrollController controller = ScrollController();
  String selectedOption = documentType;
  return StatefulBuilder(builder: (context, setState2){
    return Stack(
      children: [
        ListView(
          shrinkWrap: true,
          controller: controller,
          children: [
            Padding(padding: EdgeInsets.all(20.0),child:  Text(addDocument, style: TextStyle(fontSize: Dimensions.font18, fontWeight: FontWeight.w500),),),
            Padding(padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10) ,child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 3),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300,width: 1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: DropdownButton(
                isExpanded: true,
                underline: const SizedBox(),
                hint: Text(selectedOption),
                style: const TextStyle(color: Colors.black),
                onChanged: (newValue) {
                  setState2(() {
                    selectedOption = newValue.toString();
                  });
                },
                items: documentList.map((location) {
                  return DropdownMenuItem(
                    value: location,
                    child: Text(location),
                  );
                }).toList(),
              ),
            ),),
            Padding(
              padding: EdgeInsets.symmetric( vertical: 8),
              child:  Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(10),
                color: ColourConstants.primaryLight,
                child: Padding(
                  padding: EdgeInsets.symmetric( horizontal: 10),
                  child: Text(addPhoto, style: TextStyle(color: Colors.white, fontSize: Dimensions.font14),),),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      GestureDetector(
                          onTap: () async {
                            final ImagePicker picker = ImagePicker();

                            var path = await createFolderInAppDocDir(camFolder);
                            final XFile? picImage =
                            // Capture a photo from camera
                            await picker.pickImage(source: ImageSource.camera,imageQuality: imageQualityRatio);

                            if (picImage != null) {
                              File file = File(picImage.path);
                              String fileName = "${basename(picImage.path).split(".").first}${DateTime.now().millisecondsSinceEpoch}.jpg";
                              File newFile = await file.copy(path + fileName);

                            }
                          },
                          child: Image.asset(
                            Assets.ic_add_photo,
                            height: 40,
                            width: 40,
                          )),
                      const SizedBox(width: 25),
                      GestureDetector(
                          onTap: () async {
                            final ImagePicker picker = ImagePicker();
                            // Capture a photo from gallery
                            final List<XFile>? picImage = await picker.pickMultiImage(imageQuality: imageQualityRatio);
                            if (picImage != null) {
                              if (picImage.isNotEmpty) {
                                for (var element in picImage) {
                                  File file = File(element.path);
                                  String fileName = basename(element.path);


                                }

                              }
                            }

                          },
                          child: Image.asset(
                            Assets.ic_gallery,
                            height: 40,
                            width: 40,
                          ))
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),

            Padding(padding:  EdgeInsets.symmetric( horizontal: 20), child: Divider(thickness: 2,),),

            Padding(
                padding: const EdgeInsets.all(20),
                child: GridView.builder(
                  shrinkWrap: true,
                  controller: controller,
                  itemCount: 4,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4),
                  itemBuilder: (BuildContext context, int index) {
                    return Stack(
                      children: [
                        Padding(
                            padding: const EdgeInsets.all(5.0),
                            child:
                            /*   Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: FileImage(photoCommentController.photoList[index].file!),
                                fit: BoxFit.fill),
                            borderRadius:
                            const BorderRadius.all(Radius.circular(30.0))),
                      ),*/
                            Container(
                              height: 45,
                              width: 45,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(Assets.photoOnlyWithoutCross),
                                      fit: BoxFit.fill),
                                  borderRadius:
                                  const BorderRadius.all(Radius.circular(30.0))),
                            )
                        ),
                        Positioned(
                          right: 25,
                          top: 2,
                          child: GestureDetector(
                            onTap: () async {

                              /*      photoCommentController.photoList.removeAt(index);
                          photoCommentController.photoList.refresh();
                          photoCommentController.update();*/

                            },
                            child: Image.asset(
                              Assets.ic_close,
                              height: 18,
                              width: 18,
                            ),
                          ),
                        )
                      ],
                    );
                  },
                )


            ),


          ],
        ),

        Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: () async {
                 defaultDialog(context, title: documentAddedSuccessfully,
                    onTap: (){
                      Get.back();
                      Get.back();

                    });
            },
            child: Container(
              height: 50,
              margin: const EdgeInsets.only(left: 35, right: 35, bottom: 16),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  color: ColourConstants.primary),
              child: Center(
                  child: Text(
                    addDocument.toUpperCase(),
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontSize: Dimensions.font16),
                  )),
            ),
          ),
        )

      ],
    );
  });
}

showRatingDialog(BuildContext context){
  RateMyApp rateMyApp;
  rateMyApp = RateMyApp(
    preferencesPrefix: 'rateMyApp_',
    minDays: 7,
    minLaunches: 10,
    remindDays: 7,
    remindLaunches: 10,
    // googlePlayIdentifier: 'fr.skyost.example',
    appStoreIdentifier: '1404847786',
  );
  rateMyApp.showStarRateDialog(
    context,
    title: 'Rate this app', // The dialog title.
    barrierDismissible: true,
    message: 'You like this app ? Then take a little bit of your time to leave a rating :', // The dialog message.
    // contentBuilder: (context, defaultContent) => content, // This one allows you to change the default dialog content.
    actionsBuilder: (context, stars) { // Triggered when the user updates the star rating.
      return [ // Return a list of actions (that will be shown at the bottom of the dialog).
        /*        FlatButton(
            child: Text('OK'),

            onPressed: () async {
              debugPrint('Thanks for the ' + (stars == null ? '0' : stars.round().toString()) + ' star(s) !');
              // You can handle the result as you want (for instance if the user puts 1 star then open your contact page, if he puts more then open the store page, etc...).
              // This allows to mimic the behavior of the default "Rate" button. See "Advanced > Broadcasting events" for more information :
              await rateMyApp?.callEvent(RateMyAppEventType.rateButtonPressed);
              Navigator.pop<RateMyAppDialogButton>(context, RateMyAppDialogButton.rate);
            },
          ),*/
      ];
    },
    ignoreNativeDialog: false, // Set to false if you want to show the Apple's native app rating dialog on iOS or Google's native app rating dialog (depends on the current Platform).
    dialogStyle: const DialogStyle( // Custom dialog styles.
      titleAlign: TextAlign.center,
      messageAlign: TextAlign.center,
      messagePadding: EdgeInsets.only(bottom: 20),
    ),
    starRatingOptions: const StarRatingOptions(), // Custom star bar rating options.
    onDismissed: () => rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed), // Called when the user dismissed the dialog (either by taping outside or by pressing the "back" button).
  );
}