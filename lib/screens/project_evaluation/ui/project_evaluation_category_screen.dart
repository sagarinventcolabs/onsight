import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:on_sight_application/generated/assets.dart';
import 'package:on_sight_application/screens/project_evaluation/view_model/project_evaluation_controller.dart';
import 'package:on_sight_application/screens/project_evaluation/view_model/project_evaluation_install_controller.dart';
import 'package:on_sight_application/utils/constants.dart';
import 'package:on_sight_application/utils/dialogs.dart';
import 'package:on_sight_application/utils/dimensions.dart';
import 'package:on_sight_application/utils/strings.dart';
import 'package:url_launcher/url_launcher.dart';


class ProjectEvaluationCategoryScreen extends StatefulWidget {
  const ProjectEvaluationCategoryScreen({Key? key}) : super(key: key);

  @override
  State<ProjectEvaluationCategoryScreen> createState() => _ProjectEvaluationCategoryScreenState();
}

class _ProjectEvaluationCategoryScreenState extends State<ProjectEvaluationCategoryScreen> {


  int tabCurrentIndex = 0;
 
  var isData = false;
  TextEditingController emailEditingController =  TextEditingController(text: "");
  FocusNode emailFocusNode = FocusNode();

  ProjectEvaluationController controller = Get.find<ProjectEvaluationController>();
  ProjectEvaluationInstallController projectEvaluationInstallC =
  Get.find<ProjectEvaluationInstallController>();

  ScrollController scrollController = ScrollController();

