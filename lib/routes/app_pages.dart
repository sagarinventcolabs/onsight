import 'package:get/get.dart' show GetPage;
import 'package:on_sight_application/screens/about_us/about_us_screen.dart';
import 'package:on_sight_application/screens/app_info_slide/ui/app_info_slide_screen.dart';
import 'package:on_sight_application/screens/dashboard/ui/dashboard_screen.dart';
import 'package:on_sight_application/screens/field_issue/ui/comment_screen.dart';
import 'package:on_sight_application/screens/field_issue/ui/field_issue_category_screen.dart';
import 'package:on_sight_application/screens/field_issue/ui/field_issue_new_detail_screen.dart';
import 'package:on_sight_application/screens/field_issue/ui/field_issues_screen.dart';
import 'package:on_sight_application/screens/field_issue/ui/photo_screen.dart';
import 'package:on_sight_application/screens/field_issue/ui/select_job_screen.dart';
import 'package:on_sight_application/screens/job_photos/ui/job_photos_details_screenTemp.dart';
import 'package:on_sight_application/screens/job_photos/ui/job_photos_screen.dart';
import 'package:on_sight_application/screens/job_photos/ui/upload_job_photos_note.dart';
import 'package:on_sight_application/screens/lead_sheet/ui/exhibitor_listing_screen.dart';
import 'package:on_sight_application/screens/lead_sheet/ui/exhibitor_screen.dart';
import 'package:on_sight_application/screens/lead_sheet/ui/lead_sheet_detail_screen.dart';
import 'package:on_sight_application/screens/lead_sheet/ui/lead_sheet_photo_notes.dart';
import 'package:on_sight_application/screens/lead_sheet/ui/lead_sheet_screen.dart';
import 'package:on_sight_application/screens/login/ui/email_login_screen.dart';
import 'package:on_sight_application/screens/login/ui/login_screen.dart';
import 'package:on_sight_application/screens/onboarding/ui/edit_resource.dart';
import 'package:on_sight_application/screens/onboarding/ui/onboarding_new_screen.dart';
import 'package:on_sight_application/screens/onboarding/ui/onboarding_photo_screen.dart';
import 'package:on_sight_application/screens/onboarding/ui/onboarding_new_registration.dart';
import 'package:on_sight_application/screens/onboarding/ui/onboarding_resource_screen.dart';
import 'package:on_sight_application/screens/onboarding/ui/onboarding_screen.dart';
import 'package:on_sight_application/screens/onboarding/ui/onboarding_upload_photos.dart';
import 'package:on_sight_application/screens/onboarding/ui/resource_details.dart';
import 'package:on_sight_application/screens/onboarding/ui/resource_details_new.dart';
import 'package:on_sight_application/screens/project_evaluation/ui/project_evaluation_details_screen.dart';
import 'package:on_sight_application/screens/project_evaluation/ui/project_evaluation_install_screen.dart';
import 'package:on_sight_application/screens/project_evaluation/ui/project_evaluation_screen.dart';
import 'package:on_sight_application/screens/promo_pictures/ui/promo_picture_screen.dart';
import 'package:on_sight_application/screens/promo_pictures/ui/upload_promo_pictures_screen.dart';
import 'package:on_sight_application/screens/setting/ui/setting_screen.dart';
import 'package:on_sight_application/screens/splash/splash_screen.dart';
import 'package:on_sight_application/screens/two_factor_authentication/ui/two_step_screen.dart';
import 'package:on_sight_application/screens/update_profile/ui/update_profile_screen.dart';
import 'package:on_sight_application/screens/user_detail/ui/user_detail_screen.dart';
import 'package:on_sight_application/screens/verify_otp/ui/verify_email_otp_screen.dart';
import 'package:on_sight_application/screens/verify_otp/ui/verify_otp_screen.dart';
import 'package:on_sight_application/screens/web_view/my_web_view.dart';
part 'approute.dart';



class AppPages {
String whereCome="0";

