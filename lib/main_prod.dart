import 'dart:async';

import 'package:on_sight_application/env.dart';
import 'package:on_sight_application/main.dart' as appMain;


Future<void> main() async {
  AppEnvironment.setupEnv(Environment.prod);
  appMain.main();
}