import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_sight_application/repository/web_service_response/all_oasis_resources_response.dart';
import 'package:on_sight_application/routes/app_pages.dart';
import 'package:on_sight_application/screens/onboarding/view_model/onboarding_resource_controller.dart';
import 'package:on_sight_application/utils/constants.dart';
import 'package:on_sight_application/utils/debounce_search.dart';
import 'package:on_sight_application/utils/dimensions.dart';
import 'package:on_sight_application/utils/strings.dart';
import 'package:on_sight_application/utils/widgets/resource_card.dart';

class OnBoardingResourceScreenNew extends StatefulWidget {
  const OnBoardingResourceScreenNew({Key? key}) : super(key: key);

  @override
  State<OnBoardingResourceScreenNew> createState() => _OnBoardingResourceScreenNewState();
}

class _OnBoardingResourceScreenNewState extends State<OnBoardingResourceScreenNew> {

  int val = 1;
  TextEditingController searchController = TextEditingController();
  OnboardingResourceController resourceController = Get.find<OnboardingResourceController>();
  final debouncer = Debouncer(milliseconds: 1000);

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
    Theme.of(context);
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
                  margin: EdgeInsets.only(right: Dimensions.height10,left: Dimensions.height10,top: Dimensions.height15),
                  child: TextField(
                    textAlignVertical: TextAlignVertical.bottom,
                    controller: searchController,

                    onChanged: (val){
                      if(searchController.text.isEmpty){
                        resourceController.oasisResourceList.clear();
                        resourceController.update();
                      }
                      if(val.length>10){
                        searchController.text = val.substring(0, (searchController.text.length-1));
                        searchController.selection = TextSelection.fromPosition(TextPosition(offset: searchController.text.length));
                      }
                    },
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: searchResource,
                      suffixIcon: GestureDetector(
                          onTap: () async {
                            if(searchController.text.length>0) {
                              await resourceController.findOasisResourcesApi(
                                  searchController.text.toString());
                            }
                          },
                          child: Icon(Icons.search_outlined,color: Colors.white,)),
                      hintStyle: TextStyle(color: ColourConstants.grey, fontSize: 14),
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
        if (resourceController.oasisResourceList.isNotEmpty) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: resourceController.oasisResourceList.length,
            itemBuilder: (context, index) {
              var first = resourceController.oasisResourceList[index].firstName??"";
              var last = resourceController.oasisResourceList[index].lastName??"";
              var name = first+" "+last;
              return GestureDetector(
                  onTap: (){
                    resourceController.oasisResourceList[index].route = Routes.onBoardingResourceScreenNew;
                    Get.toNamed(Routes.resourceDetailsNew,arguments: resourceController.oasisResourceList[index]);
                  },
                  child: ResourceCard(firstNameValue: resourceController.oasisResourceList[index].firstName??"",lastNameValue: resourceController.oasisResourceList[index].lastName??"",mobileValue: resourceController.oasisResourceList[index].mobilePhone??""));

            },
          );
        }else if(resourceController.oasisResourceList.isEmpty){
          return Center(child: Text(searchController.text.isEmpty?searchResource2:noResultFound));
        }else{
          return ListView.builder(
            shrinkWrap: true,
            itemCount: resourceController.searchedResourceList.length,
            itemBuilder: (context, index) {
              return ResourceCard(firstNameValue: resourceController.searchedResourceList[index].firstName??"",lastNameValue: resourceController.searchedResourceList[index].lastName??"",mobileValue: resourceController.searchedResourceList[index].mobilePhone??"");
            },
          );
        }
      }),
    );
  }




  onSearchTextChanged(String text) async {
    if(text.isNotEmpty)
    debouncer.run(() async {
      await resourceController.findOasisResourcesApi(text);
    });
    // List<AllOasisResourcesResponse> localReversedList = [];
    // resourceController.searchedResourceList.clear();
    // if (text.isEmpty) {
    //   setState(() {});
    //   return;
    //
    // }
    //
    // resourceController.oasisResourceList.forEach((userDetail) {
    //   if ((userDetail.firstName??"").toLowerCase().contains(text) || (userDetail.lastName??"").toLowerCase().contains(text) || (userDetail.ssn??"").toLowerCase().contains(text)) {
    //     localReversedList.add(userDetail);
    //   }
    // },
    // );
    // localReversedList.sort((a, b) => a.firstName.toString().compareTo(b.firstName.toString()));
    // resourceController.searchedResourceList.addAll(localReversedList.reversed.toList());
    // resourceController.searchedResourceList.refresh();
    // resourceController.update();
    //
    // setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    resourceController.oasisResourceList.clear();
  }
}