  static final routes = [
    GetPage(name: Routes.splashScreen, page: ()=>  const SplashScreen()),
    GetPage(name: Routes.appInfoSlideScreen, page: ()=>  AppInfoSlideScreen()),
    GetPage(name: Routes.loginScreen, page: ()=>  const LoginScreen()),
    GetPage(name: Routes.emailLoginScreen, page: ()=>  const EmailLoginScreen()),
    GetPage(name: Routes.verifyOtpScreen, page: ()=>  VerifyOtpScreen()),
    GetPage(name: Routes.verifyEmailOtpScreen, page: ()=>  VerifyEmailOtpScreen()),
    GetPage(name: Routes.userDetailScreen, page: ()=>  const UserDetailScreen()),
    GetPage(name: Routes.dashboardScreen, page: ()=>  const DashboardScreen()),
    GetPage(name: Routes.jobPhotosScreen, page: ()=>  const JobPhotosScreen()),
    GetPage(name: Routes.jobPhotosDetailsScreen, page: ()=>  const JobPhotosDetailsScreenTemp()),
    GetPage(name: Routes.uploadJobPhotosNote, page: ()=>  const UploadJobPhotosNote()),
    GetPage(name: Routes.projectEvaluationScreen, page: ()=>  const ProjectEvaluationScreen()),
    GetPage(name: Routes.projectEvaluationDetailsScreen, page: ()=>  const ProjectEvaluationDetailsScreen()),
    GetPage(name: Routes.projectEvaluationInstallScreen, page: ()=>  const ProjectEvaluationInstallScreen()),
    GetPage(name: Routes.myWebView, page: ()=>  MyWebView()),
    GetPage(name: Routes.leadSheetScreen, page: ()=>  const LeadSheetScreen()),
    GetPage(name: Routes.leadSheetDetailScreen, page: ()=>  const LeadSheetDetailScreen()),
    GetPage(name: Routes.exhibitorListingScreen, page: ()=>  const ExhibitorListingScreen()),
    GetPage(name: Routes.addExhibitorScreen, page: ()=>  const ExhibitorScreen()),
    GetPage(name: Routes.fieldIssues, page: ()=>  const FieldIssues()),
    GetPage(name: Routes.fieldIssueDetailScreen, page: ()=>  const FieldIssueDetailScreen()),
    GetPage(name: Routes.fieldIssueCategoryScreen, page: ()=>  const FieldIssueCategoryScreen()),
    GetPage(name: Routes.fieldIssueCommentScreen, page: ()=>  const FieldIssueCommentScreen()),
    GetPage(name: Routes.fieldIssuePhotoScreen, page: ()=>  const FieldIssuePhotoScreen()),
    GetPage(name: Routes.settingScreen, page: ()=> const  SettingScreen()),
    GetPage(name: Routes.updateProfileScreen, page: ()=>  const UpdateProfileScreen()),
    GetPage(name: Routes.leadSheetPhotosNote, page: ()=>  const LeadSheetPhotosNote()),
    GetPage(name: Routes.aboutUsScreen, page: ()=>  const AboutUsScreen()),
    GetPage(name: Routes.onBoardingScreen, page: ()=>  const OnBoardingScreen()),
    GetPage(name: Routes.onBoardingNewScreen, page: ()=>  const OnBoardingNewScreen()),
    GetPage(name: Routes.onBoardingResourceScreen, page: ()=>  const OnBoardingResourceScreen()),
    GetPage(name: Routes.resourceDetails, page: ()=>  const ResourceDetails()),
    GetPage(name: Routes.resourceDetailsNew, page: ()=>  const ResourceDetailsNew()),
    GetPage(name: Routes.onBoardingRegistration, page: ()=>  const OnboardingNewRegistration()),
    GetPage(name: Routes.selectJobScreen, page: ()=>  const SelectJobScreen()),
    GetPage(name: Routes.promoPictureScreen, page: ()=>  const PromoPictureScreen()),
    GetPage(name: Routes.uploadPromoPictureScreen, page: ()=>  const UploadPromoPictureScreen()),
    GetPage(name: Routes.onBoardingUploadPhotosScreen, page: ()=>  const OnBoardingUploadPhotosScreen()),
    GetPage(name: Routes.onBoardingPhotoScreen, page: ()=>  const OnBoardingPhotoScreen()),
    GetPage(name: Routes.introductionTwoStep, page: ()=>  const IntroductionTwoStep()),
    GetPage(name: Routes.editResource, page: ()=>  const EditResource()),
  ];
}