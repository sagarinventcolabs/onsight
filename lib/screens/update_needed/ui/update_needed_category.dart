

import 'package:flutter/material.dart';
import 'package:on_sight_application/generated/assets.dart';
import 'package:on_sight_application/utils/strings.dart';
import 'package:on_sight_application/utils/widgets/base_app_bar.dart';
import 'package:on_sight_application/utils/widgets/update_needed_category_card.dart';

class UpdateNeededCategory extends StatelessWidget {
  const UpdateNeededCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(title: "W-105681",),

      body:ListView(
        shrinkWrap: true,
        children: [
        UpdateNeededCatCard(title: dailyTime, darkSvgIcon: Assets.daily_time, lightSvgIcon: Assets.daily_time_white,),
        UpdateNeededCatCard(title: rankings, darkSvgIcon: Assets.ranking, lightSvgIcon: Assets.ranking_white,),
        UpdateNeededCatCard(title: jobPhotos, darkSvgIcon: Assets.job_photo, lightSvgIcon: Assets.jobphoto_white,),
        UpdateNeededCatCard(title: evaluation, darkSvgIcon: Assets.evalution, lightSvgIcon: Assets.evaluation_white,)
        ],
      )


      // ListView.builder(
      //   itemCount: 2,
      //   itemBuilder: (context, index){
      //     return UpdateNeededCatCard(title: dailyTime, darkSvgIcon: Assets.daily_time, lightSvgIcon: Assets.daily_time_white,);
      //   },
      // ),
    );
  }
}
