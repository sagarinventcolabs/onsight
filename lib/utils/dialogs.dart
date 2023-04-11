import 'dart:io';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:launch_review/launch_review.dart';
import 'package:on_sight_application/generated/assets.dart';
import 'package:on_sight_application/main.dart';
import 'package:on_sight_application/models/image_picker_model.dart';
import 'package:on_sight_application/repository/database_managers/app_internet_manager.dart';
import 'package:on_sight_application/repository/database_managers/app_update_manager.dart';
import 'package:on_sight_application/repository/database_model/version_model.dart';
import 'package:on_sight_application/routes/app_pages.dart';
import 'package:on_sight_application/screens/project_evaluation/view_model/project_evaluation_controller.dart';
import 'package:on_sight_application/screens/project_evaluation/view_model/project_evaluation_install_controller.dart';
import 'package:on_sight_application/utils/constants.dart';
import 'package:on_sight_application/utils/dimensions.dart';
import 'package:on_sight_application/utils/functions/multi_image_capture.dart';
import 'package:on_sight_application/utils/strings.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path/path.dart';
import 'package:on_sight_application/utils/functions/functions.dart';

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
    int? batteryLevel = await Battery().batteryLevel;

  if ((batteryLevel) < 15) {
  Get.closeAllSnackbars();
  Get.showSnackbar(GetSnackBar(title: alert, message: lowBatteryMsg,duration: Duration(seconds: 3),));
  }
}
}


Future<bool> _onWillPop() async {
  return false;
}

Future<bool> _onPromoPopUp() async {
  Get.back();
  Get.back();
  return true;
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
    {String? title, String? alert,  Function()? onTap, bool? cancelable}) {
  showDialog(
    context: context,
    barrierDismissible: cancelable ?? true,
    builder: (context) {
      return WillPopScope(
        onWillPop: () async => false,
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
                  alert!=null? const SizedBox(height: 10):SizedBox(height: 0),
                  alert!=null?  Text(alert,textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: Dimensions.font14, fontWeight: FontWeight.normal),):const SizedBox(height: 0,width: 0,),
                  const SizedBox(height: 10),

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

dialogWithHyperLink(BuildContext context,
    {String? title, String? alert, Color? colour, String? hyperLink,   Function()? onTap, bool? cancelable, model}) {
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

                alert!=null?  Text(alert,textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: Dimensions.font14, fontWeight: FontWeight.normal, color: colour??ColourConstants.black),):const SizedBox(height: 0,width: 0,),
                const SizedBox(height: 16),

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
                                fontWeight: Get.isDarkMode ? FontWeight.normal : FontWeight.normal))),
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
                      margin: const EdgeInsets.only(top: 20),
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
                hyperLink!=null? const SizedBox(height: 20):SizedBox(height: 0, width: 0,),
                hyperLink!=null? GestureDetector(
                    onTap: (){
                      Get.toNamed(Routes.resourceDetailsNew, arguments: model);
                    },
                    child: Text(hyperLink, style: TextStyle(decoration: TextDecoration.underline, color: Get.isPlatformDarkMode?ColourConstants.white:ColourConstants.primary),)):SizedBox(height: 0, width: 0,)
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
      return WillPopScope(
        onWillPop: _onPromoPopUp,
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
                              child: Text(no,
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
                              child: Text(yes,
                                  style: TextStyle(
                                      fontSize: Dimensions.font18,
                                      color: ColourConstants.white)),
                            )),
                      ),
                    ],
                  )
                ],
              )),
        ),
      );
    },
  );
}

