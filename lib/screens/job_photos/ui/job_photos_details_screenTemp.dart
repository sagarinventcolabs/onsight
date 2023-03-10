import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:on_sight_application/generated/assets.dart';
import 'package:on_sight_application/repository/database_managers/app_internet_manager.dart';
import 'package:on_sight_application/repository/database_managers/email_manager.dart';
import 'package:on_sight_application/repository/database_managers/image_manager.dart';
import 'package:on_sight_application/repository/database_model/email.dart';
import 'package:on_sight_application/repository/database_model/image_model.dart';
import 'package:on_sight_application/repository/web_service_response/job_categories_response.dart';
import 'package:on_sight_application/routes/app_pages.dart';
import 'package:on_sight_application/screens/job_photos/view_model/job_photos_controller.dart';
import 'package:on_sight_application/screens/job_photos/view_model/upload_job_photos_controller.dart';
import 'package:on_sight_application/screens/project_evaluation/view_model/project_evaluation_controller.dart';
import 'package:on_sight_application/screens/project_evaluation/view_model/project_evaluation_install_controller.dart';
import 'package:on_sight_application/screens/setting/view_model/settings_controller.dart';
import 'package:on_sight_application/utils/connectivity.dart';
import 'package:on_sight_application/utils/constants.dart';
import 'package:on_sight_application/utils/dialogs.dart';
import 'package:on_sight_application/utils/dimensions.dart';
import 'package:on_sight_application/utils/functions/functions.dart';
import 'package:on_sight_application/utils/shared_preferences.dart';
import 'package:on_sight_application/utils/strings.dart';
import 'package:on_sight_application/utils/widgets/text_row.dart';
import 'package:url_launcher/url_launcher.dart';

class JobPhotosDetailsScreenTemp extends StatefulWidget {
  const JobPhotosDetailsScreenTemp({Key? key}) : super(key: key);

  @override
  State<JobPhotosDetailsScreenTemp> createState() => _JobPhotosDetailsScreenTempState();
}

class _JobPhotosDetailsScreenTempState extends State<JobPhotosDetailsScreenTemp> {
  var isData = false;
  final f = DateFormat('dd-MM-yyyy');
  TextEditingController emailEditingController =
  TextEditingController(text: "");
  FocusNode emailFocusNode = FocusNode();

  JobPhotosController controller = Get.find<JobPhotosController>();
  UploadJobPhotosController _uploadJobPhotosController =
  Get.put(UploadJobPhotosController());

  ScrollController scrollController = ScrollController();
  ImageManager manager = ImageManager();
  var service = FlutterBackgroundService();
  List<JobCategoriesResponse> categoryList = [];

