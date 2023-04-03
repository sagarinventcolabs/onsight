
import 'package:on_sight_application/env.dart';

enum SignInStatus { requiresVerification, requiredRegistration, success }

enum SubmittedCategory { showReady, outboundBOL, both, none }

enum JobAction {
  //value 2, 3 is "TypeId" from Server for "Categories"
  //2 - JobPhotos categories
  //3 - Project Evaluation categories
  jobPhotos(2),
  projectEvaluation(3),
  leadSheet(4);

  const JobAction(this.value);
  final int value;
  //Get value like below
  //const pp = JobAction.jobPhotos;
  //print(pp.value);
}

class EndPoint {
  //static const String baseURL = "http://litedemo.cloudapp.net:83/api";//Dev server
  //static const String baseURL = "http://172.30.255.150:8301/API";//Dev server
  // static const String baseURL = "https://onsight-stage.nthdegree.com/API";//Staging server
   static const String baseURLStage = "https://onsight-stage.nthdegree.com/API";//Staging server
   static const String baseURLMain = "https://onsight.nthdegree.com/API";//Staging server

  static  String baseURL = AppEnvironment.baseApiUrl;

  // Url for Get Otp
  static  String getOTP = "$baseURL/MobileAuth/Authenticate/Mob"; //http://litedemo.cloudapp.net:83/api/MobileAuth/Authenticate/Mob
   // Urrl for email
  static  String getOTPForEmail = "$baseURL/MobileAuth/Authenticate/Email"; //http://litedemo.cloudapp.net:83/api/MobileAuth/Authenticate/Mob
  // Login Url
  static  String loginWithMobile = "$baseURL/Account/MockLogin";
  // Verify Otp Url
  static  String verifyOTP = "$baseURL/MobileAuth/Authenticate/Otp";
  //Register User Url
  static  String registerUser = "$baseURL/MobileAuth/Register";
  //Resend OTP Url
  static  String resendOTP = "$baseURL/MobileAuth/Authenticate/resendOtp";
  //Delete User Url
  static  String deleteUser = "$baseURL/MobileAuth/DeleteAccount";
  //Disable User
  static  String disableUser = "$baseURL/MobileAuth/DisableAccount";
  //Get Latest Version
  static  String getLatestVersion = "$baseURL/MobileVersion/GetMobileVersionData?operatingSystem=";
   //Get Security Flags
   static  String getSecurityFlags = "$baseURL/DashboardItems";
   //SSN Validation Url
   static  String ssnValidate = "$baseURL/OnBoarding/FindOasisResources/";
   static  String ssnValidateBy = "$baseURL/OnBoarding/GetOasisResourcesBySSN/";
  //Job Category Url
  static  String jobCategories = "$baseURL/JobPhotos/GetCategories";
  //Get Job Details Url
  static  String getJobDetails = "$baseURL/JobPhotos/GetJobDetails?jobNumber=";
  //Project Evaluation Category Url
  static  String evaluationCategories =
      "$baseURL/JobPhotos/GetEvaluationTypes";
  // Job Details Url
  static  String jobDetails =
      "$baseURL/JobPhotos/GetJobDetails?jobNumber=";
  // Upload Photos
  static  String uploadCategory = "$baseURLMain/UploadPhotos/UploadPhotoDetails";
  static  String uploadCategoryStage = "$baseURLStage/UploadPhotos/UploadPhotoDetails";
  // Get Questionnaire
  static  String getEvaluationQuestionaire =
      "$baseURL/ProjectEvaluation/GetProjectEvaluationQuestionnaire";
  // Is Project Evaluation Exist
  static  String isProjectEvaluationExists =
      "$baseURL/ProjectEvaluation/IsProjectEvaluationExists";
  // Project Evaluation Details
  static  String projectEvaluationDetails =
      "$baseURL/ProjectEvaluation/GetProjectEvaluationDetails";
  // Save Project Evaluation
  static  String saveProjectEvaluation =
      "$baseURL/ProjectEvaluation/SaveProjectEvaluation";
  // Send Email
  static  String sendEmail = "$baseURL/JobPhotos/SendMail";
  //Get Lead Sheet Details
  static  String getLeadSheetDetails = "$baseURL/LeadSheet/GetLeadSheetDetails?showNumber=";
  //Get Union List
  static  String getUnionListEndPoint = "$baseURL/onboarding/GetUnion?union=a";
  // Save Exhibitor Details
  static  String addExhibitor =
      "$baseURL/LeadSheet/SaveExhibitor?showNumber=";
  // Get Shop List
  static  String getShopList =
      "$baseURL/LeadSheet/GetShopValueDetails";
  // Get Shop List
  static  String getBoothSizeList = "$baseURL/LeadSheet/GetBoothSizeDetails";
  // Get Companies List
  static  String getCompaniesList = "$baseURL/LeadSheet/GetSetupCompanyDetails";
  // Save Lead Sheet
  static  String saveLeadSheet = "$baseURLMain/LeadSheet/SaveLeadSheet";
  static  String saveLeadSheetStage = "$baseURLStage/LeadSheet/SaveLeadSheet";
  //Fetch Profile
  static  String fetchProfile = "$baseURL/Account/GetProfileDetails";
  //Profile Update
  static  String updateProfile = "$baseURL/Account/UpdateProfileDetails";
  //create case field issue with comment only
  static  String createCommentCase = "$baseURL/OasisCrm/CreateCaseWithCommentOnly";
  //search WO number by Show number
  static  String getDetailsByShowNumber = "$baseURL/JobPhotos/GetJobDetailsByshowNumber?showNumber=";
  //search WO number by Show name
  static  String getDetailsByShowName = "$baseURL/JobPhotos/GetJobDetailsByshowName?showName=";
  //search WO number by Exhibitor name
  static  String getDetailsByExhibitorName = "$baseURL/JobPhotos/GetJobDetailsByexhibitorName?exhibitorName=";
  //create case field issue with comment and photos
  static  String createCase = "$baseURLMain/OasisCrm/CreateCase";
  static  String createCaseStage = "$baseURLStage/OasisCrm/CreateCase";

