import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_sight_application/repository/web_service_response/all_oasis_resources_response.dart';
import 'package:on_sight_application/routes/app_pages.dart';
import 'package:on_sight_application/screens/onboarding/view_model/onboarding_resource_controller.dart';
import 'package:on_sight_application/utils/constants.dart';
import 'package:on_sight_application/utils/dimensions.dart';
import 'package:on_sight_application/utils/strings.dart';

class OnBoardingResourceScreen extends StatefulWidget {
  const OnBoardingResourceScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingResourceScreen> createState() => _OnBoardingResourceScreenState();
}

class _OnBoardingResourceScreenState extends State<OnBoardingResourceScreen> {

  int val = 1;
  TextEditingController searchController = TextEditingController();
  OnboardingResourceController resourceController = Get.find<OnboardingResourceController>();


  @override
  void initState() {
    super.initState();
    resourceController.searchedResourceList.clear();
    resourceController.searchedResourceList.refresh();
    searchController.clear();
    resourceController.update();
  }

  @override
  Widget build(BuildContext context) {
    Theme.of(context) == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: ColourConstants.white,
            size: Dimensions.height25,
          ),
          onPressed: () {
            Get.back();
          },
        ),

        elevation: 0.0,
        backgroundColor: ColourConstants.primary,
        title:  Text(selectResource, style: TextStyle(color: ColourConstants.white,fontWeight: FontWeight.bold, fontSize: Dimensions.font16)),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(Dimensions.height90),
          child: Container(
            alignment: Alignment.topLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: Dimensions.height50,
                  margin: EdgeInsets.only(right: Dimensions.height20,left: Dimensions.height20,top: Dimensions.height15),
                  child: TextField(
                    textAlignVertical: TextAlignVertical.bottom,
                    controller: searchController,
                    onChanged: onSearchTextChanged,
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: searchResource,
                      suffixIcon: Icon(Icons.search_outlined,color: Colors.white,),
                      hintStyle: TextStyle(color: ColourConstants.grey),
                      floatingLabelStyle: TextStyle(color: Colors.white),
                      // errorText: loginScreenController.isValidphone.isFalse ? phoneNumberValidation : null,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.white),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 1, color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 1, color: Colors.red),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: Dimensions.height30),
              ],),
          ),
        ),
      ),
      body: Obx(() {
        if (resourceController.searchedResourceList.length == 0 && searchController.text.isEmpty) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: resourceController.oasisResourceList.length,
            itemBuilder: (context, index) {
              var first = resourceController.oasisResourceList[index].firstName??"";
              var last = resourceController.oasisResourceList[index].lastName??"";
              var name = first+" "+last;
              return RadioListTile<int>(
                value: index,
                controlAffinity: ListTileControlAffinity.trailing,
                groupValue: resourceController.selectedResource.value,
                dense: true,
                toggleable: true,
                contentPadding: EdgeInsets.symmetric(vertical: 0,horizontal: Dimensions.height16),
                selectedTileColor: Get.isDarkMode ? Colors.white : ColourConstants.greenColor,
                activeColor: Get.isDarkMode ? Colors.white : ColourConstants.greenColor,
                onChanged: (ind) async {
                  if (index == resourceController.selectedResource.value)
                    ind = resourceController.selectedResource.value;
                    resourceController.selectedResource.value = ind!;
                    resourceController.oasisResourceList.refresh();
                    resourceController.update();
                    Get.toNamed(Routes.resourceDetails,arguments: resourceController.oasisResourceList[index]);
                },
                title: Text(name.toString(),style: TextStyle(fontSize: Dimensions.font14)),
                subtitle: Text((resourceController.oasisResourceList[index].ssn??"").characters.takeLast(4).toString(),style: TextStyle(fontSize: Dimensions.font12),),
              );
            },
          );
        }else if(resourceController.searchedResourceList.length == 0 && searchController.text.isNotEmpty){
          return Center(child: Text(noResultFound));
        }else{
          return ListView.builder(
            shrinkWrap: true,
            itemCount: resourceController.searchedResourceList.length,
            itemBuilder: (context, index) {
              return RadioListTile<int>(
                value: index,
                controlAffinity: ListTileControlAffinity.trailing,
                groupValue: resourceController.selectedResource.value,
                dense: true,
                toggleable: true,
                contentPadding: EdgeInsets.symmetric(vertical: 0,horizontal: Dimensions.height16),
                selectedTileColor: ColourConstants.greenColor,
                activeColor: ColourConstants.greenColor,
                onChanged: (ind) async {
                  if (index == resourceController.selectedResource.value)
                    ind = resourceController.selectedResource.value;
                  resourceController.selectedResource.value = ind!;
                  resourceController.searchedResourceList.refresh();
                  resourceController.update();
                  Get.toNamed(Routes.resourceDetails,arguments: resourceController.searchedResourceList[index]);
                },
                title: Text("${resourceController.searchedResourceList[index].firstName.toString()}"+" ${resourceController.searchedResourceList[index].lastName.toString()}",style: TextStyle(fontSize: Dimensions.font14),),
                subtitle: Text((resourceController.searchedResourceList[index].ssn??"").characters.takeLast(4).toString(),style: TextStyle(fontSize: Dimensions.font12),),
              );
            },
          );
        }
      }),
    );
  }




  onSearchTextChanged(String text) async {
    List<AllOasisResourcesResponse> localReversedList = [];
    resourceController.searchedResourceList.clear();
    if (text.isEmpty) {
      setState(() {});
      return;

    }

    resourceController.oasisResourceList.forEach((userDetail) {
      if ((userDetail.firstName??"").toLowerCase().contains(text) || (userDetail.lastName??"").toLowerCase().contains(text) || (userDetail.ssn??"").toLowerCase().contains(text)) {
        localReversedList.add(userDetail);
      }
    },
    );
    localReversedList.sort((a, b) => a.firstName.toString().compareTo(b.firstName.toString()));
    resourceController.searchedResourceList.addAll(localReversedList.reversed.toList());
    resourceController.searchedResourceList.refresh();
    resourceController.update();

    setState(() {});
  }
}