import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';
import 'package:on_sight_application/repository/database_managers/app_internet_manager.dart';
import 'package:on_sight_application/repository/database_managers/exhibitor_manager.dart';
import 'package:on_sight_application/repository/database_managers/leadsheet_image_manager.dart';
import 'package:on_sight_application/repository/database_model/lead_sheet_image_model.dart';
import 'package:on_sight_application/repository/web_service_requests/save_exhibitor_images_request.dart';
import 'package:on_sight_application/routes/app_pages.dart';
import 'package:on_sight_application/screens/lead_sheet/view_model/lead_sheet_controller.dart';
import 'package:on_sight_application/screens/lead_sheet/view_model/leadsheet_image_controller.dart';
import 'package:on_sight_application/utils/connectivity.dart';
import 'package:on_sight_application/utils/constants.dart';
import 'package:on_sight_application/utils/dialogs.dart';
import 'package:on_sight_application/utils/dimensions.dart';
import 'package:on_sight_application/utils/functions/functions.dart';
import 'package:on_sight_application/utils/shared_preferences.dart';
import 'package:on_sight_application/utils/strings.dart';
import 'package:on_sight_application/utils/widgets/text_row.dart';

class LeadSheetDetailScreen extends StatefulWidget {
  const LeadSheetDetailScreen({Key? key}) : super(key: key);

  @override
  State<LeadSheetDetailScreen> createState() => _LeadSheetDetailScreenState();
}

