
enum Environment {dev, prod}

abstract class AppEnvironment {
  static late String baseApiUrl;
  static late String title;
  static late Environment _environment;
  static Environment get environment => _environment;
  static setupEnv(Environment env)async {
    _environment = env;
    switch (env) {
      case Environment.dev:{
        baseApiUrl = "https://onsight-stage.nthdegree.com/API";
        title = "On-Sight Dev";
        // AppInternetManager appInternetManager = AppInternetManager();
        // await appInternetManager.setBaseUrl(val: baseApiUrl);
        // await appInternetManager.getSettingsTable() as List;
        break;
      }

      case Environment.prod:{
        baseApiUrl = "https://onsight.nthdegree.com/API";
        title = "On-Sight";
        // AppInternetManager appInternetManager = AppInternetManager();
        // await appInternetManager.setBaseUrl(val: baseApiUrl);
        // await appInternetManager.getSettingsTable() as List;
        break;
      }

    }
  }
}