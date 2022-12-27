import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:on_sight_application/generated/assets.dart';
import 'package:on_sight_application/screens/user_detail/view_model/user_detail_controller.dart';
import 'package:on_sight_application/utils/constants.dart';
import 'package:on_sight_application/utils/dimensions.dart';
import 'package:on_sight_application/utils/strings.dart';


class UserDetailScreen extends StatefulWidget {
  const UserDetailScreen({Key? key}) : super(key: key);

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  TextEditingController firstNameController = TextEditingController(text: "");
  TextEditingController lastNameController = TextEditingController(text: "");
  TextEditingController emailController = TextEditingController(text: "");
  var clientId = "";

  RegisterScreenController controller = RegisterScreenController();

  @override
  initState() {
    super.initState();
    clientId = Get.arguments;
  }

  @override
  Widget build(BuildContext context) {
    Theme.of(context) == Brightness.dark;
    return Obx(() => Scaffold(
        bottomNavigationBar: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              if (controller.validateFunc(firstNameController.text,
                  lastNameController.text, emailController.text)) {
                controller.registerUser(
                    clientId,
                    firstNameController.text.toString(),
                    lastNameController.text.toString(),
                    emailController.text.toString());
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 30, right: 30, bottom: 50),
              child: Container(
                height: 45,
                width: 250,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color: controller.enableButton.isTrue
                        ? ColourConstants.primary
                        : Colors.grey),
                child: Center(
                    child: Text(
                  login,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: Dimensions.font21),
                )),
              ),
            )),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 80,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Get.isDarkMode?Image.asset(Assets.logo_text_dark, height: 63):
                  Image.asset(Assets.logo_text, height: 63)
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              Text(
                littleThings,
                style: TextStyle(fontSize: Dimensions.font20, color: Get.isDarkMode?ColourConstants.dark_mode_white: Colors.black),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 50,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20),
                child: TextField(
                  controller: firstNameController,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                  ],
                  keyboardType: TextInputType.text,
                  onChanged: (val) {
                    if (val.isNotEmpty) {
                      controller.isValidFirstName.value = true;

                    } else {
                      controller.isValidFirstName.value = false;

                    }

                    controller.validateFunc(firstNameController.text, lastNameController.text, emailController.text);

                  },
                  decoration: InputDecoration(
                    labelText: firstName,
                    floatingLabelStyle: TextStyle(
                        color: controller.isValidFirstName.isFalse
                            ? Colors.red
                            :Get.isDarkMode? Colors.blue: Colors.black54),
                    errorText: controller.isValidFirstName.isFalse
                        ? firstNameValidation
                        : null,
                    labelStyle: TextStyle(color: Get.isDarkMode?ColourConstants.dark_mode_white:Colors.black54),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color:Get.isDarkMode?Colors.blue: Colors.grey),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.blue),
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.red),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.red),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
                child: TextField(
                  controller: lastNameController,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                  ],
                  keyboardType: TextInputType.text,
                  onChanged: (val) {
                    if (val.isNotEmpty) {
                      controller.isValidLastName.value = true;
                    } else {
                      controller.isValidLastName.value = false;
                    }

                    controller.validateFunc(firstNameController.text, lastNameController.text, emailController.text);


                  },
                  decoration: InputDecoration(
                    labelText: lastName,
                    floatingLabelStyle: TextStyle(
                        color: controller.isValidLastName.isFalse
                            ? Colors.red
                            : Get.isDarkMode? Colors.blue:Colors.black54),
                    errorText: controller.isValidLastName.isFalse
                        ? lastNameValidation
                        : null,
                    labelStyle: TextStyle(color:  Get.isDarkMode?ColourConstants.dark_mode_white:Colors.black54),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color:Get.isDarkMode?Colors.blue: Colors.grey),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.blue),
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.red),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.red),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
                child: TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  inputFormatters: [FilteringTextInputFormatter.deny(" ")],
                  onChanged: (val) {
                    if (val.isNotEmpty) {
                      controller.isValidEmail.value = true;
                    } else {
                      controller.isValidEmail.value = false;
                    }

                    controller.validateFunc(firstNameController.text, lastNameController.text, emailController.text);

                  },
                  decoration: InputDecoration(
                    floatingLabelStyle: TextStyle(
                        color: controller.isValidEmail.isFalse
                            ? Colors.red
                            :Get.isDarkMode? Colors.blue: Colors.black54),
                    errorText: controller.isValidEmail.isFalse
                        ? emailValidation
                        : null,
                    labelText: email,
                    labelStyle: TextStyle(color:Get.isDarkMode?ColourConstants.dark_mode_white: Colors.black54),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Get.isDarkMode?Colors.blue:Colors.grey),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.blue),
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.red),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
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
