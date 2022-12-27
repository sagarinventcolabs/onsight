import 'package:get/get.dart';
import 'package:on_sight_application/generated/assets.dart';
import 'package:on_sight_application/routes/app_pages.dart';
import 'package:on_sight_application/utils/strings.dart';

///this is the view_model to handle all the business logic
///for app info screen
class AppInfoSlideController extends GetxController {
  // Local images to slide list
  RxInt currentIndex = 0.obs;

  updateCurrentIndex(index){

    currentIndex.value = index;
    update();
    refresh();
  }
// Local images to slide list
  List<String> slideImages = [
    Assets.imagesSlide11,
    Assets.imagesSlide22,
    Assets.imagesSlide33
  ];

  List<String> slideTitle = [
    slideTitleString,
    slideTitleString,
    slideTitleString,
  ];

  List<String> slideSubTitle = [
    slideSubTitleString,
    slideSubTitleString,
    slideSubTitleString
  ];

  navigateToLogin() {
    Get.offAllNamed(Routes.loginScreen);
  }
}