  static  String exhibitorGetBoothSize =
      "$baseURL/LeadSheet/GetBoothSizeDetails";

  static  String exhibitorGetShop =
      "$baseURL/LeadSheet/GetShopValueDetails";

  static  String exhibitorGetSetupCompany =
      "$baseURL/LeadSheet/GetSetupCompanyDetails";

  /// update exhibitor url in Lead Sheet
  static  String updateExhibitor = "$baseURL/LeadSheet/SaveExhibitor?showNumber=";
  /// Get resource list onboarding
  static  String oasisResourcesEndPoint = "$baseURL/onboarding/GetAllOasisResources";
  /// Get document type url in onboarding
  static  String getDocumentType = "$baseURL/onboarding/GetAllDocumentType";
  ///Create resource onboarding url
  static  String createResourceOnboarding = "$baseURL/onboarding/CreateResource";
  ///Upload Document url for onboarding
  static  String uploadDocument = "$baseURLMain/onboarding/AddResourceDocuments";
  static  String uploadDocumentStage = "$baseURLStage/onboarding/AddResourceDocuments";
  static  String addPromoPictures = "$baseURLMain/promoPictures/AddPromoPictures";
  static  String addPromoPicturesStage = "$baseURLStage/promoPictures/AddPromoPictures";
}

class EndPointKeys {
  //Databse Name
  static const String databaseName = "NthDegree";
  //Key for mobile number
  static const String keyUserNameMobile = "UsernameOrPhone";
  //Key for country code
  static const String keyCountryCode = "CountryCode";
  //Key for Client Id
  static const String keyClientId = "ClientId";
  // Key for OTP Verification code
  static const String keyOtpVerification = "OtpVerificationCode";
  //key for Get Job Details
  static const String keyIsDownloadAllJob = "&isDownloadAllJobs=";
  //Category Names
  static const String showReady = "Show Ready";
  static const String outboundBOL = "Outbound BOL";
  static const String installFreight = "Install Freight";
  static const String dismantleFreight = "Dismantle Freight";
  static const String accident = "Accident";
  static const String install = "Install";
  static const String dismantle = "Dismantle";
  static const String promoKey = "PromoKey";
  static const String resourceKey = "ResourceKey";
  static const String comments = "comments";
  static const String jobKey = "jobKey";
  static const String contentType = "Content-Type";
  static const String acceptKey = "Accept";

}

class EndPointMessages {
  static const String BEARER_VALUE = "Bearer ";
  static const String AUTHORIZATION_KEY = "Authorization";
  static const String USERAGENT_KEY = "UserAgent";
  static const String networkNotFound = "Please check the network connection";
  static const String enterFirstName = "Enter first name";
  static const String enterLastName = "Enter last name";
  static const String enterEmailId = "Enter valid email address";
  static const String checkMobileNumber =
      "Please check the mobile number and try again";
  static const String somethingWentWrong =
      "Something went wrong, please try again";
  static const String unAuthorizedUser =
      "Account has been deactivated. Please contact NthDegree for more information.";
  //
  static const String discardImageMessage =
      "Do you want to discard the added photos?";
  static const String jobDetailNotAvailable = "Job details not available";
  static const String categoryNotAvailable = "Categories not available";
  static const String showNotAvailable = "Show details not available";
  static const String uploadSuccessMessage = "Successfully uploaded all photos";
  static const String uploadRemainingMessage =
      "Remaining {0} photos to be uploaded";
  static const String evaluationSubmittedMessage =
      "An evaluation has already been submitted for this Job '{0}'. Would you like to submit form again?";
  static const String answerMandatoryQuestion =
      "Please answer all mandatory questions";
  static const String answerMandatoryNotes = "Please enter all mandatory notes";
  static const String enterValidBoothSize = "Please enter valid booth size";
  static const String validateEvaluationMessage =
      "Do you want to discard the changes?";
  static const String exhibitorNotAvailable = "Exhibitor not available";
  static const String completeInstallEvaluation =
      "Would you like to complete Install evaluation?";
  static const String completeDismantleEvaluation =
      "Would you like to complete Dismantle evaluation?";
  static const String completeBothEvaluation =
      "Would you like to complete Install/Dismantle evaluation?";