optionalUpdateDialogAction(BuildContext context, version,
    {Function()? onTapYes, Function()? onTapNo}) async{
  AppUpdateManager appUpdateManager = AppUpdateManager();
  VersionDetails versionDetails = await appUpdateManager.getVersionDetails(version.toString());
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
                    child: Image.asset(Assets.connectionLost),
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
                            await appUpdateManager.updateStatus(version, 1);
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
                                await appUpdateManager.updateStatus(version, 2);
                                if(Platform.isAndroid){
                                  LaunchReview.launch(androidAppId: packageName,
                                      iOSAppId: iosAppId);
                                }else{
                                  LaunchReview.launch(writeReview: false,
                                      iOSAppId: iosAppId);
                                }
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

mandatoryUpdateDialogAction(BuildContext context,version,
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
                    child: Image.asset(Assets.appUpdateIcon),),
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
                              await appUpdateManager.updateStatus(version, 2);
                              if(Platform.isAndroid){
                                LaunchReview.launch(androidAppId: packageName,
                                    iOSAppId: iosAppId);
                              }else{
                                LaunchReview.launch(writeReview: false,
                                    iOSAppId: iosAppId);
                              }
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

Widget bottomSheetImagePicker(route) {
  localList.clear();
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
                Get.to(
                      () => MultiImageCapture(
                    onRemoveImage: (File image) async {
// Show dialog
                      return true;
                    },
                    onAddImage: (image) async {

                      await Future.delayed(Duration(seconds: 3));

                    },
                    onComplete: (finalImages) {

                      print("Captured: ${finalImages.length}");

                      if (finalImages.isNotEmpty) {
                        for (var element in finalImages) {
                          File file = File(element.path);
                          String fileName = basename(element.path);
                          ImagePickerModel imagePickerModel = ImagePickerModel();
                          imagePickerModel.imageName = fileName;
                          imagePickerModel.imagePath = file.path;
                          localList.add(imagePickerModel);
                        }
                      }
                      Get.back();

                    },
                    maxImages: 10,
                  ),
                );
                analyticsFireEvent(cameraOrGalleryKey, input: {
                  cameraOrGalleryKey:cameraStr,
                });
                // final ImagePicker picker = ImagePicker();
                // var path = await createFolderInAppDocDir(camFolder);
                // final XFile? picImage =
                // // Capture a photo from camera
                // await picker.pickImage(source: ImageSource.camera,imageQuality: imageQualityRatio);
                //
                // if (picImage != null) {
                //   File file = File(picImage.path);
                //   String fileName = "${basename(picImage.path).split(".").first}${DateTime.now().millisecondsSinceEpoch}.jpg";
                //   File newFile = await file.copy(path + fileName);
                //   ImagePickerModel imagePickerModel = ImagePickerModel();
                //   imagePickerModel.imageName = fileName;
                //   imagePickerModel.imagePath = newFile.path;
                //   localList.add(imagePickerModel);
                // }
                // Get.back();
              },
              child: Image.asset(
                Assets.icAddPhoto,
                height: 40,
                width: 40,
              ),
            ),
            const SizedBox(width: 16),
            GestureDetector(
                onTap: () async {
                  analyticsFireEvent(cameraOrGalleryKey, input: {
                    cameraOrGalleryKey:galleryStr,
                  });
                  final ImagePicker picker = ImagePicker();
                  // Capture a photo from gallery
                  final List<XFile>? picImage = await picker.pickMultiImage(imageQuality: imageQualityRatio);
                  if (picImage != null) {
                    if (picImage.isNotEmpty) {
                      for (var element in picImage) {
                        File file = File(element.path);
                        String fileName = basename(element.path);
                        ImagePickerModel imagePickerModel = ImagePickerModel();
                        imagePickerModel.imageName = fileName;
                        imagePickerModel.imagePath = file.path;
                        localList.add(imagePickerModel);
                      }
                    }
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
                              Get.back();
                            },child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Text(addCaps,style: TextStyle(color: Colors.white),),
                                ),
                              ],
                            ))],backgroundColor: ColourConstants.primary,elevation: 0,automaticallyImplyLeading: false,  leading: IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              color: ColourConstants.white,
                              size: 25,
                            ),
                            onPressed: () {
                              localList.clear();
                              Get.back();
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
                },
                child: Image.asset(
                  Assets.icGallery,
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

Widget bottomSheetImagePickerPromo(route) {
  localList.clear();
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
                Get.to(
                      () => MultiImageCapture(
                    onRemoveImage: (File image) async {
                      return true;
                    },
                    onAddImage: (image) async {
                      await Future.delayed(Duration(seconds: 3));

                    },
                    onComplete: (finalImages) async {

                      if (finalImages.isNotEmpty) {
                        for (var element in finalImages) {
                          File file = File(element.path);
                          String fileName = basename(element.path);
                          ImagePickerModel imagePickerModel = ImagePickerModel();
                          imagePickerModel.imageName = fileName;
                          imagePickerModel.imagePath = file.path;
                          localList.add(imagePickerModel);
                        }
                      }
                      Get.back();

                    },
                    maxImages: 10,
                  ),
                );
             /*   analyticsFireEvent(cameraOrGalleryKey, input: {
                  cameraOrGalleryKey:cameraStr,
                });
                final ImagePicker picker = ImagePicker();
                var path = await createFolderInAppDocDir(camFolder);
                final XFile? picImage =
                // Capture a photo from camera
                await picker.pickImage(source: ImageSource.camera);

                if (picImage != null) {
                  File file = File(picImage.path);
                  String fileName = "${basename(picImage.path).split(".").first}${DateTime.now().millisecondsSinceEpoch}.jpg";
                  File newFile = await file.copy(path + fileName);
                  ImagePickerModel imagePickerModel = ImagePickerModel();
                  imagePickerModel.imageName = fileName;
                  imagePickerModel.imagePath = newFile.path;
                  localList.add(imagePickerModel);
                }
                Get.back();*/
              },
              child: Image.asset(
                Assets.icAddPhoto,
                height: 40,
                width: 40,
              ),
            ),
            const SizedBox(width: 16),
            GestureDetector(
                onTap: () async {
                  analyticsFireEvent(cameraOrGalleryKey, input: {
                    cameraOrGalleryKey:galleryStr,
                  });
                  final ImagePicker picker = ImagePicker();
                  // Capture a photo from gallery
                  final List<XFile>? picImage = await picker.pickMultiImage();
                  if (picImage != null) {
                    if (picImage.isNotEmpty) {
                      for (var element in picImage) {
                        File file = File(element.path);
                        String fileName = basename(element.path);
                        ImagePickerModel imagePickerModel = ImagePickerModel();
                        imagePickerModel.imageName = fileName;
                        imagePickerModel.imagePath = file.path;
                        localList.add(imagePickerModel);
                      }
                    }
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
                              Get.back();
                            },child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Text(addCaps,style: TextStyle(color: Colors.white),),
                                ),
                              ],
                            ))],backgroundColor: ColourConstants.primary,elevation: 0,automaticallyImplyLeading: false,  leading: IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              color: ColourConstants.white,
                              size: 25,
                            ),
                            onPressed: () {
                              localList.clear();
                              Get.back();
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
                },
                child: Image.asset(
                  Assets.icGallery,
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



showRatingDialog(BuildContext context){
  RateMyApp rateMyApp;
  rateMyApp = RateMyApp(
    preferencesPrefix: 'rateMyApp_',
    minDays: 7,
    minLaunches: 10,
    remindDays: 7,
    remindLaunches: 10,
    // googlePlayIdentifier: 'fr.skyost.example',
    appStoreIdentifier: iosAppId,
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
