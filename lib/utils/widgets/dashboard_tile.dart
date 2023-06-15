import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:on_sight_application/repository/database_managers/dashboard_manager.dart';
import 'package:on_sight_application/repository/web_service_response/security_flags_model.dart';
import 'package:on_sight_application/screens/dashboard/view_model/app_update_controller.dart';
import 'package:on_sight_application/utils/constants.dart';
import 'package:on_sight_application/utils/dialogs.dart';
import 'package:on_sight_application/utils/dimensions.dart';
import 'package:on_sight_application/utils/functions/functions.dart';
import 'package:on_sight_application/utils/shared_preferences.dart';
import 'package:on_sight_application/utils/strings.dart';

class DashboardTile extends StatefulWidget {
  final String? title;
  final String? darkSvgIcon;
  final String? lightSvgIcon;
  final String? routeName;

  const DashboardTile({Key? key,this.title,this.darkSvgIcon,this.lightSvgIcon,this.routeName}) : super(key: key);

  @override
  State<DashboardTile> createState() => _DashboardTileState();
}

class _DashboardTileState extends State<DashboardTile> {
  AppUpdateController appUpdateController = Get.find<AppUpdateController>();

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: (){
        Get.toNamed(widget.routeName??"")?.then((value){
          DateTime dt1 = DateTime.parse((sp?.getString(Preference.DIALOG_TIMESTAMP)??DateTime(DateTime.now().year,DateTime.now().month-2,DateTime.now().day).toString()));
          DateTime dt2 = DateTime.parse(DateTime.now().toString());
          print(daysBetween(dt1,dt2).toString());
          if (daysBetween(dt1,dt2) >= 30) {
            if((sp?.getInt(Preference.ACTIVITY_TRACKER)??0)>=3){
              sp?.putInt(Preference.ACTIVITY_TRACKER, 0);
              sp?.putString(Preference.DIALOG_TIMESTAMP, DateTime.now().toString());
              showRatingDialog(context);
            }
          }
        });
      },
      child: StreamBuilder(
         // future:  DashboardManager().getMenuVisibility(widget.title!),
          stream:  dataStream,
        builder: (context, snapshot) {
            var j = 0;
            bool visibility = false;
            print(snapshot.connectionState);
            List<SecurityFlagsModel> list = [];
            if(snapshot.hasData){
            list = snapshot.data as List<SecurityFlagsModel>;
            if(widget.title!=updateNeeded) {
              var i = list.indexWhere((element) =>
              element.menuItems == widget.title!);
              if(i!=-1) {

                visibility = list[i].isAllowed??false;
              }
            }else{
              visibility  = true;
            }

            // switch(widget.title!){
            //
            //   case jobUpdates:
            //     visibility  = list[i].isAllowed==1?true:false;
            //   //  visibility  = snapshot.data==1?true:false;
            //   //  appUpdateController.update();
            //     break;
            //   case projectEvaluation:
            //     visibility  = list[i].isAllowed==1?true:false;
            //    // visibility =  snapshot.data==1?true:false;
            //    // appUpdateController.update();
            //     break;
            //   case leadSheet:
            //     visibility  = list[i].isAllowed==1?true:false;
            //    // visibility =  snapshot.data==1?true:false;
            //    // appUpdateController.update();
            //     break;
            //   case promoPictures:
            //     print(list[i].isAllowed);
            //     visibility  = list[i].isAllowed==1?true:false;
            //   //  visibility = snapshot.data==1?true:false;
            //   //  appUpdateController.update();
            //     break;
            //   case onboarding:
            //     visibility  = list[i].isAllowed==1?true:false;
            //   //  visibility =  snapshot.data==1?true:false;
            //   //  appUpdateController.update();
            //     break;
            //   case FieldIssue:
            //     visibility  = list[i].isAllowed==1?true:false;
            //    // visibility = snapshot.data==1?true:false;
            //   //  appUpdateController.update();
            //     break;
            //
            //   case updateNeeded:
            //
            //     visibility =true;
            //     //  appUpdateController.update();
            //     break;
            //
            // }
          }
          return Visibility(
            visible: visibility,
            child: Container(
              height: MediaQuery.of(context).size.height/12,
              margin: EdgeInsets.only(top: Dimensions.height15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(Dimensions.radius10)),
                  border: Border.all(color: Theme.of(context).dividerColor),
                  color:Theme.of(context).cardColor
              ),
              child: Padding(
                padding: EdgeInsets.only(left: Dimensions.width15),
                child: Row(
                  children: [
                    SvgPicture.asset(Get.isDarkMode ? widget.darkSvgIcon??"" : widget.lightSvgIcon??"", height: Dimensions.height40),
                    Padding(
                      padding: EdgeInsets.only(left: Dimensions.width10),
                      child: Text(widget.title??"", style: TextStyle(fontWeight: FontWeight.bold, fontSize: Dimensions.font16)),
                    ),
                    Spacer(),
                   list.isNotEmpty? Visibility(
                      visible: widget.title == updateNeeded && list[j].UpdateWO!=null && list[j].UpdateWO!>0,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 18.0),
                        child: Center(
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.all(Radius.circular(30))
                            ),
                            child: Center(
                              child: Text(
                                list[j].UpdateWO.toString(),style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ):Container(),

                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }
  
  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inDays);
  }
}
