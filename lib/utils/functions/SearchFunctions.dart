

import 'package:on_sight_application/utils/constants.dart';
import 'package:on_sight_application/utils/shared_preferences.dart';

mixin SearchFunctions{

  List<String> getSuggestion(input){
    List<String> list = [];
    List<String> filterList = [];
    list = sp!.getStringList(Preference.ListAutoFill);
    for (var element in list) {
      if(element.toString().toLowerCase().contains(input.toString().toLowerCase())){
        filterList.add(element);
      }
    }
    return filterList;
  }


  List<String> getShowNumberSuggestion(input){
    List<String> list = [];
    List<String> filterList = [];
    list = sp!.getStringList(Preference.ShowNumberAutoFill);
    for (var element in list) {
      if(element.toLowerCase().contains(input.toString().toLowerCase())){
        filterList.add(element);
      }
    }
    return filterList;
  }

  List<String> getShowNameSuggestion(input){
    List<String> list = [];
    List<String> filterList = [];
    list = sp!.getStringList(Preference.ShowNameHistory);
    for (var element in list) {
      if(element.toLowerCase().contains(input.toString().toLowerCase())){
        filterList.add(element);
      }
    }
    return filterList;
  }

  List<String> getExhibitorNameSuggestion(input){
    List<String> list = [];
    List<String> filterList = [];
    list = sp!.getStringList(Preference.ExhibitorNameHistory);
    for (var element in list) {
      if(element.toLowerCase().contains(input.toString().toLowerCase())){
        filterList.add(element);
      }
    }
    return filterList;
  }
}