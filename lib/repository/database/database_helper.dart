import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

///Class for handling all Database operations
class DatabaseHelper {
  static DatabaseHelper? _datebaseHelper;
  static Database? _database;

  String mJobPhotosTable = 'job_photos_table';
  String mUserTable = 'user_table';
  String mCategoryTable = 'category_table';
  String mEmailTable = 'email_table';
  String mImageCountTable = 'image_count_table';
  String mImageDataTable = 'image_data_table';
  String mLastSavedJobsTable = 'last_saved_jobs_table';
  String mLastSavedShowsTable = 'last_saved_show_table';
  String mShowTable = 'show_table';
  String reviewTime = 'review_time';

  String mEvaluationAdditionalInfoTable = 'evaluation_additional_info_table';
  String mEvaluationQuestionTable = 'evaluation_question_table';
  String mExhibitorBoothSizeTable = 'exhibitor_booth_size_table';
  String mExhibitorCountTable = 'exhibitor_count_table';
  String mExhibitorSetupCompanyTable = 'exhibitor_setup_company_table';
  String mExhibitorShopTable = 'exhibitor_shop_table';
  String mExhibitorTable = 'exhibitor_table';
  String mExhibitorImageTable = 'exhibitor_image_table';
  String mFieldIssueImageTable = 'field_issue_image_table';
  String mAppInternetTable = 'app_internet_table';
  String mAppUpdateTable = 'app_update_table';




  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    _datebaseHelper ??= DatabaseHelper._createInstance();
    return _datebaseHelper!;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await intializeDatabase();
    }
    return _database!;
  }

  Future<Database> intializeDatabase() async {
    var directory = await getApplicationDocumentsDirectory();
    var dbPath = directory.path + '/OnSight.db';
    var createdDB = await openDatabase(dbPath, version: 3, onCreate: _createDB);
    return createdDB;
  }


  void _createDB(Database db, int newVersion) async {

    //it says whether optional email is from Server or not
    //used for internal validation in JobPhotos page
    await db.execute(
        """CREATE TABLE $mJobPhotosTable(RowID INTEGER PRIMARY KEY AUTOINCREMENT, ShowNumber TEXT, ShowName TEXT, ExhibitorName TEXT, BoothNumber TEXT, ShowCity TEXT, ShowStartDate TEXT, ShowEndDate TEXT, ShowLocation TEXT, Supervision TEXT, SourceName TEXT, SourceContactName TEXT, SourceContactMobilePhone TEXT, SourceContactEmail TEXT, SalesRepFirstName TEXT, SalesRepLastName TEXT, SalesRepOfficePhone TEXT, SalesRepCellPhone TEXT, SalesRepEmailAddress TEXT, JobNumber TEXT, SNumber TEXT, WONumber TEXT, AdditionalEmail TEXT, OasisAdditionalEmail TEXT, IsOptionalEmailExist TEXT)""");//add
    await db.execute(
        """CREATE TABLE $mUserTable(RowID INTEGER PRIMARY KEY AUTOINCREMENT, MobileNumber TEXT, AccessToken TEXT, FirstName TEXT, LastName TEXT, EmailID TEXT)""");
    //two different categories are associated with JobAction//(JobPhotos & Project Evaluation)
    await db.execute(
        """CREATE TABLE $mCategoryTable(RowIDUnique INTEGER PRIMARY KEY AUTOINCREMENT, sendEmail BOOLEAN, yetToSubmit INTEGER, submitted INTEGER, url TEXT, Id TEXT, TypeId TEXT, Name TEXT, RowId INTEGER, isChecked INTEGER)""");
    await db.execute(
        """CREATE TABLE $mEmailTable(RowID INTEGER PRIMARY KEY AUTOINCREMENT, JobNumber TEXT, CategoryName TEXT, Url TEXT, AdditionalEmail TEXT, EmailOnProgress INTEGER)""");//add
    await db.execute(
        """CREATE TABLE $mImageCountTable(RowID INTEGER PRIMARY KEY AUTOINCREMENT, CategoryId TEXT, JobNumber TEXT, TotalImageCount INTEGER, TotalImageCountServer INTEGER, ImageLink TEXT)""");
    await db.execute(
        """CREATE TABLE $mImageDataTable(RowID INTEGER PRIMARY KEY AUTOINCREMENT, CategoryId TEXT, CategoryName TEXT, JobNumber TEXT, ImageName TEXT, ImageNote TEXT, ImagePath TEXT, IsSubmitted INTEGER, PromoFlag INTEGER, IsEmailRequired INTEGER, JobAction INTEGER, RequestId TEXT, AttemptCount INTEGER, SubmitID INTEGER, isPhotoAdded INTEGER)""");

    await db.execute(
        """CREATE TABLE $mLastSavedJobsTable(RowID INTEGER PRIMARY KEY AUTOINCREMENT, JobNumber TEXT, JobAction INTEGER)""");

    await db.execute(
        """CREATE TABLE $mLastSavedShowsTable(RowID INTEGER PRIMARY KEY AUTOINCREMENT, ShowNumber TEXT)""");//add
    await db.execute(
        """CREATE TABLE $mShowTable(RowID INTEGER PRIMARY KEY AUTOINCREMENT, ShowNumber TEXT, ShowName TEXT, StartDate TEXT, EndDate TEXT, ShowCity TEXT, ShowGC TEXT, ShowGuid TEXT, Id TEXT)""");
    //if this field is - False, report has already submiited
    //for particual jobnumber and category name
    await db.execute(
        """CREATE TABLE $mEvaluationAdditionalInfoTable(RowID INTEGER PRIMARY KEY AUTOINCREMENT, JobID TEXT, CategoryName TEXT, CategoryRowID INTEGER, Comments TEXT, IsReportAlreadyExist INTEGER, IsModified INTEGER, IsSubmitted INTEGER)""");
    //RowID from API - used for sorting
    //this says details needed to be entered
    //for Yes or No
    await db.execute(
        """CREATE TABLE $mEvaluationQuestionTable(RowIDUnique INTEGER PRIMARY KEY AUTOINCREMENT, RowID INTEGER, QuestionID TEXT,Question TEXT, JobID TEXT, CategoryName TEXT, AnswerType INTEGER, IsMandatory INTEGER, DetailsRequiredFor INTEGER, Answer INTEGER, Details TEXT, IsModified INTEGER, selected INTEGER, visible INTEGER)""");
    await db.execute(
        """CREATE TABLE $mExhibitorBoothSizeTable(RowID INTEGER PRIMARY KEY AUTOINCREMENT, BoothSize TEXT)""");
    await db.execute(
        """CREATE TABLE $mExhibitorCountTable(RowID INTEGER PRIMARY KEY AUTOINCREMENT, ShowNumber TEXT, ExhibitorName TEXT,BoothSize TEXT, BoothNumber TEXT, Shop TEXT, SetupCompany TEXT, Notes TEXT, FolderUrl TEXT, ExhibitorImageCount INTEGER, ExhibitorGuid TEXT, Id TEXT, OfflineCount INTEGER)""");
    await db.execute(
        """CREATE TABLE $mExhibitorSetupCompanyTable(RowID INTEGER PRIMARY KEY AUTOINCREMENT, SetupCompany TEXT)""");
    await db.execute(
        """CREATE TABLE $mExhibitorShopTable(RowID INTEGER PRIMARY KEY AUTOINCREMENT, Shop TEXT)""");
    await db.execute(
        """CREATE TABLE $mExhibitorTable(RowID INTEGER PRIMARY KEY AUTOINCREMENT, ShowNumber TEXT, ExhibitorName TEXT, BoothSize TEXT,BoothNumber TEXT, Shop TEXT, SetupCompany TEXT, Notes TEXT, FolderUrl TEXT, ExhibitorImageCount INTEGER, IsHighPriority INTEGER, ExhibitorGuid TEXT, ExhibitorId TEXT, YetToSubmit INTEGER, ShowName TEXT)""");
    await db.execute(
        """CREATE TABLE $mExhibitorImageTable(RowID INTEGER PRIMARY KEY AUTOINCREMENT, ImageName TEXT, ImagePath TEXT,ImageNote TEXT, ShowNumber TEXT,ExhibitorId TEXT, IsSubmitted INTEGER)""");
    await db.execute(
        """CREATE TABLE $mFieldIssueImageTable(RowID INTEGER PRIMARY KEY AUTOINCREMENT, ImageName TEXT, ImagePath TEXT,ImageNote TEXT, WoNumber TEXT, IsSubmitted INTEGER)""");
    await db.execute(
        """CREATE TABLE $mAppInternetTable(RowID INTEGER PRIMARY KEY AUTOINCREMENT, AppInternetStatus INTEGER, UploadCompleteStatus INTEGER, PoorNetworkAlert INTEGER, BatterySaverStatus INTEGER, CameraShutterStatus INTEGER, TaskInProgress INTEGER, AuthenticationMode INTEGER, IsAskedAuth INTEGER, Flavor TEXT)""");
    await db.execute(
        """CREATE TABLE $mAppUpdateTable(RowID INTEGER PRIMARY KEY AUTOINCREMENT, Version TEXT, UpdateStatus INTEGER, isAlert INTEGER, ReleaseType TEXT)""");
    await db.execute(
        """CREATE TABLE $reviewTime(RowID INTEGER PRIMARY KEY AUTOINCREMENT, Time TEXT)""");


  }



  Future<int> insertUserData(String mobileNumber, String accessToken, String fName, String lName,String emailId) async {
    Database db = await database;
    var result = await db.rawInsert(
        "INSERT INTO $mUserTable (MobileNumber, AccessToken, FirstName, LastName, EmailID)"
            " VALUES ('$mobileNumber','$accessToken','$fName','$lName','$emailId')");
    return result;
  }

  Future<int> getCountFromTable(String tableName) async {
    Database db = await this.database;
    List<Map<String, dynamic>> list =
    await db.rawQuery('SELECT COUNT (*) FROM $tableName');
    var count = Sqflite.firstIntValue(list);
    return count!;
  }


}
