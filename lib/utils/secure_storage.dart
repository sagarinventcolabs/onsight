import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:on_sight_application/main.dart';
import 'package:on_sight_application/repository/database_model/secure_model.dart';


class SecureStorage{

  IOSOptions _getIOSOptions() => IOSOptions(
    accountName: "NthDegree",
  );

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
    encryptedSharedPreferences: true,
    // sharedPreferencesName: 'Test2',
    // preferencesKeyPrefix: 'Test'
  );

  Future<void> deleteAll() async {
    try{
      await storage.deleteAll(
        iOptions: _getIOSOptions(),
        aOptions: _getAndroidOptions(),
      );
      readAll();
    }catch(e){
      debugPrint(e.toString());
    }

  }

  Future<void> addNewItem(key,value) async {
    await storage.write(
      key: key,
      value: value,
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );
    readAll();
  }



  Future<void> readAll() async {
    final all = await storage.readAll(
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );
    localStorage = all.entries
        .map((entry) => SecureModel(entry.key, entry.value))
        .toList(growable: false);

   // var i = localStorage.indexWhere((element) => element.key=="auth_token");
  }

}