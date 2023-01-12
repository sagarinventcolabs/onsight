
enum Environment {dev, prod}

abstract class AppEnvironment {
  static String baseApiUrl = "https://onsight.nthdegree.com/API";
  static String title = "On-Sight";
  static String currentBuildFlavor = "prod";
  static Environment _environment = Environment.prod;
  static Environment get environment => _environment;
  static setupEnv(Environment env)async {
    _environment = env;
    switch (env) {
      case Environment.dev:{
        currentBuildFlavor = "dev";
        baseApiUrl = "https://onsight-stage.nthdegree.com/API";
        title = "On-Sight Dev";
        // AppInternetManager appInternetManager = AppInternetManager();
        // await appInternetManager.setBaseUrl(val: baseApiUrl);
        // await appInternetManager.getSettingsTable() as List;
        break;
      }

      case Environment.prod:{
        currentBuildFlavor = "prod";
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