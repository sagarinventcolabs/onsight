

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_sight_application/utils/dimensions.dart';
import 'package:on_sight_application/utils/strings.dart';
import 'package:on_sight_application/utils/widgets/base_app_bar.dart';
import 'package:on_sight_application/utils/widgets/missing_rating_card.dart';

class MissingDailyTime extends StatelessWidget {
  const MissingDailyTime({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    return Scaffold(
      backgroundColor: Get.isPlatformDarkMode?Colors.black: Colors.white,
      appBar: BaseAppBar(title: testJobNumber,),
      body: ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.all(21),
            child: Text(missingDailyTime, style: TextStyle(fontWeight: FontWeight.w500, fontSize: Dimensions.font16),),
          ),
          ListView.builder(
              shrinkWrap: true,
              itemCount: 2,
              itemBuilder: (context, index){

            return MissingStarRattingCard();
          })
        ],
      ),

    );
  }
}
