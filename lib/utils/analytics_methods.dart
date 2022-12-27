import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsMethods{
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  void onSplash() {
    analytics.setUserProperty(name: 'rank', value: 'gold');
  }
}