import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_sight_application/repository/database_managers/leadsheet_image_manager.dart';
import 'package:on_sight_application/screens/lead_sheet/view_model/lead_sheet_controller.dart';
import 'package:on_sight_application/utils/constants.dart';
import 'package:on_sight_application/utils/dimensions.dart';
import 'package:on_sight_application/utils/strings.dart';

class ExhibitorListingScreen extends StatefulWidget {
  const ExhibitorListingScreen({Key? key}) : super(key: key);

  @override
  State<ExhibitorListingScreen> createState() => _ExhibitorListingScreenState();
}

class _ExhibitorListingScreenState extends State<ExhibitorListingScreen> {

  int val = 1;
  TextEditingController searchController = TextEditingController();
  LeadSheetController leadSheetController = Get.find<LeadSheetController>();


  @override
  void initState() {
    super.initState();
    leadSheetController.searchedExhibitorsList.clear();
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
        backgroundColor: Get.isDarkMode?ColourConstants.black: ColourConstants.primary,
        title:  Text(leadSheetController.showNumber.value.toString(), style: TextStyle(color: ColourConstants.white,fontWeight: FontWeight.bold, fontSize: Dimensions.font16)),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(Dimensions.height100),
            child: Container(
              alignment: Alignment.topLeft,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.height20),
                  child: Row(children: [
                    Expanded(
                      child: Row(
                        children: [
                          SizedBox(
                            height: Dimensions.height25,
                            width: Dimensions.height25,
                            child: Theme(
                              data: ThemeData(
                                unselectedWidgetColor: ColourConstants.white, // Your color
                              ),
                              child: Radio<int>(
                                value: 1,
                                groupValue: val,
                                activeColor: ColourConstants.greenColor,
                                onChanged: (value) {
                                  leadSheetController.searchedExhibitorsList.clear();
                                  if (val != 1) {
                                    searchController.clear();
                                  }
                                  setState(() {
                                    val = value!;
                                    leadSheetController.list.sort((a,b)=>a.exhibitorName.toString().toLowerCase().compareTo(b.exhibitorName.toString().toLowerCase()));
                                    leadSheetController.update();
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(width: Dimensions.height8),
                          const Text(exhibitorName,style: const TextStyle(color: ColourConstants.white,fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: Dimensions.height25,
                            width: Dimensions.height25,
                            child: Theme(
                              data: ThemeData(
                                unselectedWidgetColor:
                                ColourConstants.white, // Your color
                              ),
                              child: Radio<int>(
                                value: 2,
                                groupValue: val,
                                activeColor: ColourConstants.greenColor,
                                onChanged: (value) {
                                  leadSheetController.searchedExhibitorsList.clear();
                                  if (val != 2) {
                                    searchController.clear();
                                  }
                                  setState(() {
                                    val = value!;
                                    leadSheetController.list.sort((a,b)=>a.boothNumber.toString().toLowerCase().compareTo(b.boothNumber.toString().toLowerCase()));
                                    leadSheetController.update();
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(width: Dimensions.height8),
                          const Text(boothNumber,style: TextStyle(color: ColourConstants.white,fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ],),
                ),
                Container(
                  height: Dimensions.height40,
                  margin: EdgeInsets.only(right: Dimensions.height20,left: Dimensions.height20,top: Dimensions.height15),
                  child: TextField(
                    textAlignVertical: TextAlignVertical.bottom,
                    controller: searchController,
                    onChanged: onSearchTextChanged,
                    style: const TextStyle(color: ColourConstants.white),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: exhibitorNameNumber,
                      suffixIcon: Icon(Icons.search_outlined,color: ColourConstants.white,),
                      hintStyle: TextStyle(color: ColourConstants.grey),
                      floatingLabelStyle: TextStyle(color: ColourConstants.white),
                      // errorText: loginScreenController.isValidphone.isFalse ? phoneNumberValidation : null,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: ColourConstants.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: ColourConstants.white),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 1, color: ColourConstants.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 1, color: ColourConstants.red),
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
        if (leadSheetController.searchedExhibitorsList.length == 0 && searchController.text.isEmpty) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: leadSheetController.list.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: Dimensions.height60,
                  child: RadioListTile<int>(
                    value: index,
                    tileColor: Get.isDarkMode?ColourConstants.unselectedContainerColorDarkMode:Colors.transparent,
                    controlAffinity: ListTileControlAffinity.trailing,
                    subtitle: Text(leadSheetController.list[index].boothNumber.toString(),style: TextStyle(fontSize: Dimensions.font11)),
                    groupValue: leadSheetController.selectedExhibitor.value,
                    dense: true,
                    toggleable: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 0,horizontal: Dimensions.height16),
                    selectedTileColor: ColourConstants.primary,
                    activeColor: ColourConstants.primary,
                    onChanged: (ind) async {
                      leadSheetController.selectedExhibitorModel.clear();
                      if (index != leadSheetController.selectedExhibitor.value) {
                        leadSheetController.selectedExhibitorModel.add(leadSheetController.list[ind!]);
                        LeadSheetImageManager manager = LeadSheetImageManager();
                        leadSheetController.selectedExhibitor.value = ind;
                        leadSheetController.showExhibitor.value = true;
                        leadSheetController.selectedExhibitorModel.first.yetToSubmit = await manager.getYetToSubmitCount(leadSheetController.selectedExhibitorModel.first.exhibitorId.toString(), leadSheetController.showNumber.value);
                        if(leadSheetController.selectedExhibitorModel.first.yetToSubmit==null){
                          leadSheetController.buttonSubmit.value = false;
                        }else {
                          if (leadSheetController.selectedExhibitorModel.first.yetToSubmit! > 0) {
                            leadSheetController.buttonSubmit.value = true;
                          } else {
                            leadSheetController.buttonSubmit.value = false;
                          }
                        }
                        leadSheetController.list.refresh();
                        leadSheetController.update();
                        Get.back();
                      }
                      else{
                        ind = index;

                        leadSheetController.selectedExhibitorModel.add(leadSheetController.list[ind]);
                        LeadSheetImageManager manager = LeadSheetImageManager();
                        leadSheetController.selectedExhibitor.value = leadSheetController.selectedExhibitor.value;
                        leadSheetController.showExhibitor.value = true;
                        leadSheetController.selectedExhibitorModel.first.yetToSubmit = await manager.getYetToSubmitCount(leadSheetController.selectedExhibitorModel.first.exhibitorId.toString(), leadSheetController.showNumber.value);
                        if(leadSheetController.selectedExhibitorModel.first.yetToSubmit==null){
                          leadSheetController.buttonSubmit.value = false;
                        }else {
                          if (leadSheetController.selectedExhibitorModel.first.yetToSubmit! > 0) {
                            leadSheetController.buttonSubmit.value = true;
                          } else {
                            leadSheetController.buttonSubmit.value = false;
                          }
                        }

                        leadSheetController.list.refresh();
                        leadSheetController.update();
                        Get.back();
                      }
                    },
                    title: Text(leadSheetController.list[index].exhibitorName.toString(),style: TextStyle(fontSize: Dimensions.font14),),
                  ),
                ),
              );
            },
          );
        } else {
          if (leadSheetController.searchedExhibitorsList.length == 0 && searchController.text.isNotEmpty) {
            return const Center(child: Text(noExhibitorFound),);
          }else{
            return ListView.builder(

              shrinkWrap: true,
              itemCount: leadSheetController.searchedExhibitorsList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.all(Dimensions.height8),
                  child: SizedBox(
                    height: Dimensions.height60,
                    child: RadioListTile<int>(
                      value: index,
                      tileColor: Get.isDarkMode?ColourConstants.unselectedContainerColorDarkMode:Colors.transparent,
                      controlAffinity: ListTileControlAffinity.trailing,
                      subtitle: Text(leadSheetController.searchedExhibitorsList[index].boothNumber.toString(),style: TextStyle(fontSize: Dimensions.font11)),
                      groupValue: leadSheetController.selectedExhibitor.value,
                      dense: true,
                      toggleable: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 0,horizontal: Dimensions.height16),
                      selectedTileColor: ColourConstants.primary,
                      activeColor: ColourConstants.primary,
                      onChanged: (ind) async {
                        leadSheetController.selectedExhibitorModel.clear();
                       if (index != leadSheetController.selectedExhibitor.value) {
                         leadSheetController.selectedExhibitorModel.add(leadSheetController.searchedExhibitorsList[ind!]);
                          LeadSheetImageManager manager = LeadSheetImageManager();
                          leadSheetController.selectedExhibitor.value = ind;
                          leadSheetController.showExhibitor.value = true;
                          leadSheetController.searchedExhibitorsList[ind].yetToSubmit = await manager.getYetToSubmitCount(leadSheetController.searchedExhibitorsList[index].exhibitorId.toString(), leadSheetController.showNumber.value);
                          if(leadSheetController.searchedExhibitorsList[ind].yetToSubmit==null){
                            leadSheetController.buttonSubmit.value = false;
                          } else {
                            if (leadSheetController.searchedExhibitorsList[ind].yetToSubmit! > 0) {
                              leadSheetController.buttonSubmit.value = true;
                            } else {
                              leadSheetController.buttonSubmit.value = false;
                            }
                          }
                          leadSheetController.searchedExhibitorsList.refresh();
                          leadSheetController.update();
                          Get.back();
                        }else{
                          ind = index;
                          leadSheetController.selectedExhibitorModel.add(leadSheetController.searchedExhibitorsList[ind]);
                          LeadSheetImageManager manager = LeadSheetImageManager();
                          leadSheetController.selectedExhibitor.value = leadSheetController.selectedExhibitor.value;
                          leadSheetController.showExhibitor.value = true;
                          leadSheetController.searchedExhibitorsList[leadSheetController.selectedExhibitor.value].yetToSubmit = await manager.getYetToSubmitCount(leadSheetController.searchedExhibitorsList[index].exhibitorId.toString(), leadSheetController.showNumber.value);
                          if(leadSheetController.searchedExhibitorsList[leadSheetController.selectedExhibitor.value].yetToSubmit==null){
                            leadSheetController.buttonSubmit.value = false;
                          }else {
                            if (leadSheetController.searchedExhibitorsList[leadSheetController.selectedExhibitor.value].yetToSubmit! > 0) {
                              leadSheetController.buttonSubmit.value = true;
                            } else {
                              leadSheetController.buttonSubmit.value = false;
                            }
                          }
                          print(leadSheetController.searchedExhibitorsList[leadSheetController
                              .selectedExhibitor.value].yetToSubmit.toString());
                          leadSheetController.searchedExhibitorsList.refresh();
                          leadSheetController.update();
                          Get.back();
                        }
                      },
                      title: Text(leadSheetController.searchedExhibitorsList[index].exhibitorName.toString(),style: TextStyle(fontSize: Dimensions.font14)),
                    ),
                  ),
                );
              },
            );
          }
        }
      }),
    );
  }


  onSearchTextChanged(String text) async {
    leadSheetController.searchedExhibitorsList.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    leadSheetController.list.forEach((userDetail) {
      if (val == 2) {
        if ((userDetail.boothNumber??"").toLowerCase().contains(text)) {
          leadSheetController.searchedExhibitorsList.add(userDetail);
        }
      }else{
        if ((userDetail.exhibitorName??"").toLowerCase().contains(text)) {
          leadSheetController.searchedExhibitorsList.add(userDetail);
        }
      }
     },
    );

    setState(() {});
  }
}