class _LeadSheetDetailScreenState extends State<LeadSheetDetailScreen> {
  var service = FlutterBackgroundService();
  bool isHighPriorityLead = false;
  LeadSheetController controller = Get.find<LeadSheetController>();
  LeadSheetImageController leadSheetImageController =
      Get.put(LeadSheetImageController());


  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Get.isDarkMode ? ColourConstants.white : ColourConstants.primary,
              size: Dimensions.height25,
            ),
            onPressed: () {
              Get.back();
            },
          ),
          actions: [
            GestureDetector(
                onTap: () {
                  Get.toNamed(Routes.addExhibitorScreen,
                      arguments: [Get.arguments, "", false]);
                },
                child: Container(
                    margin: EdgeInsets.only(right: Dimensions.height20, top: Dimensions.height15, bottom: Dimensions.height15),
                    alignment: Alignment.center,
                    width: Dimensions.height28,
                    height: Dimensions.height28,
                    constraints: BoxConstraints(minWidth: Dimensions.height28,minHeight: Dimensions.height28,maxHeight: Dimensions.height28,maxWidth: Dimensions.height28),
                    color: Get.isDarkMode ? ColourConstants.white : ColourConstants.primary,
                    child: Icon(Icons.add,
                        size: Dimensions.height24,
                        color: Get.isDarkMode
                            ? ColourConstants.primary
                            : ColourConstants.white)))
          ],
          elevation: 0.0,
          backgroundColor: Get.isDarkMode ? ColourConstants.black : ColourConstants.white,
          title: Text(controller.detailsModel!.showNumber.toString(),
              style: TextStyle(
                  color:
                      Get.isDarkMode ? ColourConstants.white : ColourConstants.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: Dimensions.font16)),
        ),
        bottomNavigationBar: Obx(
          () => Visibility(
            visible: controller.buttonSubmit.value,
            child: GestureDetector(
              onTap: () async {
                bool isNetActive = await ConnectionStatus.getInstance().checkConnection();
                if (isNetActive) {
                  var connectivityResult = await (Connectivity().checkConnectivity());
                  controller.buttonSubmit.value = false;
                  controller.update();
                  if (connectivityResult == ConnectivityResult.wifi) {
                    uploadImage();
                  } else {
                    AppInternetManager appInternetManager = AppInternetManager();
                    var a = await appInternetManager.getSettingsTable();
                    if (a[0][appInternetStatus] == 1) {
                      uploadImage();
                    } else {
                      uploadImage(showAppSettingSnackBar: true);
                    }
                  }
                } else {
                  Get.closeAllSnackbars();
                  Get.snackbar(alert, pleaseCheckInternet);
                }
              },
              child: Container(
                height: Dimensions.height50,
                margin: EdgeInsets.only(left: Dimensions.height35, right: Dimensions.height35, bottom: Dimensions.height40),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(Dimensions.radius8)),
                  color: ColourConstants.primary,
                ),
                child: Center(
                    child: Text(
                  submit,
                  style: TextStyle(
                      color: ColourConstants.white,
                      fontWeight: FontWeight.w400,
                      fontSize: Dimensions.font16),
                )),
              ),
            ),
          ),
        ),
        body: Obx(() => SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: Dimensions.height10),
                  TextRow(title: showName,value: controller.detailsModel?.showName.toString()),
                  TextRow(title: showDates,value: "${controller.formatTime(controller.detailsModel!.startDate.toString())} - ${controller.formatTime(controller.detailsModel!.endDate.toString())}"),
                  TextRow(title: city,value: controller.detailsModel?.showCity.toString()),
                  TextRow(title: generalContractor,value: controller.detailsModel?.showGC.toString()),
                  GestureDetector(
                    onTap: () {
                      if (controller.selectedExhibitorModel.isNotEmpty) {
                        print(controller.selectedExhibitorModel.length
                            .toString());
                      }
                      controller.getSheetDetails(Routes.leadSheetDetailScreen,
                          controller.showNumber.value, false);
                      Get.toNamed(Routes.exhibitorListingScreen)?.then((value) {
                        if (controller.selectedExhibitorModel.isNotEmpty) {
                          print(controller.selectedExhibitorModel.length
                              .toString());
                          setState(() {});
                        }
                      });
                    },
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: Dimensions.height20),
                        height: Dimensions.height35,
                        width: double.infinity,
                        margin: EdgeInsets.only(top: Dimensions.height10),
                        color: ColourConstants.primary,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                exhibitor,
                                style: TextStyle(
                                    color: ColourConstants.white, fontSize: Dimensions.font15),
                              ),
                              Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: ColourConstants.white,
                              )
                            ])),
                  ),
                  controller.showExhibitor.isTrue
                      ? Visibility(
                          visible: controller.showExhibitor.value,
                          child: Container(
                            color: Get.isDarkMode?ColourConstants.black:Colors.deepPurple.shade100.withOpacity(0.2),
                            child: Column(
                              children: [
                                SizedBox(height: Dimensions.height12),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: Dimensions.height20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: Dimensions.height8),
                                        child: Text(controller.selectedExhibitorModel.first.exhibitorName ?? exhibitor),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Get.toNamed(Routes.addExhibitorScreen,
                                              arguments: [
                                                Get.arguments,
                                                controller
                                                    .selectedExhibitorModel
                                                    .first,
                                                true
                                              ]);
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.only(right: Dimensions.height5),
                                          child: Icon(
                                            Icons.edit,
                                            color: Get.isDarkMode?ColourConstants.white:ColourConstants.primary,
                                            size: Dimensions.height18,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: Dimensions.height24),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: Dimensions.height4),
                                  child: Column(
                                    children: [
                                      TextRow(title: nameString,value: controller.selectedExhibitorModel.first.exhibitorName.toString()),
                                      TextRow(title: boothSize,value: controller.selectedExhibitorModel.first.boothSize.toString()),
                                      TextRow(title: boothNumber,value: controller.selectedExhibitorModel.first.boothNumber.toString()),
                                      TextRow(title: shop,value: controller.selectedExhibitorModel.first.shop.toString()),
                                      TextRow(title: setUpCompany,value: controller.selectedExhibitorModel.first.setupCompany.toString()),
                                      TextRow(title: notes,value: controller.selectedExhibitorModel.first.notes.toString()),
                                      Container(
                                        padding: EdgeInsets.symmetric(vertical: Dimensions.height5, horizontal: Dimensions.height6),
                                        margin: EdgeInsets.only(bottom: Dimensions.height7,left: Dimensions.height20),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                             Text(highPriorityLead,
                                                style: TextStyle(
                                                    color:Get.isDarkMode?ColourConstants.white: ColourConstants.greyText,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: Dimensions.font13)),
                                            Checkbox(
                                                value: controller
                                                    .selectedExhibitorModel
                                                    .first
                                                    .isHighPriority,
                                                checkColor:
                                                    ColourConstants.white,
                                                activeColor:
                                                    ColourConstants.greenColor,
                                                onChanged: (val) {
                                                  setState(() {
                                                    isHighPriorityLead = val!;
                                                  });
                                                }),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container(),
                  controller.showExhibitor.isTrue
                      ? Visibility(
                          visible: controller.showExhibitor.value,
                          child: Container(
                            margin: EdgeInsets.only(
                                top: Dimensions.height16, right: Dimensions.height16, left: Dimensions.height16),
                            padding: EdgeInsets.symmetric(
                                vertical: Dimensions.height12, horizontal: Dimensions.height10),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1, color: ColourConstants.grey200)),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Text(controller
                                            .selectedExhibitorModel
                                            .first
                                            .exhibitorName ??
                                        "")),
                                const Spacer(),
                                FutureBuilder(
                                    future: LeadSheetImageManager()
                                        .getYetToSubmitCount(
                                            controller.selectedExhibitorModel
                                                .first.exhibitorId
                                                .toString(),
                                            controller.showNumber.value),
                                    builder: (ctx, snapshot) {
                                      if (snapshot.hasData) {
                                        var data = snapshot.data;

                                        return Visibility(
                                            visible: controller
                                                        .selectedExhibitorModel
                                                        .first
                                                        .yetToSubmit
                                                        .toString() !=
                                                    "null"
                                                ? data == 0
                                                    ? false
                                                    : true
                                                : false,
                                            child: GestureDetector(
                                              onTap: () {
                                                leadSheetImageController
                                                    .photoList
                                                    .clear();
                                                leadSheetImageController.setupData(
                                                    controller
                                                        .selectedExhibitorModel
                                                        .first
                                                        .exhibitorId
                                                        .toString(),
                                                    controller
                                                        .showNumber.value);
                                                Get.toNamed(
                                                    Routes.leadSheetPhotosNote,
                                                    arguments: [
                                                      controller
                                                          .selectedExhibitorModel
                                                          .first
                                                          .exhibitorId
                                                          .toString(),
                                                      smallUpdateStr
                                                    ])?.then((value) {
                                                  setState(() {});
                                                });
                                              },
                                              child: Container(
                                                color: ColourConstants.red,
                                                width: Dimensions.height100,
                                                height: Dimensions.height24,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      yetToSubmit,
                                                      style: TextStyle(
                                                          fontSize: Dimensions.font10,
                                                          color: ColourConstants.white),
                                                    ),
                                                    SizedBox(width: Dimensions.height8),
                                                    Text(
                                                      controller
                                                          .selectedExhibitorModel
                                                          .first
                                                          .yetToSubmit
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: Dimensions.font13,
                                                          color: ColourConstants.white),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ));
                                      } else {
                                        return Container();
                                      }
                                    }),
                                StreamBuilder<Map<String, dynamic>?>(
                                    stream:
                                        FlutterBackgroundService().on(result),
                                    builder: (context, snapshot) {
                                      print(snapshot.connectionState);
                                      print(snapshot.data);

                                      if (snapshot.connectionState ==
                                          ConnectionState.active) {
                                        if (snapshot.hasData) {
                                          dynamic jsonObj =
                                              snapshot.data!["response"];
                                          var catId =
                                              jsonObj["ExhibitorId"].toString();
                                          var count =
                                              jsonObj["ExhibitorPhotoCount"]
                                                  .toString();
                                          if (catId.toString() ==
                                              controller.selectedExhibitorModel
                                                  .first.exhibitorId
                                                  .toString()) {
                                            controller.selectedExhibitorModel
                                                    .first.exhibitorImageCount =
                                                int.parse(count.toString());
                                            controller.selectedExhibitorModel
                                                    .first.folderUrl =
                                                jsonObj["ExhibitorFolderUrl"]
                                                    .toString();
                                            controller.update();
                                          }
                                        }
                                      }
                                      return GestureDetector(
                                        onTap: () {
                                          if (controller.selectedExhibitorModel
                                                  .first.folderUrl !=
                                              null) {
                                            if (controller
                                                .selectedExhibitorModel
                                                .first
                                                .folderUrl
                                                .toString()
                                                .isNotEmpty) {
                                              Get.toNamed(Routes.myWebView,
                                                  arguments: controller
                                                      .selectedExhibitorModel
                                                      .first
                                                      .folderUrl
                                                      .toString());
                                            }
                                          }
                                        },
                                        child: Container(
                                            margin: EdgeInsets.only(left: Dimensions.height6),
                                            alignment: Alignment.center,
                                            color: ColourConstants.green,
                                            width: Dimensions.height28,
                                            height: Dimensions.height24,
                                            child: Text(
                                                controller
                                                    .selectedExhibitorModel
                                                    .first
                                                    .exhibitorImageCount
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: Dimensions.font13,
                                                    color: ColourConstants.white))),
                                      );
                                    }),
                                GestureDetector(
                                  onTap: () {
                                    leadSheetImageController.photoList.clear();
                                    leadSheetImageController.setupData(
                                        controller.selectedExhibitorModel.first
                                            .exhibitorId
                                            .toString(),
                                        controller.showNumber.value);
                                    showModalBottomSheet(
                                       // backgroundColor: Get.isDarkMode ? ColourConstants.grey900 : ColourConstants.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(Dimensions.radius10),
                                                topRight: Radius.circular(Dimensions.radius10))),
                                        isScrollControlled: true,
                                        context: context,
                                        builder: (context){
                                          return StatefulBuilder(builder: (context, setState){
                                            //return bottomSheetImagePickerLeadSheet(Routes.leadSheetDetailScreen, controller.selectedExhibitorModel.first.exhibitorId.toString(), add);
                                            return bottomSheetImagePicker(Routes.leadSheetDetailScreen);
                                          });
                                        }).then((value) {
                                          ImagePickerLeadSheet(Routes.leadSheetDetailScreen, controller.selectedExhibitorModel.first.exhibitorId.toString(), add);
                                      setState(() {});
                                    });
                                  },
                                  child: Container(
                                      margin: EdgeInsets.only(left: Dimensions.height12),
                                      alignment: Alignment.center,
                                      color: ColourConstants.primary,
                                      width: Dimensions.height24,
                                      height: Dimensions.height24,
                                      child: Icon(Icons.add,
                                          color: ColourConstants.white,size: Dimensions.height18,)),
                                ),
                              ],
                            ),
                          ))
                      : Container(),
                  SizedBox(
                    height: Dimensions.height10,
                  )
                ],
              ),
            )));
  }

  uploadImage({bool showAppSettingSnackBar = false}) async {
    if (!await service.isRunning()) {
      service.startService().then((value) async {
        Future.delayed(Duration(seconds: 3), () async {
          if (await service.isRunning()) {
            List<LeadSheetImageModel> list = await LeadSheetImageManager()
                .getImageByExhibitorIdAndShowNumber(
                    controller.selectedExhibitorModel.first.exhibitorId
                        .toString(),
                    controller.showNumber.value);
            analyticsFireEvent(leadSheetKey, input: {
              numberOfPhotos: list.length,
              user: sp?.getString(Preference.FIRST_NAME) ?? ""
            });
            if (list.isNotEmpty) {
              SaveExhibitorImagesRequest saveExhibitorImagesRequest =
                  SaveExhibitorImagesRequest();
              saveExhibitorImagesRequest.showNumber =
                  controller.showNumber.value;
              saveExhibitorImagesRequest.showDetailInput =
                  ShowDetailInput.fromJson(controller.detailsModel!.toJson());
              saveExhibitorImagesRequest.exhibitorInput =
                  ExhibitorInput.fromJson(
                      controller.selectedExhibitorModel.first.toJson());
              saveExhibitorImagesRequest.exhibitorInput!.exhibitorImageCount =
                  list.length;
              var token = await sp!.getString(Preference.ACCESS_TOKEN);
              Map<String, dynamic> map = Map();
              map["isHighPriority"] =
                  controller.selectedExhibitorModel.first.isHighPriority;
              map["request"] = saveExhibitorImagesRequest.toJson();
              map["token"] = token;
              print(map);
              service.invoke("leadSheet", map);
              await defaultDialog(Get.context!,
                  title: photosSubmittedSuccessfully,
                  cancelable: false, onTap: () async {
                controller.buttonSubmit.value = false;
                controller.selectedExhibitorModel.first.yetToSubmit = 0;

                ExhibitorManager().updateYetToSubmit(
                    0, controller.selectedExhibitorModel.first.exhibitorId);
                for (var element in list) {
                  LeadSheetImageManager()
                      .updateYetToSubmit(1, element.exhibitorId);
                }
                controller.list.refresh();
                controller.update();

                Get.back();
                setState(() {});
                if (showAppSettingSnackBar) {
                  Get.snackbar(alert, settingsInternetMsg,
                      duration: Duration(seconds: 4));
                }
                checkBatteryStatus();
              });
            }
          }
        });
      });
    } else {
      if (await service.isRunning()) {
        List<LeadSheetImageModel> list = await LeadSheetImageManager()
            .getImageByExhibitorIdAndShowNumber(
                controller.selectedExhibitorModel.first.exhibitorId.toString(),
                controller.showNumber.value);

        if (list.isNotEmpty) {
          SaveExhibitorImagesRequest saveExhibitorImagesRequest =
              SaveExhibitorImagesRequest();
          saveExhibitorImagesRequest.showNumber = controller.showNumber.value;
          saveExhibitorImagesRequest.showDetailInput =
              ShowDetailInput.fromJson(controller.detailsModel!.toJson());
          saveExhibitorImagesRequest.exhibitorInput = ExhibitorInput.fromJson(
              controller.selectedExhibitorModel.first.toJson());
          saveExhibitorImagesRequest.exhibitorInput!.exhibitorImageCount =
              list.length;
          var token = await sp!.getString(Preference.ACCESS_TOKEN);
          Map<String, dynamic> map = Map();
          map["isHighPriority"] =
              controller.selectedExhibitorModel.first.isHighPriority;
          map["request"] = saveExhibitorImagesRequest.toJson();
          map["token"] = token;
          print(map);
          service.invoke("leadSheet", map);
          await defaultDialog(Get.context!,
              title: photosSubmittedSuccessfully,
              cancelable: false, onTap: () async {
            controller.buttonSubmit.value = false;
            controller.selectedExhibitorModel.first.yetToSubmit = 0;
            ExhibitorManager().updateYetToSubmit(
                0, controller.selectedExhibitorModel.first.exhibitorId);
            for (var element in list) {
              LeadSheetImageManager().updateYetToSubmit(1, element.exhibitorId);
            }

            controller.list.refresh();
            controller.update();

            Get.back();
            setState(() {});
            if (showAppSettingSnackBar) {
              Get.snackbar(alert, settingsInternetMsg,
                  duration: Duration(seconds: 4));
            }
            checkBatteryStatus();
          });
        }
      }
    }
  }

  Container detailsRow({title, value}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: Dimensions.height5, horizontal: Dimensions.height16),
      margin: EdgeInsets.only(bottom: Dimensions.height7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(
                  color:
                      Get.isDarkMode ? ColourConstants.white : ColourConstants.greyText,
                  fontWeight: FontWeight.w400,
                  fontSize: Dimensions.font13)),
          SizedBox(
            width: Dimensions.height10,
          ),
          Expanded(
            child: Text(value,
                textAlign: TextAlign.end,
                style: TextStyle(
                    color: Get.isDarkMode
                        ? ColourConstants.greyTextDarkMode
                        : ColourConstants.black,
                    fontWeight: FontWeight.bold,
                    fontSize: Dimensions.font13)),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.selectedExhibitor.value = 111111;
    controller.showExhibitor.value = false;
    super.dispose();
  }
}