  @override
  initState(){
    super.initState();
    isData = true;

    controller.isValidEmail.value = true;
    controller.update();
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
              print("Back Called");
              Get.back();
              // if(!Get.isRegistered<ProjectEvaluationController>()){
              //   Get.put(ProjectEvaluationController());
              // }
              // Get.offNamed(Routes.projectEvaluationScreen);
            },
          ),
          elevation: 0.0,
          backgroundColor: Get.isDarkMode ? ColourConstants.black : ColourConstants.white,
          title: Text(isData?controller.jobPhotosModellist.first.jobNumber.toString():"",
              style: TextStyle(
                  color: Get.isDarkMode ? ColourConstants.white : ColourConstants.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: Dimensions.font16)),
        /*  bottom:  TabBar(
            onTap: (index) {
              //your currently selected index
              tabCurrentIndex = index;
              if(tabCurrentIndex==0){
                controller.getEmail(controller.jobPhotosModellist.first.jobNumber.toString());
              }
              controller.isValidEmail.value = true;
              controller.update();
              setState((){});
            },
            indicatorColor: ColourConstants.primaryLight,
            indicatorWeight: 4.0,
            padding: EdgeInsets.zero,
            unselectedLabelColor: ColourConstants.greyText,
            labelColor: Get.isDarkMode ? ColourConstants.primaryLight : ColourConstants.black,
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: Dimensions.font14),
            labelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: Dimensions.font14),
            tabs:const [
              Tab(
                text: showDetails,
              ),
              Tab(
                text: categoriesText,
              ),
            ],
          ),*/
        ),
        body:  ListView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.height16,vertical: Dimensions.height5),
              child: Text(chooseCategory,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: ColourConstants.black,
                      fontWeight: FontWeight.w500,
                      fontSize: Dimensions.font15)),
            ),
            SizedBox(height: Dimensions.height10),
            GestureDetector(onTap: () async {
              projectEvaluationInstallC.selectedCat.value = 0;
              controller.enableButton.value = true;
              controller.update();
              await projectEvaluationInstallC.getProjectEvaluationQuestionsDetails(controller.jobPhotosModellist.first.jobNumber.toString(),install);
            },child: categoryWidget (install,0)),

            GestureDetector(onTap: () async {
              projectEvaluationInstallC.selectedCat.value = 1;
              controller.enableButton.value = true;
              controller.update();
              await projectEvaluationInstallC.getProjectEvaluationQuestionsDetails(controller.jobPhotosModellist.first.jobNumber.toString(),dismantle);
            },child: categoryWidget (dismantle,1),
            ),
          ],
        ),
    );
  }
  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
    '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }
  Container additionalEmailWidget (email, i){
    return Container(
      margin: EdgeInsets.symmetric(vertical: Dimensions.height5,horizontal: Dimensions.height25),
      padding: EdgeInsets.symmetric(vertical: Dimensions.height10,horizontal: Dimensions.height10),
      decoration: BoxDecoration(
          color: Get.isDarkMode ? ColourConstants.grey900 : ColourConstants.white,
          border: Border.all(color: Get.isDarkMode ? ColourConstants.transparent : ColourConstants.borderColor,width: 1)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: ()async{
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
            child:Text(email,
                style: TextStyle(
                    color: Get.isDarkMode ? ColourConstants.white : ColourConstants.blue,
                    fontWeight: FontWeight.w600,
                    fontSize: Dimensions.font14)),
          ),


          GestureDetector(
            onTap: (){
              dialogAction(context, title:areyousuredeleteemail,onTapYes: (){
                controller.deleteEmail(i);
                Get.back();
              });

            },
            child: Image.asset(Assets.icDelete2,height: Dimensions.height25,width: Dimensions.height25,color: Get.isDarkMode ? ColourConstants.white : ColourConstants.primaryLight,),
          )
        ],
      ),
    );
  }


  Container categoryWidget (key, index){

    return Container(
      margin: EdgeInsets.symmetric(vertical: Dimensions.height5,horizontal: Dimensions.height16),
      padding: EdgeInsets.symmetric(vertical: Dimensions.height15,horizontal: Dimensions.height10),
      decoration: BoxDecoration(
        color: Get.isDarkMode ? ColourConstants.grey900 : ColourConstants.transparent,
          border: Border.all(color: Get.isDarkMode ? ColourConstants.transparent : ColourConstants.borderGreyColor,width: 1)
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(key,
                  style:TextStyle(
                      color: Get.isDarkMode ? ColourConstants.white : ColourConstants.black,
                      fontWeight: FontWeight.w400,
                      fontSize: Dimensions.font14)),

            ],
          ),
        ],
      ),
    );
  }

  Container jobDetailsRow (key,value,[isEmailPhone]){
    return Container(
      padding: EdgeInsets.symmetric(vertical: Dimensions.height5,horizontal: Dimensions.height16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(key,
              style: TextStyle(
                  color: Get.isDarkMode ? ColourConstants.white : ColourConstants.greyText,
                  fontWeight: FontWeight.w400,
                  fontSize: Dimensions.font12)),
          Text(value,
              style:  TextStyle(
                  color: isEmailPhone != null ? value == naStr ? Get.isDarkMode ? ColourConstants.white : ColourConstants.black : ColourConstants.blue : Get.isDarkMode ? ColourConstants.white : ColourConstants.black,
                  fontWeight: FontWeight.w500,
                  fontSize: Dimensions.font12))
        ],
      ),
    );
  }


  Widget textField(){
    return TextField(
      controller: emailEditingController,
      focusNode: emailFocusNode,
      onChanged: (val){
        if (EmailValidator.validate(val)) {

          controller.isValidEmailS.value = true;
          controller.isValidEmail.value = true;
          controller.emailButton.value = true;
          controller.update();
          // setState(() {});
        }else{

          controller.isValidEmailS.value = false;
          controller.emailButton.value = false;
          controller.update();

        }
      },
      keyboardType: TextInputType.emailAddress,
      inputFormatters: [FilteringTextInputFormatter.deny(" "), FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9@.]"))],
      decoration:  InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: Dimensions.height10, vertical: Dimensions.height18),
        labelText: addEmail,
        labelStyle: TextStyle(color:controller.isValidEmail.isFalse ?ColourConstants.red: ColourConstants.primaryLight,fontWeight: FontWeight.w400),
        //floatingLabelStyle: TextStyle(color: !isValidPhone ? ColourConstants.red : ColourConstants.black54),
        errorText: controller.isValidEmail.isFalse ? emailValidation : null,
        suffixIconConstraints: BoxConstraints(
            minHeight: Dimensions.height25,
            minWidth: Dimensions.height25
        ),
        suffixIcon: GestureDetector(
          onTap: (){
            FocusScope.of(context).unfocus();
            if(EmailValidator.validate(emailEditingController.text)){
              controller.addEmail(emailEditingController.text, controller.jobPhotosModellist.first.jobNumber.toString(),1);
              emailEditingController.clear();
              controller.isValidEmail.value = true;

            }else{
              controller.isValidEmail.value = false;
            }
            controller.isValidEmailS.value = false;
            controller.emailButton.value = false;
            controller.update();
          },
          child: Padding(
            padding: EdgeInsets.only(right: Dimensions.height14,top: Dimensions.height5),
            child: Text(addCaps,style: TextStyle(color: controller.emailButton.isTrue ? ColourConstants.primaryLight : ColourConstants.grey),),
          ),
        ),
        enabledBorder:  OutlineInputBorder(
          borderRadius: BorderRadius.circular(0.0),
          borderSide:const BorderSide(width: 1, color: ColourConstants.primary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0.0),
          borderSide: const BorderSide(width: 1, color: ColourConstants.primary),
        ),
        errorBorder:  OutlineInputBorder(
          borderRadius: BorderRadius.circular(0.0),
          borderSide: const BorderSide(
              width: 1, color: ColourConstants.red),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
              width: 1,
              color: ColourConstants.red
          ),
        ),
      ),
    );
  }
}
