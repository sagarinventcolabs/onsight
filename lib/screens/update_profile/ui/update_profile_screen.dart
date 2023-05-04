import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:on_sight_application/generated/assets.dart';
import 'package:on_sight_application/routes/app_pages.dart';
import 'package:on_sight_application/screens/update_profile/view_model/profile_controller.dart';
import 'package:on_sight_application/utils/constants.dart';
import 'package:on_sight_application/utils/dimensions.dart';
import 'package:on_sight_application/utils/functions/functions.dart';
import 'package:on_sight_application/utils/strings.dart';
import 'package:on_sight_application/utils/widgets/base_app_bar.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({Key? key}) : super(key: key);

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  ProfileController profileController = Get.put(ProfileController());

  @override
  initState() {
    super.initState();
    profileController.getProfile();
  }

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    return Obx(() => Scaffold(
        appBar: const BaseAppBar(title: profile),
        bottomNavigationBar: GestureDetector(
            onTap: () async {
              if (profileController.isUpdate.isTrue) {
                FocusScope.of(context).unfocus();

                await profileController.updateProfile();
                await analyticsFireEvent(updateProfile, input: {
                  firstName: profileController.firstNameController.text.toString(),
                  email: profileController.emailController.text.toString(),
                  lastName: profileController.lastNameController.text.toString(),
                });
                Get.offAllNamed(Routes.dashboardScreen);
              }
            },
            child: Padding(
              padding: EdgeInsets.only(left: Dimensions.height40, right: Dimensions.height40, bottom: Dimensions.height35),
              child: Container(
                height: Dimensions.height45,
                width: Dimensions.height250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(Dimensions.height10)),
                  color: profileController.isUpdate.isTrue
                      ? ColourConstants.primary
                      : Colors.grey,
                ),
                child: Center(
                    child: Text(
                  updateString,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: Dimensions.font16),
                )),
              ),
            )),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height / 6),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.height40),
                  child: Get.isDarkMode
                      ? Image.asset(Assets.logoTextDark, height: Dimensions.height63)
                      : Image.asset(Assets.logoText, height: Dimensions.height63)),
              SizedBox(
                height: Dimensions.height40,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.height25, vertical: Dimensions.height10),
                child: TextField(
                  controller: profileController.firstNameController,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
                  ],
                  onChanged: (val) {
                    if (profileController.validate()) {
                      profileController.isUpdate.value = true;
                      profileController.update();
                    } else {
                      profileController.isUpdate.value = false;
                      profileController.update();
                    }
                  },
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: firstName,
                    floatingLabelStyle: TextStyle(
                        color: Get.isDarkMode
                            ? ColourConstants.primary
                            : Colors.black54),
                    labelStyle: TextStyle(
                        color: Get.isDarkMode ? Colors.white : Colors.black54),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 1,
                          color: Get.isDarkMode
                              ? ColourConstants.primary
                              : Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 1,
                          color: Get.isDarkMode
                              ? ColourConstants.primary
                              : Colors.blue),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.red),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.red),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.height25, vertical: Dimensions.height10),
                child: TextField(
                  controller: profileController.lastNameController,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
                  ],
                  onChanged: (val) {
                    if (profileController.validate()) {
                      profileController.isUpdate.value = true;
                      profileController.update();
                    } else {
                      profileController.isUpdate.value = false;
                      profileController.update();
                    }
                  },
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: lastName,
                    floatingLabelStyle: TextStyle(
                        color: Get.isDarkMode
                            ? ColourConstants.primary
                            : Colors.black54),
                    labelStyle: TextStyle(
                        color: Get.isDarkMode ? Colors.white : Colors.black54),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 1,
                          color: Get.isDarkMode
                              ? ColourConstants.primary
                              : Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 1,
                          color: Get.isDarkMode
                              ? ColourConstants.primary
                              : Colors.blue),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.red),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.red),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.height25, vertical: Dimensions.height10),
                child: TextField(
                  enabled: false,
                  controller: profileController.emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: Colors.grey),
                  inputFormatters: [FilteringTextInputFormatter.deny(" ")],
                  onChanged: (val) {
                    if (profileController.validate()) {
                      profileController.isUpdate.value = true;
                      profileController.update();
                    } else {
                      profileController.isUpdate.value = false;
                      profileController.update();
                    }
                  },
                  decoration: InputDecoration(
                    labelText: email,
                    floatingLabelStyle: TextStyle(
                        color: Get.isDarkMode
                            ? ColourConstants.primary
                            : Colors.black54),
                    labelStyle: TextStyle(
                        color: Get.isDarkMode ? Colors.white : Colors.black54),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 1,
                          color: Get.isDarkMode
                              ? ColourConstants.primary
                              : Colors.grey),
                    ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 1,
                            color: Get.isDarkMode
                                ? ColourConstants.primary
                                : Colors.grey),
                      ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 1,
                          color: Get.isDarkMode
                              ? ColourConstants.primary
                              : Colors.blue),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.red),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.red),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )));
  }
}
