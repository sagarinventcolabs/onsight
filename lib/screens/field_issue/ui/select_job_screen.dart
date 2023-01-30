import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_sight_application/generated/assets.dart';
import 'package:on_sight_application/routes/app_pages.dart';
import 'package:on_sight_application/screens/field_issue/view_model/field_issue_controller.dart';
import 'package:on_sight_application/utils/constants.dart';
import 'package:on_sight_application/utils/dimensions.dart';
import 'package:on_sight_application/utils/strings.dart';
import 'package:on_sight_application/utils/widgets/text_row.dart';

class SelectJobScreen extends StatefulWidget {
  const SelectJobScreen({Key? key}) : super(key: key);

  @override
  State<SelectJobScreen> createState() => _SelectJobScreenState();
}

class _SelectJobScreenState extends State<SelectJobScreen> {

  var selected = "0";
  FieldIssueController controller = Get.find<FieldIssueController>();

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Image.asset(
            Assets.appBarLeadingButton,
            color: Get.isDarkMode ? ColourConstants.white : ColourConstants.primary,
            height: Dimensions.height25,
            width: Dimensions.height25,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        elevation: 0.0,
        backgroundColor: Get.isDarkMode ? ColourConstants.black : ColourConstants.white,
        title:  Text(selectWorkOrder,
            style: TextStyle(
                color: Get.isDarkMode ? ColourConstants.white : ColourConstants.primary,
                fontWeight: FontWeight.bold,
                fontSize: Dimensions.font16)),
      ),
      bottomNavigationBar:  GestureDetector(
        onTap: () {
        Get.offAndToNamed(Routes.fieldIssueDetailScreen);
        },
        child: Container(
          height: Dimensions.height50,
          margin: EdgeInsets.only(left: Dimensions.height35, right: Dimensions.height35, bottom: Dimensions.height16, top: Dimensions.height10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(Dimensions.height8)),
              color: ColourConstants.primary),
          child:  Center(
              child: Text(
                next,
                style: TextStyle(
                    color: ColourConstants.white,
                    fontWeight: FontWeight.w300,
                    fontSize: Dimensions.font16),
              )),
        ),

      ),
      body: ListView.builder(
        itemCount: controller.list.length,
        itemBuilder: (context, index){
          return Padding(padding: EdgeInsets.all(Dimensions.height20),child: Container(
            decoration: BoxDecoration(
              color: Get.isDarkMode ? (index.toString()) == selected ? Colors.grey.shade800 : Colors.grey.shade900 : Color(0xFFF8F5FC),
                borderRadius: BorderRadius.all(Radius.circular(Dimensions.height5)),
                border: Border.all(width: 1.0, color: Get.isDarkMode ? (index.toString()) == selected ? ColourConstants.grey : Colors.transparent : ColourConstants.grey)
            ),
            child: Column(
              children: [
             Padding(padding: EdgeInsets.all(Dimensions.height10),
               child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Text(controller.list[index].woNumber.toString(),
                   style: TextStyle(color: Get.isDarkMode ? ColourConstants.white : ColourConstants.primary, fontSize: Dimensions.font16, fontWeight: FontWeight.w600),),
                 Radio(
                   value: index.toString(),
                   groupValue: selected,
                   onChanged: (val){
                    setState(() {
                      selected = val.toString();
                      controller.requestModel.value.showNumber = controller.list[index].showNumber;
                      controller.requestModel.value.workOrderNumber = controller.list[index].woNumber;
                      controller.requestModel.refresh();
                    });
                   },
                   activeColor: Colors.green,

                 ),
               ],
              ),
             ),
                TextRow(title: showName,value: controller.list[index].showName??""),
                TextRow(title: showNumber,value: controller.list[index].showNumber??""),
                TextRow(title: exhibitorName,value: controller.list[index].exhibitorName??""),
              ],
            ),
          ),);
        },
      ),
    );
  }


  Container jobDetailsRow(key, value, [isEmailPhone]) {
    return Container(
      padding:  EdgeInsets.symmetric(vertical: Dimensions.height8, horizontal: Dimensions.height16),
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
                    fontSize: Dimensions.font14)),
          ),
          SizedBox(width: Dimensions.height20),
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
                    fontSize: Dimensions.font14)),
          )
        ],
      ),
    );
  }

}
