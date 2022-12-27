import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_sight_application/routes/app_pages.dart';
import 'package:on_sight_application/screens/field_issue/view_model/field_issue_controller.dart';
import 'package:on_sight_application/utils/constants.dart';
import 'package:on_sight_application/utils/dimensions.dart';
import 'package:on_sight_application/utils/strings.dart';


class FieldIssueCategoryScreen extends StatefulWidget {
  const FieldIssueCategoryScreen({Key? key}) : super(key: key);

  @override
  State<FieldIssueCategoryScreen> createState() => _FieldIssueCategoryScreenState();
}

class _FieldIssueCategoryScreenState extends State<FieldIssueCategoryScreen> {

  FieldIssueController fieldIssueController = Get.find<FieldIssueController>();


  @override
  Widget build(BuildContext context) {
    Theme.of(context) == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Get.isDarkMode ? ColourConstants.white :  ColourConstants.primary,
            size: Dimensions.height25,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        elevation: 0.0,
        backgroundColor: Get.isDarkMode ? ColourConstants.black :  ColourConstants.white,
        title: Text(chooseCategory,
            style: TextStyle(
                color: Get.isDarkMode ? ColourConstants.white : ColourConstants.primary,
                fontWeight: FontWeight.bold,
                fontSize: Dimensions.font18),
        ),
      ),

      body: Obx(()=> SingleChildScrollView(
          child: Column(
            children: [
               Container(
                 width: MediaQuery.of(context).size.width,
                 padding: EdgeInsets.symmetric(vertical: Dimensions.height10,horizontal: Dimensions.height18),
                 color: ColourConstants.primary,
                child: Text(commentCategory, style: TextStyle(color: ColourConstants.white, fontSize: Dimensions.font12),),
              ),
              SizedBox(height: Dimensions.height20,),

              ListView.builder(
                  shrinkWrap: true,
                  itemCount: fieldIssueController.categoryList.length,
                  itemBuilder: (context, i){
                    return GestureDetector(onTap: (){
                      fieldIssueController.fieldIssueChosedCategory.value = fieldIssueController.categoryList[i].name??"";
                      fieldIssueController.selectedCat.value = i;
                      fieldIssueController.enableButtonCategory.value = true;
                      fieldIssueController.categoryList.refresh();
                      fieldIssueController.update();
                      fieldIssueController.requestModel.value.categoryId = fieldIssueController.categoryList[i].id;
                      fieldIssueController.requestModel.refresh();
                      if (Get.arguments == Routes.fieldIssueDetailScreen) {
                        Get.toNamed(Routes.fieldIssueCommentScreen);
                      } else {
                        Get.toNamed(Routes.fieldIssuePhotoScreen);
                      }
                    },child: categoryWidget(i));
                  },
              ),
            ],
          ),
        ),
      )
    );
  }

/// Choose Category Widget
  Container categoryWidget (index){
    return Container(
      margin: EdgeInsets.symmetric(vertical: Dimensions.height5,horizontal: Dimensions.height16),
      padding: EdgeInsets.symmetric(vertical: Dimensions.height16,horizontal: Dimensions.height10),
      decoration: BoxDecoration(
        color: Get.isDarkMode ? Colors.grey.shade800 : null,
          border: Border.all(color: Get.isDarkMode ? Colors.transparent : ColourConstants.borderGreyColor,width: 1)
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(fieldIssueController.categoryList[index].name.toString() ,
                  style:TextStyle(
                      color: fieldIssueController.selectedCat.value==index ? Get.isDarkMode ? ColourConstants.white : ColourConstants.black : Get.isDarkMode ? ColourConstants.white : ColourConstants.grey,
                      fontWeight: FontWeight.w400,
                      fontSize: Dimensions.font12
                  )
              ),
            ],
          ),
        ],
      ),
    );
  }


  @override
  dispose(){
    fieldIssueController.enableButtonCategory.value = false;
    fieldIssueController.selectedCat.value = 11111;
    fieldIssueController.update();
    super.dispose();

  }
}
