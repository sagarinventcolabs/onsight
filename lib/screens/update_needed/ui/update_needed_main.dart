

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_sight_application/utils/strings.dart';
import 'package:on_sight_application/utils/widgets/base_app_bar.dart';
import 'package:on_sight_application/utils/widgets/update_needed_card.dart';

class UpdateNeeded extends StatelessWidget {
  const UpdateNeeded({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    return Scaffold(
      backgroundColor: Get.isPlatformDarkMode?Colors.black: Colors.white,
      appBar: BaseAppBar(title: updateNeeded,),

      body: ListView.builder(
        itemCount: 2,
        itemBuilder: (context, index){
          return UpdateNeededCard();
        },
      ),
    );
  }
}