  @override
  initState() {
    super.initState();
    if (controller.list.isNotEmpty) {
      isData = true;
      controller.jobNumber2.value = controller.list.first.jobNumber.toString();
      controller.update();
    }

    if(controller.list.isNotEmpty) {
      controller.getEmail(controller.list.first.jobNumber.toString());
    }
    controller.categoryList.sort((a, b) {
      return a.rowId.toString().compareTo(b.rowId.toString());
    });
    controller.isValidEmail.value = true;
    controller.update();
  }

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Get.isDarkMode ? ColourConstants.white : ColourConstants.primary,
                size: Dimensions.size25,
              ),
              onPressed: () {
                Get.back();
              },
            ),
            elevation: 0.0,
            backgroundColor: Get.isDarkMode ? ColourConstants.black : ColourConstants.white,
            title: Text(
                isData ? controller.list.first.jobNumber.toString() : "",
                style: TextStyle(
                    color: Get.isDarkMode ? ColourConstants.white : ColourConstants.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: Dimensions.font16)),
            bottom: TabBar(
              onTap: (index) {
                //your currently selected index
                controller.tabCurrentIndex.value = index;
                if (controller.tabCurrentIndex.value == 1) {
                  controller.getJobDetails(
                      controller.jobNumber2.toString(), Get.arguments, false, fromCat);
                }
                controller.isValidEmail.value = true;
                controller.update();
              },
              indicatorColor: ColourConstants.primaryLight,
              indicatorWeight: 4.0,
              padding: EdgeInsets.zero,
              unselectedLabelColor: ColourConstants.greyText,
              labelColor: Get.isDarkMode ? ColourConstants.primaryLight : ColourConstants.black,
              unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: Dimensions.font14),
              labelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: Dimensions.font14),
              tabs: const [
                Tab(
                  text: showDetails,
                ),
                Tab(
                  text: categoriesText,
                ),
              ],
            ),
          ),
          bottomNavigationBar: Obx(() => controller.tabCurrentIndex.value == 1
              ? GestureDetector(
              onTap: () async {
              if (controller.enableButton.isTrue) {
                var connectivityResult = await (Connectivity().checkConnectivity());
                bool isNetActive = await ConnectionStatus.getInstance().checkConnection();
                if (isNetActive) {
                  if (connectivityResult == ConnectivityResult.wifi) {
                    uploadImages();
                  }else {
                    AppInternetManager appInternetManager = AppInternetManager();
                    var a = await appInternetManager.getSettingsTable();
                    if (a.isNotEmpty){
                      if (a[0][appInternetStatus] == 1) {
                        uploadImages();
                      } else {
                        uploadImages(showAppSettingSnackBar: true);
                      }
                  }else{
                      uploadImages();
                    }
                  }
                }
                else {
                  Get.snackbar(alert, pleaseCheckInternet);
                }
              }
            },
            child: Container(
              height: Dimensions.height50,
              margin: EdgeInsets.only(
                  left: Dimensions.width35, right: Dimensions.width35, bottom: Dimensions.height16, top: Dimensions.height10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(Dimensions.radius8)),
                  color: controller.enableButton.isTrue
                      ? ColourConstants.primary
                      : ColourConstants.grey),
              child: Center(
                  child: Text(
                    submit,
                    style: TextStyle(
                        color: ColourConstants.white,
                        fontWeight: FontWeight.w400,
                        fontSize: Dimensions.font16),
                  )),
            ),
          )
              : const Text("")),
            body: Obx(() => TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            children: [
              ListView(
                controller: scrollController,
                children: [
                  SizedBox(height: Dimensions.height10),
                  TextRow(title: showName,value: isData ? controller.list.first.showName.toString() : naStr),
                  TextRow(title: showNumber,value: isData ? controller.list.first.showNumber.toString() : naStr),
                  TextRow(title: exhibitorName,value: isData ? controller.list.first.exhibitorName.toString() : naStr),
                  TextRow(title: booth,value: isData ? controller.list.first.boothNumber.toString() : naStr),
                  TextRow(title: city,value: isData ? controller.list.first.cityOffice.toString() : naStr),
                  TextRow(title: showDates,value: isData ? "${controller.formatTime(controller.list.first.showStartDate.toString())} - ${controller.formatTime(controller.list.first.showEndDate.toString())}" : naStr),
                  TextRow(title: location,value: isData ? controller.list.first.showLocation.toString() : naStr),
                  TextRow(title: supervision,value: isData ? controller.list.first.supervision.toString() : naStr),
                  SizedBox(height: Dimensions.height10),
                  const Divider(
                    color: ColourConstants.greyText,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: Dimensions.height25, vertical: Dimensions.height5),
                    child: Text(additionalInfo,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Get.isDarkMode ? ColourConstants.white : ColourConstants.black,
                            fontWeight: FontWeight.w500,
                            fontSize: Dimensions.font14)),
                  ),
                  TextRow(title: source,value: isData ? controller.list.first.sourceName : naStr),
                  TextRow(title: sourceContact,value: isData ? controller.list.first.sourceContactName : naStr),
                  GestureDetector(
                    onTap: () async {
                      if (controller.list.first.sourceContactMobilePhone !=
                          null) {
                        final Uri phoneLaunchUri = Uri(
                          scheme: 'tel',
                          path: controller
                              .list.first.sourceContactMobilePhone,
                        );

                        if (!await launchUrl(phoneLaunchUri)) {
                          throw 'Could not launch ${controller.list.first.sourceContactMobilePhone}';
                        }
                      }
                    },
                    child: TextRow(title: sourceContactHash,value: isData ? controller.list.first.sourceContactMobilePhone : naStr,isEmail: "phone"),
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (controller.list.first.sourceContactEmail != null) {
                        final Uri emailLaunchUri = Uri(
                          scheme: mailto,
                          path: controller.list.first.sourceContactEmail,
                          query: encodeQueryParameters(<String, String>{
                            subject: nthDegreeOnSight,
                          }),
                        );

                        if (!await launchUrl(emailLaunchUri)) {
                          throw 'Could not launch ${controller.list.first.salesRepEmailAddress}';
                        }
                      }
                    },
                    child: TextRow(title: sourceContactEmail,value: isData ? controller.list.first.sourceContactEmail : naStr,isEmail: "email"),
                    // child: jobDetailsRow(sourceContactEmail, controller.list.first.sourceContactEmail ?? naStr, "email"),
                  ),
                  jobDetailsRow(salesRep, "${controller.list.first.salesRepFirstName??""} ${controller.list.first.salesRepLastName??""}"),
                  GestureDetector(
                    onTap: () async {
                      if (controller.list.first.salesRepCellPhone != null) {
                        final Uri phoneLaunchUri = Uri(
                          scheme: 'tel',
                          path: controller.list.first.salesRepCellPhone,
                        );

                        if (!await launchUrl(phoneLaunchUri)) {
                          throw 'Could not launch ${controller.list.first.salesRepCellPhone}';
                        }
                      }
                    },
                    child: TextRow(title: salesRepHash,value: isData ? controller.list.first.salesRepCellPhone : naStr,isEmail: "phone"),
                    // child: jobDetailsRow(
                    //     salesRepHash,
                    //     controller.list.first.salesRepCellPhone ?? naStr,
                    //     "phone"),
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (controller.list.first.salesRepEmailAddress !=
                          null) {
                        final Uri emailLaunchUri = Uri(
                          scheme: mailto,
                          path: controller.list.first.salesRepEmailAddress,
                          query: encodeQueryParameters(<String, String>{
                            subject: nthDegreeOnSight,
                          }),
                        );

                        if (!await launchUrl(emailLaunchUri)) {
                          throw 'Could not launch ${controller.list.first.salesRepEmailAddress}';
                        }
                      }
                    },
                    child: TextRow(title: salesRepEmail,value: isData ? controller.list.first.salesRepEmailAddress : naStr,isEmail: "email"),
                  ),
                  GestureDetector(
                    onTap: ()async{
                      if (controller.list.first.oasisAdditionalEmail != null) {
                        final Uri emailLaunchUri = Uri(
                          scheme: mailto,
                          path: controller.list.first.oasisAdditionalEmail,
                          query: encodeQueryParameters(<String, String>{
                            subject: nthDegreeOnSight,
                          }),
                        );

                        if (!await launchUrl(emailLaunchUri)) {
                      throw 'Could not launch ${controller.list.first.oasisAdditionalEmail}';
                      }
                    }
                    },
                    child: TextRow(title: "Oasis Contacts",value: isData ? controller.list.first.oasisAdditionalEmail : naStr,isEmail: "email"),
                  ),
                  // jobDetailsRow ("Show",controller.list.first.showName??naStr),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: Dimensions.width25, vertical: Dimensions.height5),
                    child: Divider(color: ColourConstants.greyText),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: Dimensions.height25, vertical: Dimensions.height5),
                    child: Text(additionalEmailAddress,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Get.isDarkMode ? ColourConstants.white : ColourConstants.black,
                            fontWeight: FontWeight.w500,
                            fontSize: Dimensions.font14)),
                  ),
                  SizedBox(height: Dimensions.width10),

                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.height26, vertical: Dimensions.height5),
                    child: textField(),
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      controller: scrollController,
                      itemCount: controller.emailList.length,
                      itemBuilder: (builder, index) {
                        return additionalEmailWidget(
                            controller.emailList[index].additionalEmail
                                .toString(),
                            index);
                      })
                ],
              ),
              ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: Dimensions.height11, vertical: Dimensions.height16),
                    child: Text(chooseCategory,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Get.isDarkMode ? ColourConstants.white : ColourConstants.black,
                            fontWeight: FontWeight.w500,
                            fontSize: Dimensions.font15)),
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      controller: scrollController,
                      itemCount: controller.categoryList.length,
                      itemBuilder: (builder, index) {
                        return categoryWidget(
                            controller.categoryList[index].isChecked,
                            controller.categoryList[index].name.toString(),
                            index);
                      },
                  )
                ],
              ),
            ],
          ))),
    );
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
    '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  Container additionalEmailWidget(email, i) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: Dimensions.height5, horizontal: Dimensions.height25),
      padding: EdgeInsets.symmetric(vertical: Dimensions.height10, horizontal: Dimensions.width10),
      decoration: BoxDecoration(
          border: Border.all(color: ColourConstants.borderColor, width: 1)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () async {
              final Uri emailLaunchUri = Uri(
                scheme: mailto,
                path: email,
                query: encodeQueryParameters(<String, String>{
                  subject: nthDegreeOnSight,
                }),
              );

              if (!await launchUrl(emailLaunchUri)) {
                throw 'Could not launch $emailLaunchUri';
              }
            },

            child: Text(email,
                style: TextStyle(
                    color: Get.isDarkMode ? ColourConstants.white : Colors.blue,
                    fontWeight: FontWeight.w600,
                    fontSize: Dimensions.font14)
            ),
          ),
          GestureDetector(
            onTap: () {
              dialogAction(context, title: areyousuredeleteemail, onTapYes: () {
                controller.deleteEmail(i);
                Get.back();
              });
            },
            child: Image.asset(
              Assets.icDelete,
              height: Dimensions.height25,
              width: Dimensions.width25,
              color: Get.isDarkMode ? ColourConstants.white : ColourConstants.primary,
            ),
          )
        ],
      ),
    );
  }

  Container categoryWidget(status, key, index) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: Dimensions.height5, horizontal: Dimensions.height11),
      padding: EdgeInsets.symmetric(vertical: Dimensions.height10, horizontal: Dimensions.height11),
      decoration: BoxDecoration(border: Border.all(color: Get.isDarkMode ? Colors.transparent : ColourConstants.borderGreyColor, width: 1),color: Get.isDarkMode ? ColourConstants.grey900 : ColourConstants.white),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(width: Dimensions.width8),
                  SizedBox(
                    height: Dimensions.height20,
                    width: Dimensions.height20,
                    child: Theme(
                      data: ThemeData(
                        unselectedWidgetColor:
                        ColourConstants.grey.withOpacity(.5), // Your color
                      ),
                      child: Checkbox(
                          value: status ?? false,
                          checkColor: Get.isDarkMode ? ColourConstants.black : ColourConstants.white,
                          activeColor: ColourConstants.greenColor,
                          onChanged: (bool? newValue) {
                            if (newValue == true) {
                              if (controller.categoryList[index].listPhotos !=
                                  null) {
                                if (controller.categoryList[index].listPhotos!
                                    .isNotEmpty) {
                                  controller.updateChecked(index, newValue);
                                }
                              }
                            } else {
                              controller.updateChecked(index, newValue);
                            }
                            var button = false;
                            for (var element in controller.categoryList) {
                              if (element.isChecked != null) {
                                if (element.isChecked!) {
                                  button = true;
                                }
                              }
                            }
                            controller.enableButton.value = button;
                            controller.update();
                          }),
                    ),
                  ),
                  SizedBox(width: Dimensions.height11),
                  Text(key,
                      style: TextStyle(
                          color: Get.isDarkMode ? ColourConstants.white : ColourConstants.black,
                          fontWeight: FontWeight.w400,
                          fontSize: Dimensions.font12)),
                ],
              ),
              Row(
                children: [
                  Visibility(
                      visible: controller.categoryList[index].listPhotos != null
                          ? controller
                          .categoryList[index].listPhotos!.isNotEmpty
                          : false,
                      child: FutureBuilder(
                        future: manager.getYetToSubmitCount(
                            controller.categoryList[index].id,controller.list.first.jobNumber),
                        builder: (ctx, snapshot) {
                          var data = [];
                          if (snapshot.hasData) {
                            data = snapshot.data as List;
                            return Visibility(
                                visible: data[0]['COUNT(*)'].toString() ==
                                    "null" ||
                                    data[0]['COUNT(*)'].toString() == "0"
                                    ? false
                                    : true,
                                child: GestureDetector(
                                  onTap: () {
                                    _uploadJobPhotosController
                                        .enableButton.value = false;
                                    _uploadJobPhotosController.update();
                                    _uploadJobPhotosController.jobPhotosList
                                        .clear();
                                    _uploadJobPhotosController.setupData(
                                        controller.categoryList[index].id
                                            .toString(),
                                        controller.list.first.jobNumber
                                            .toString());
                                    Get.toNamed(Routes.uploadJobPhotosNote,
                                        arguments: [
                                          controller.categoryList[index].id
                                              .toString(),
                                          controller.list.first.jobNumber
                                              .toString(),
                                          smallUpdateStr
                                        ]);
                                  },
                                  child: Container(
                                    color: ColourConstants.orangeColor,
                                    padding: EdgeInsets.symmetric(
                                        vertical: Dimensions.height5, horizontal: Dimensions.width7),
                                    child: Row(
                                      children: [
                                        Text(yetToSubmit,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: ColourConstants.white,
                                                fontWeight: FontWeight.w300,
                                                fontSize: Dimensions.font8)),
                                        SizedBox(width: Dimensions.width3),
                                        GestureDetector(
                                          onTap: () {},
                                          child: Text(
                                              snapshot.data.toString() == "null"
                                                  ? ""
                                                  : data[0]['COUNT(*)']
                                                  .toString() ==
                                                  "null"
                                                  ? "0"
                                                  : data[0]['COUNT(*)']
                                                  .toString(),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: ColourConstants.white,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: Dimensions.font12)),
                                        )
                                      ],
                                    ),
                                  ),
                                ));
                          }
                          return Container();
                        },
                      )),
                  SizedBox(width: Dimensions.width8),
                  StreamBuilder<Map<String, dynamic>?>(
                    stream: FlutterBackgroundService().on(result),
                      builder: (context, snapshot){


                      if(snapshot.connectionState==ConnectionState.active){
                        if(snapshot.hasData){

                          dynamic jsonObj = snapshot.data!["response"];
                          var jobNumber = jsonObj["JobNumber"].toString();
                          if(jobNumber.toString()==controller.jobNumber2.value.toString()) {
                            var catId = jsonObj["CategoryModelDetails"][0]["CategoryId"]
                                .toString();
                            var count = jsonObj["CategoryModelDetails"][0]["ImageCount"]
                                .toString();
                            if (catId.toString() == controller
                                .categoryList[index].id.toString()) {
                              controller.categoryList[index].submitted =
                                  count.toString();
                            }
                          }
                        }
                      }
                    return GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.myWebView, arguments: controller.categoryList[index].url.toString());
                      },
                      child: Container(
                        color: ColourConstants.greenColor,
                        height: Dimensions.height25,
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(horizontal: Dimensions.height5),
                        child: Text(
                            controller.categoryList[index].submitted.toString() ==
                                "null"
                                ? "0"
                                : controller.categoryList[index].submitted
                                .toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: ColourConstants.white,
                                fontWeight: FontWeight.w400,
                                fontSize: Dimensions.font12)),
                      ),
                    );
                  }),
                  SizedBox(width: Dimensions.width8),
                  GestureDetector(
                    onTap: () {
                      _uploadJobPhotosController.jobPhotosList.clear();
                      _uploadJobPhotosController.setupData(
                          controller.categoryList[index].id.toString(),
                          controller.list.first.jobNumber.toString());
                      showModalBottomSheet(
                        //  backgroundColor: Get.isDarkMode ? ColourConstants.grey900 : ColourConstants.white,
                          //backgroundColor: Color.fromARGB(255, 0, 0, 0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(Dimensions.radius10),
                                  topRight: Radius.circular(Dimensions.radius10))),
                          isScrollControlled: true,
                          context: context,
                          builder: (ctx1){
                           return StatefulBuilder(builder: (ctx2, setState) {
                             Theme.of(context);
                            // return bottomSheetWidget(Routes.jobPhotosDetailsScreen, controller.categoryList[index].id, controller.list.first.jobNumber, add);
                             return bottomSheetImagePicker(Routes.jobPhotosDetailsScreen);
                           });
                          }).then((value) {
                            print("Steep 1");
                            ImagePickerJobPhoto(Routes.jobPhotosDetailsScreen,
                                controller.categoryList[index].id,
                                controller.list.first.jobNumber, add);
                      });
                    },
                    child: Image.asset(
                      Assets.icAdd,
                      height: Dimensions.height25,
                      width: Dimensions.height25,
                    ),
                  ),
                ],
              )
            ],
          ),
          Visibility(
            visible: key == installFreight || key == dismantleFreight,
            child: SizedBox(height: Dimensions.height12),
          ),
          Visibility(
              visible: key == installFreight || key == dismantleFreight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: Dimensions.height10,
                    width: Dimensions.width10,
                    child: Transform.scale(
                      scale: 0.8,
                      child: Theme(
                        data: ThemeData(
                          unselectedWidgetColor:
                          ColourConstants.grey.withOpacity(.5), // Your color
                        ),
                        child: Checkbox(
                            value: controller.categoryList[index].sendEmail ??
                                false,
                            checkColor: Get.isDarkMode ? ColourConstants.black : ColourConstants.white,
                            activeColor: Get.isDarkMode ? ColourConstants.white : ColourConstants.greenColor,
                            onChanged: (bool? newValue) {
                              if (newValue == true) {
                                if (controller.categoryList[index].listPhotos !=
                                    null) {
                                  if (controller.categoryList[index].listPhotos!
                                      .isNotEmpty) {
                                    controller.updateSendEmailChecked(
                                        index, newValue);
                                  }
                                } else {
                                  controller.updateSendEmailChecked(
                                      index, newValue);
                                }
                              } else {
                                controller.updateSendEmailChecked(
                                    index, newValue);
                              }
                            }),
                      ),
                    ),
                  ),
                  SizedBox(width: Dimensions.height11),
                  Text(sendEmail,
                      style: TextStyle(
                          // color: Get.isDarkMode ? ColourConstants.white : ColourConstants.black,
                          fontWeight: FontWeight.w400,
                          fontSize: Dimensions.font10)),
                  SizedBox(width: Dimensions.width5),
                ],
              ))
        ],
      ),
    );
  }

  /// Update Image Function................................
  uploadImages({bool showAppSettingSnackBar = false})async{

    SettingsController settingsController = SettingsController();
    if (settingsController.mobileDataSwitch.value) {
      controller.enableButton.value = false;
      controller.update();
      await service.startService();
      showLoader(context);
      await Future.delayed(const Duration(seconds: 5), () async {
        Get.back();
        List<dynamic> listdynamic = [];
        for (var element in controller.categoryList) {
          if(element.isChecked!=null){
            if(element.isChecked!){
              await FirebaseAnalytics.instance.logEvent(
                  name: jobPhotoUploadKey,
                  parameters: {
                user:sp?.getString(Preference.FIRST_NAME)??"",
                category:element.name.toString(),
                imageCount:element.listPhotos?.length.toString()??"0"
              });
              listdynamic.add(element.toJson());
            }
          }
        }
       /* List<dynamic> listEmail = controller.emailList
            .map((e) => e.toMap())
            .toList();*/
        var token =
        await sp!.getString(Preference.ACCESS_TOKEN);

        print(listdynamic.length);

        if(listdynamic.length>0) {
          var catName = "";
          List<String> catNAmeList = [];
          for (var element in controller.categoryList) {
            if (element.listPhotos != null) {
              for (var el in element.listPhotos!) {
                if (element.isChecked != null) {
                  if (element.isChecked!) {
                    ImageModel model = ImageModel();
                    model =
                    await manager.getImageByImageName(
                        el.imageName!);
                    if (model.isSubmitted != null) {
                      if (model.isSubmitted! < 2) {
                        model.isSubmitted = 1;
                        manager.updateImageData(model);
                      }
                    }
                  }
                }
              }
            }

            if (element.isChecked != null) {
              if (element.isChecked!) {
                if (element.name.toString().contains(showReady) || element.name.toString().contains(outbound)) {
                  catName = element.name.toString();
                  catNAmeList.add(catName);
                }
                element.listPhotos!.clear();
                element.sendEmail = false;
                element.isChecked = false;
              }
            }
          }
          service.invoke(
              "JobPhotosApi", {
            "token": token
          });
          for (var element in controller.emailList) {
            EmailManager().updateEmailStatus(
                element.additionalEmail.toString(), 2);
          }
          sp?.putInt(Preference.ACTIVITY_TRACKER, ((sp?.getInt(Preference.ACTIVITY_TRACKER)??0)+1));
          print((sp?.getInt(Preference.ACTIVITY_TRACKER)??0).toString());
          await defaultDialog(Get.context!,
              title: photosSubmittedSuccessfully,
              cancelable: false, onTap: () async {


                controller.enableButton.value = false;
                controller.categoryList.refresh();
                controller.update();

                if (catNAmeList.length > 1) {
                  Get.back();
                  await dialogAction(Get.context!,
                      title: wouldYouLikeInstallDismentalEvaluation,
                      onTapYes: () async {
                        Get.back();
                        installDismantalChooserDialog(context, jobNumber: controller.list.first.jobNumber);
                      }, onTapNo: () {
                        Get.back();
                        checkBatteryStatus();
                      });
                }
                else {
                  Get.back();
                  if (catName
                      .toString()
                      .trim()
                      .isNotEmpty) {
                    if (catName.contains(showReady)) {
                      await dialogAction(
                          Get.context!, title: wouldYouLikeInstallEvaluation,
                          onTapYes: () async {
                            Get.back();
                            ProjectEvaluationController projectEvaluationController = Get
                                .find<ProjectEvaluationController>();
                            await projectEvaluationController
                                .getProjectEvaluation(
                                controller.list.first.jobNumber,
                                false);
                            ProjectEvaluationInstallController
                            evaluationInstallController = Get.find<
                                ProjectEvaluationInstallController>();
                            await evaluationInstallController
                                .getProjectEvaluationQuestionsDetails(
                                controller.list.first.jobNumber
                                    .toString(),
                                install,
                                route: Routes.jobPhotosDetailsScreen);
                            checkBatteryStatus();
                          }, onTapNo: () {
                        Get.back();
                        checkBatteryStatus();
                      });
                    } else if (catName.contains(outbound)) {
                      await dialogAction(
                          Get.context!, title: wouldYouLikeDismentalEvaluation,
                          onTapYes: () async {
                            Get.back();
                            ProjectEvaluationController projectEvaluationController = Get
                                .find<ProjectEvaluationController>();
                            await projectEvaluationController
                                .getProjectEvaluation(
                                controller.list.first.jobNumber,
                                false);
                            ProjectEvaluationInstallController
                            evaluationInstallController = Get.find<
                                ProjectEvaluationInstallController>();
                            await evaluationInstallController
                                .getProjectEvaluationQuestionsDetails(
                                controller.list.first.jobNumber.toString(),
                                dismantle,
                                route: Routes.jobPhotosDetailsScreen);
                            checkBatteryStatus();
                          }, onTapNo: () {
                        Get.back();
                        checkBatteryStatus();
                      });
                    }
                  }
                }
                if (showAppSettingSnackBar) {
                  Get.snackbar(alert, settingsInternetMsg,
                    duration: Duration(seconds: 4));
                }
                checkBatteryStatus();
              });
        }
      });
    }else{
      Get.snackbar(alert, settingsInternetMsg,duration: Duration(seconds: 4));
    }
  }

  Container jobDetailsRow(key, value, [isEmailPhone]) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: Dimensions.height11, horizontal: Dimensions.width25),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: Text(key,
                style: TextStyle(
                  color: Get.isDarkMode ? ColourConstants.white : ColourConstants.greyText,
                  fontWeight: FontWeight.w400,
                  fontSize: Dimensions.font12),
            ),
          ),
          SizedBox(width: Dimensions.width20),
          Expanded(
            flex: 2,
            child: Text(value,
                textAlign: TextAlign.end,
                style: TextStyle(
                    color: isEmailPhone != null
                      ? value == naStr
                      ? Get.isDarkMode ? ColourConstants.white : ColourConstants.black
                      : Colors.blue
                      : Get.isDarkMode ? ColourConstants.white : ColourConstants.black,
                    fontWeight: FontWeight.w500,
                    fontSize: Dimensions.font12)),
          )
        ],
      ),
    );
  }

  Widget textField() {
    return TextField(
      controller: emailEditingController,
      focusNode: emailFocusNode,
      onChanged: (val) {

        if (EmailValidator.validate(val)) {

          controller.isValidEmailS.value = true;
          controller.isValidEmail.value = true;
          controller.emailButton.value = true;
          controller.update();
        }else{
            controller.isValidEmailS.value = false;
            controller.emailButton.value = false;
            controller.update();
        }
      },
      keyboardType: TextInputType.emailAddress,
      inputFormatters: [
        FilteringTextInputFormatter.deny(" "),
        FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9@.]"))
      ],
      decoration: InputDecoration(
        isDense: true,
        // Added this
        contentPadding:
        EdgeInsets.symmetric(horizontal: Dimensions.width10, vertical: Dimensions.height18),
        labelText: addEmail,
        labelStyle: TextStyle(
            color: controller.isValidEmail.isFalse
                ? ColourConstants.red
                : ColourConstants.primaryLight,
            fontWeight: FontWeight.w400),
        //floatingLabelStyle: TextStyle(color: !isValidPhone ? ColourConstants.red : ColourConstants.black54),
        errorText: controller.isValidEmail.isFalse ? emailValidation : null,
        suffixIconConstraints:
        BoxConstraints(minHeight: Dimensions.height25, minWidth: Dimensions.width25),
        suffixIcon: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            if (EmailValidator.validate(emailEditingController.text)) {
              var existingItem = controller.emailList.firstWhere((itemToCheck) =>
                  itemToCheck.additionalEmail == emailEditingController.text.toString(),
                  orElse: () => Email());
              if (existingItem.additionalEmail == null) {
                controller.addEmail(emailEditingController.text,
                    controller.list.first.jobNumber.toString(), 1);
                emailEditingController.clear();
                controller.isValidEmail.value = true;
              } else {
                Get.snackbar(alert, emailAlreadyExist);
                emailEditingController.clear();
              }
              controller.isValidEmail.value = true;
              controller.emailButton.value = false;
            } else {
              controller.isValidEmail.value = false;
              controller.emailButton.value = false;

            }
            controller.update();
          },
          child: Padding(
            padding: EdgeInsets.only(right: Dimensions.width14,top: Dimensions.height5),
            child: Text(addCaps,style: TextStyle(color: controller.emailButton.isTrue ? ColourConstants.primaryLight : ColourConstants.grey),),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0.0),
          borderSide: const BorderSide(width: 1, color: ColourConstants.primary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0.0),
          borderSide:
          const BorderSide(width: 1, color: ColourConstants.primary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0.0),
          borderSide: const BorderSide(width: 1, color: ColourConstants.red),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: ColourConstants.red),
        ),
      ),
    );
  }


  @override
  void dispose() {
    super.dispose();
    controller.enableButton.value = false;
  }
}
