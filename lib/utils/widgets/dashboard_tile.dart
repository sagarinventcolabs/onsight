import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:on_sight_application/utils/constants.dart';
import 'package:on_sight_application/utils/dialogs.dart';
import 'package:on_sight_application/utils/dimensions.dart';
import 'package:on_sight_application/utils/shared_preferences.dart';

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
              )
            ],
          ),
        ),
      ),
    );
  }
  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inDays);
  }
}