  static const String defaultDisplayString = "N/A";

  static const String notificationTitle = "Upload Status";

  static const String authorizationKey = "Authorization";
  static const String bearerValue = "Bearer ";
  static const String userAgentKey = "UserAgent";

  static const String fileNameKey = "FileName";
  static const String leadSheetKey = "LeadSheetKey";
  static const String uploadDateFormat = "MM-dd-yyyy HH:mm:ss";
  static const String evaluationSaveDateFormat = "MM-dd-yyyy";

  //Loader Messages
  static const String loginFetchOTP = "Fetching OTP...";
  static const String loginVerifyOTP = "Verifying OTP...";
  static const String loginUserRegistration = "Registering user details...";
  static const String fetchProfile = "Fetching user details...";
  static const String updateProfile = "Updating user details...";
  static const String profileUpdateMessage = "Profile updated successfully!";

  static const String fetchJobDetails = "Fetching job details...";
  static const String fetchShowDetails = "Fetching show details...";
  static const String fetchCategories = "Fetching categories...";

  static const String loading = "Loading...";
  static const String saving = "Saving...";
  static const String clearingAllData = "Clearing all data...";

  static const String photoAdded = "Photo added successfully!";
  static const String photosAdded = "Photos added successfully!";
  static const String photoUpdated = "Photos updated successfully!";
  static const String thankYou = "Thank You!";
  static const String photosUpload = "Photos upload is In-Progress.";
  static const String failedPhotosUpload =
      "Remaining photos upload is In-Progress.";
  static const String enableMobileData =
      "Upload will happen when you connect your device to Wi-Fi or enable mobile data from Nth degree app settings";

  static const String evaluationCheckStatus = "Checking status...";
  static const String evaluationFetchQuestion = "Fetching questions...";
  static const String evaluationUploadSuccess =
      "Details have been submitted successfully!";
  static const String evaluationUploadFailed =
      "Questionnaire document submission failed. Please try again.";
  static const String evaluationReportSubmit =
      "Submitting evaluation report...";
  static const String evaluationReportSaved =
      "No network connection. Your evaluation report have been saved.";

  static const String exhibitorAddedSuccess = "Exhibitor successfully added!";
  static const String exhibitorUpdatedSuccess =
      "Exhibitor successfully updated!";
  static const String exhibitorAdd = "Adding exhibitor details...";
  static const String exhibitorEdit = "Updating exhibitor details...";
  static const String leadSheetUpload =
      "Lead sheet has been submitted successfully!";
  static const String leadSheetSubmit = "Submitting lead sheet...";

  static const String batteryLowMessage =
      "Upload will happen when device will have enough battery charge.";

  static const String mobileNetworkOffMessage =
      "Upload will happen when you connect your device to Wi-Fi or enable mobile data from Nth degree app settings.";

  //public static readonly string JOB_PREFIX_TEXT = "W";
  //public static readonly string JOB_PREFIX_HYPHEN = "- ";
  static const int jobNumberMaxLength = 20;
  static const int jobNumberMinLength = 4; //to enable SUBMIT button on typing
  //// About Us Text
  static const String aboutUsText =
      "<p style=\"font-size:130%;\" align=\"justify\">Nth Degree is always on-site and you, our labor operations team members, are our clients&rsquo; " +
          "eyes on the show floor. To help you help our clients, we have created this app, On-Sight. <br /><br />It&rsquo;s your tool for:<br /><b>&nbsp&nbsp&nbsp&nbsp&bull; Sharing insights, " +
          "information and on-site imagery in real time<br />&nbsp&nbsp&nbsp&nbsp&bull; Easily providing clients a live view of their project step-by-step<br />&nbsp&nbsp&nbsp&nbsp&bull; Allowing them to " +
          "check our progress</b><br /><br />On-Sight reduces your administrative workload with a digital application for all the information you are responsible for capturing " +
          "and sharing including on-site project photos, progress reporting and feedback forms. It&rsquo;s the home for capturing the important moments, " +
          "and sharing them with our clients wherever they are.</p>";

  // Update Dialog Text
  static const String updateDialogTitle = "New version available";
  static const String updateDialogMessage = "Please, update app to new version";
  static const String deleteEmailMessage = "Are you sure want to delete email?";
  static const String duplicateEmailMessage = "Email already exists";
}
