import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:on_sight_application/repository/web_service_response/error_model.dart';
import 'package:on_sight_application/repository/web_service_response/error_response.dart';
import 'package:on_sight_application/utils/connectivity.dart';
import 'package:on_sight_application/utils/constants.dart';
import 'package:on_sight_application/utils/dialogs.dart';
import 'package:on_sight_application/utils/end_point.dart';
import 'package:on_sight_application/utils/functions/functions.dart';
import 'package:on_sight_application/utils/shared_preferences.dart';
import 'package:on_sight_application/utils/strings.dart';
import 'package:on_sight_application/repository/app_exception.dart';

class ApiBaseHelper{


  // post api call method.....................................................................................................
  Future<dynamic> postApiCall(String url, Map<String, dynamic> jsonData,) async {
    var context =  Get.context;
    bool isNetActive = await ConnectionStatus.getInstance().checkConnection();
    var deviceId = await getDeviceId();
    if (isNetActive) {
      showLoader(context);
      var responseJson;

      Map<String, String> apiHeader = {
        EndPointMessages.AUTHORIZATION_KEY:EndPointMessages.BEARER_VALUE+ sp!.getString(Preference.ACCESS_TOKEN).toString(),
        EndPointKeys.acceptKey: 'application/json',
        EndPointKeys.contentType: 'application/json',
        EndPointMessages.USERAGENT_KEY: deviceId,
      };
      log("ApiUrl=========>>>> ${url}");
      log("apiHeader=========>>>> $apiHeader");
      log("request=========>>>> ${jsonEncode(jsonData)}");

      try {
        final http.Response response = await http.post(
          Uri.parse(url),
          headers: apiHeader,
          body: jsonEncode(jsonData),
        ).timeout(const Duration(seconds: 60)).catchError((error) async {
          Get.back();
          Get.snackbar(alert, pleaseCheckInternet);
          return await Future.error(error);
        });
        Get.back();

        log("statusCode=========>>>> ${response.statusCode}");
        log("response=========>>>> ${response.body}");

        try {

          responseJson = _returnResponse(response, showValue: false);


        } catch (e) {

        }
      } on SocketException {
        //showToastMessage("No Internet connection");
        Get.back();
        throw FetchDataException(noInternet);
      }
      return responseJson;
    } else
    {
      Get.snackbar(alert,noInternet);

      // internetConnectionDialog(context);
    }
  }

  // post api call method.....................................................................................................
  Future<dynamic> deleteApiCall(String url, Map<String, dynamic> jsonData,) async {
    var context =  Get.context;
    bool isNetActive = await ConnectionStatus.getInstance().checkConnection();
    var deviceId = await getDeviceId();
    if (isNetActive) {
      showLoader(context);
      var responseJson;

      Map<String, String> apiHeader = {
        EndPointMessages.AUTHORIZATION_KEY:EndPointMessages.BEARER_VALUE+ sp!.getString(Preference.ACCESS_TOKEN).toString(),
        EndPointKeys.acceptKey: 'application/json',
        EndPointKeys.contentType: 'application/json',
        EndPointMessages.USERAGENT_KEY: deviceId,
      };
      log("ApiUrl=========>>>> ${url}");
      log("apiHeader=========>>>> $apiHeader");
      log("request=========>>>> ${jsonEncode(jsonData)}");

      try {
        final http.Response response = await http.delete(
          Uri.parse(url),
          headers: apiHeader,
          body: jsonEncode(jsonData),
        ).timeout(const Duration(seconds: 120)).catchError((error) async {
          Get.back();
          Get.snackbar(alert, pleaseCheckInternet);
          return await Future.error(error);
        });
        Get.back();

        log("statusCode=========>>>> ${response.statusCode}");
        log("response=========>>>> ${response.body}");

        try {
          responseJson = _returnResponse(response);

        } catch (e) {}
      } on SocketException {
        //showToastMessage("No Internet connection");
        Get.back();
        throw FetchDataException(noInternet);
      }
      return responseJson;
    } else
    {
      Get.snackbar(alert,noInternet);

      // internetConnectionDialog(context);
    }
  }


  // post api call method.....................................................................................................
  Future<dynamic> postApiCallFieldIssue(String url, Map<String, dynamic> jsonData,) async {
    var context =  Get.context;
    bool isNetActive = await ConnectionStatus.getInstance().checkConnection();
    var deviceId = await getDeviceId();
    if (isNetActive) {
      showLoader(context);

      Map<String, String> apiHeader = {
        EndPointMessages.AUTHORIZATION_KEY:EndPointMessages.BEARER_VALUE+ sp!.getString(Preference.ACCESS_TOKEN).toString(),
        EndPointKeys.acceptKey: 'application/json',
        EndPointKeys.contentType: 'application/json',
        EndPointMessages.USERAGENT_KEY: deviceId,
      };
      log("ApiUrl=========>>>> ${url}");
      log("apiHeader=========>>>> $apiHeader");
      log("request=========>>>> ${jsonEncode(jsonData)}");

      try {
        final http.Response response = await http.post(
          Uri.parse(url),
          headers: apiHeader,
          body: jsonEncode(jsonData),
        ).timeout(const Duration(seconds: 60)).catchError((error){
          Get.back();
          Get.snackbar(alert, pleaseCheckInternet);
        });
        Get.back();

        log("statusCode=========>>>> ${response.statusCode}");
        log("response=========>>>> ${response.body}");

        try {
          return response;

        } catch (e) {}
      } on SocketException {
        //showToastMessage("No Internet connection");
        Get.back();
        throw FetchDataException(noInternet);
      }
      return "Error";
    } else
    {
      Get.snackbar(alert,noInternet);

      // internetConnectionDialog(context);
    }
  }

  //Get api call method...............................................................................
  Future<dynamic> getApiCall(String url,{isLoading = true, showSnackbarValue = true}) async {
    var context =  Get.context;
    bool isNetActive = await ConnectionStatus.getInstance().checkConnection();
    var deviceId = await getDeviceId();
    if (isNetActive) {
      if(isLoading) {
        showLoader(context);
      }
      var responseJson;

      Map<String, String> apiHeader = {
        EndPointMessages.AUTHORIZATION_KEY:EndPointMessages.BEARER_VALUE+ sp!.getString(Preference.ACCESS_TOKEN).toString(),
        EndPointKeys.acceptKey: 'application/json',
        EndPointKeys.contentType: 'application/json',
        EndPointMessages.USERAGENT_KEY: deviceId,
      };
      log("ApiUrl=========>>>> ${url}");
      log("apiHeader=========>>>> $apiHeader");

      try {
        final http.Response response = await http.get(
          Uri.parse(url),
          headers: apiHeader,
        ).timeout(const Duration(seconds: 60)).catchError((error) async {
          if(isLoading) {
            Get.closeAllSnackbars();
            Get.back();
          }
          Get.snackbar(alert, pleaseCheckInternet);
          return await Future.error(error);
        });
        if(isLoading) {
          Get.closeAllSnackbars();
          Get.back();
        }

        log("statusCode=========>>>> ${response.statusCode}");
        log("response=========>>>> ${response.body}");

        try {
          responseJson = _returnResponse(response, showValue: showSnackbarValue);


        } catch (e) {if(isLoading) {
          Get.closeAllSnackbars();
          Get.back();
        }}
      } on SocketException {
        if(isLoading) {
          Get.closeAllSnackbars();
          Get.back();
        }
        return "No Internet";
      }
      return responseJson;
    } else
    {
      Get.closeAllSnackbars();
      Get.closeCurrentSnackbar();
      Get.snackbar(alert, noInternet);
      return "No Internet";
    }
  }

  //Get api call method...............................................................................
  Future<dynamic> deleteMethod(String url,{isLoading = true, showSnackbarValue = true}) async {
    var context =  Get.context;
    bool isNetActive = await ConnectionStatus.getInstance().checkConnection();
    var deviceId = await getDeviceId();
    if (isNetActive) {
      if(isLoading) {
        showLoader(context);
      }
      var responseJson;

      Map<String, String> apiHeader = {
        EndPointMessages.AUTHORIZATION_KEY:EndPointMessages.BEARER_VALUE+ sp!.getString(Preference.ACCESS_TOKEN).toString(),
        EndPointKeys.acceptKey: 'application/json',
        EndPointKeys.contentType: 'application/json',
        EndPointMessages.USERAGENT_KEY: deviceId,
      };
      log("ApiUrl=========>>>> ${url}");
      log("apiHeader=========>>>> $apiHeader");

      try {
        final http.Response response = await http.delete(
          Uri.parse(url),
          headers: apiHeader,
        ).timeout(const Duration(seconds: 60)).catchError((error) async {
          if(isLoading) {
            Get.closeAllSnackbars();
            Get.back();
          }
          Get.snackbar(alert, pleaseCheckInternet);
          return await Future.error(error);
        });
        if(isLoading) {
          Get.closeAllSnackbars();
          Get.back();
        }

        log("statusCode=========>>>> ${response.statusCode}");
        log("response=========>>>> ${response.body}");

        try {
          responseJson = _returnResponse(response, showValue: showSnackbarValue);


        } catch (e) {if(isLoading) {
          Get.closeAllSnackbars();
          Get.back();
        }}
      } on SocketException {
        if(isLoading) {
          Get.closeAllSnackbars();
          Get.back();
        }
        return noInternetStr;
      }
      return responseJson;
    } else
    {
      Get.closeAllSnackbars();
      Get.closeCurrentSnackbar();
      Get.snackbar(alert, noInternet);
      return noInternetStr;
    }
  }


  //Get api call method Field Issue...........................................................................................
  Future<dynamic> getApiCallFieldIssue(String url,{isLoading = true}) async {
    var context =  Get.context;
    bool isNetActive = await ConnectionStatus.getInstance().checkConnection();
    var deviceId = await getDeviceId();
    if (isNetActive) {
      if(isLoading) {
        showLoader(context);
      }
      var responseJson;

      Map<String, String> apiHeader = {
        EndPointMessages.AUTHORIZATION_KEY:EndPointMessages.BEARER_VALUE+ sp!.getString(Preference.ACCESS_TOKEN).toString(),
        EndPointKeys.acceptKey: 'application/json',
        EndPointKeys.contentType: 'application/json',
        EndPointMessages.USERAGENT_KEY: deviceId,
      };
      log("ApiUrl=========>>>> ${url}");
      log("apiHeader=========>>>> $apiHeader");

      try {
        final http.Response response = await http.get(
          Uri.parse(url),
          headers: apiHeader,
        ).timeout(const Duration(seconds: 60)).catchError((error){
          if(isLoading) {
            Get.closeAllSnackbars();
            Get.back();
          }
          Get.snackbar(alert, pleaseCheckInternet);
        });
        if(isLoading) {
          Get.closeAllSnackbars();
          Get.back();
        }

        log("statusCode=========>>>> ${response.statusCode}");
        log("response=========>>>> ${response.body}");

        try {
          return response;


        } catch (e) {if(isLoading) {
          Get.closeAllSnackbars();
          Get.back();
        }}
      } on SocketException {
        if(isLoading) {
          Get.closeAllSnackbars();
          Get.back();
        }
        return "No Internet";
      }
      return responseJson;
    } else
    {
      Get.closeCurrentSnackbar();
      Get.closeAllSnackbars();
      Get.snackbar(alert, noInternet);
      return "No Internet";
    }
  }




  //MultipartRequest api call method..........................................................................................

  Future<dynamic> multiPartRequest(String url, Map<String, String>fieldMap, List<http.MultipartFile> listImage, token) async {
    bool isNetActive = await ConnectionStatus.getInstance().checkConnection();
    var deviceId = await getDeviceId();
    if (isNetActive) {

      var response;
      var responseJson;

      log("ApiUrl=========>>>> ${url}");
      log("Token=========>>>> ${token}");

      try {
        var request = http.MultipartRequest(
            'POST',
            Uri.parse(url)
        );
        request.headers[EndPointMessages.AUTHORIZATION_KEY] = EndPointMessages.BEARER_VALUE+ token.toString();
        request.headers[EndPointKeys.contentType] = 'multipart/form-data';
        request.headers[EndPointMessages.USERAGENT_KEY] = deviceId;
        request.fields.addAll(fieldMap);
        request.files.addAll(listImage);
        debugPrint(request.fields.toString());
        debugPrint(request.files.first.field.toString() +" "+request.files.first.filename.toString());
        log("Fields=========>>>> ${request.fields}");
        log("Files=========>>>> ${request.files}");
        response = await request.send();
        var res =  await response.stream.bytesToString();
        log("statusCode=========>>>> ${response.statusCode}");
        log("response=========>>>> ${res}");

        try {

          final JsonDecoder _decoder = new JsonDecoder();
          return _decoder.convert(res.toString());

        } catch (e) {

        }
      }


      /*    on SocketException {
        Get.snackbar(alert, noInternet);
        return "No Internet";
      }*/
      catch (error){
        print(error);
        return "error";
      }
      return responseJson;
    } else
    {
      return "error";
    }
  }


  //MultipartRequest api call method..........................................................................................

  Future<dynamic> multiPartRequestPromopictures(String url, Map<String, String>fieldMap, List<http.MultipartFile> listImage, token) async {
    bool isNetActive = await ConnectionStatus.getInstance().checkConnection();
    var deviceId = await getDeviceId();
    if (isNetActive) {

      var response;
      var responseJson;

      log("ApiUrl=========>>>> ${url}");
      log("Token=========>>>> ${token}");

      try {
        var request = http.MultipartRequest(
            'POST',
            Uri.parse(url)
        );
        request.headers[EndPointMessages.AUTHORIZATION_KEY] = EndPointMessages.BEARER_VALUE+ token.toString();
        request.headers[EndPointKeys.contentType] = 'multipart/form-data';
        request.headers[EndPointMessages.USERAGENT_KEY] = deviceId;
        request.fields.addAll(fieldMap);
        request.files.addAll(listImage);
        debugPrint(request.fields.toString());
        debugPrint(request.files.first.field.toString() +" "+request.files.first.filename.toString());
        response = await request.send();
        var res =  await response.stream.bytesToString();
        debugPrint("statusCode=========>>>> ${response.statusCode}");
        debugPrint("response=========>>>> ${res}");

        try {
          if(response.statusCode.toString()=="200"){
            return response.statusCode.toString();

          }else if(response.statusCode.toString()=="401"){

            if(response!=null){
              final JsonDecoder _decoder = new JsonDecoder();
              responseJson = _decoder.convert(res.toString());
              Get.showSnackbar(GetSnackBar(message: responseJson["Error"]["Message"].toString(),duration: Duration(seconds: 2),));
              return responseJson;
            }
          }else if(response.statusCode.toString()=="500"){
            if(response!=null){
              var responseJson = json.decode(response.body.toString());
              ErrorResponse errorModel =  ErrorResponse.fromJson(responseJson);
              Get.showSnackbar(GetSnackBar(message: errorModel.errorDescription.toString(),duration: Duration(seconds: 2),));
              return responseJson;
            }
          }


        } catch (e) {

        }
      }


      /*    on SocketException {
        Get.snackbar(alert, noInternet);
        return "No Internet";
      }*/
      catch (error){
        print(error);
        return "error";
      }
      return responseJson;
    } else
    {
      Get.snackbar(alert, noInternet);
      return "error";
    }
  }

  // post api call method.....................................................................................................
  Future<dynamic> postApiCallLoader(String url, Map<String, dynamic> jsonData, {isLoading = true}) async {
    var context =  Get.context;
    bool isNetActive = await ConnectionStatus.getInstance().checkConnection();
    var deviceId = await getDeviceId();
    if (isNetActive) {
      if(isLoading) {
        showLoader(context);
      }
      var responseJson;

      Map<String, String> apiHeader = {
        EndPointMessages.AUTHORIZATION_KEY:EndPointMessages.BEARER_VALUE+ sp!.getString(Preference.ACCESS_TOKEN).toString(),
        EndPointKeys.acceptKey: 'application/json',
        EndPointKeys.contentType: 'application/json',
        EndPointMessages.USERAGENT_KEY: deviceId,
      };
      log("ApiUrl=========>>>> ${url}");
      log("apiHeader=========>>>> $apiHeader");
      log("request=========>>>> ${jsonEncode(jsonData)}");

      try {
        final http.Response response = await http.post(
          Uri.parse(url),
          headers: apiHeader,
          body: jsonEncode(jsonData),
        ).timeout(const Duration(seconds: 60)).catchError((error) async {
          if(isLoading) {
            Get.closeAllSnackbars();
            Get.back();
          }
          Get.snackbar(alert, pleaseCheckInternet);
          return await Future.error(error);
        });
        if(isLoading) {
          // Get.closeAllSnackbars();
          Get.back();
        }

        log("statusCode=========>>>> ${response.statusCode}");
        log("response=========>>>> ${response.body}");

        try {

          responseJson = _returnResponse(response, showValue: false);


        } catch (e) {
          if(isLoading) {
            Get.closeAllSnackbars();
            Get.back();
          }
        }
      } on SocketException {
        if(isLoading) {
          Get.closeAllSnackbars();
          Get.back();
        }
        throw FetchDataException(noInternet);
      }
      return responseJson;
    } else
    {
      Get.snackbar(alert,noInternet);

      // internetConnectionDialog(context);
    }
  }

  // Return Reponse Method....................................................................................................
  dynamic _returnResponse(http.Response response, {showValue = true}) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        return responseJson;
      case 201:
        var responseJson = json.decode(response.body.toString());
        ErrorResponse errorModel =  ErrorResponse.fromJson(responseJson);
        if(showValue) {
          Get.showSnackbar(GetSnackBar(message: errorModel.errorDescription,
            duration: Duration(seconds: 2),));
        }
        return responseJson;
      case 400:
        var responseJson = json.decode(response.body.toString());
        ErrorResponse errorModel =  ErrorResponse.fromJson(responseJson);

        Get.showSnackbar(GetSnackBar(message: errorModel.errorDescription,
          duration: Duration(seconds: 2),));

        return responseJson;
      case 401:
        var responseJson = json.decode(response.body.toString());

        ErrorModel errorModel =  ErrorModel.fromJson(responseJson);
        if(errorModel.error!=null) {
          if (errorModel.error!.message.toString().contains(
              "session") && errorModel.error!.message.toString().contains(
              "expired")) {
            defaultDialog(Get.context!, title: alert,
                alert: errorModel.error?.message.toString(),
                cancelable: false,
                onTap: () {

                  logoutFun();
                  return "error";
                });
          }else{
            defaultDialog(Get.context!, title: alert,alert: errorModel.error?.message.toString(), cancelable: true, onTap: (){
              Get.back();

            });
          }
        }


        return responseJson;
      case 403:
        var responseJson = json.decode(response.body.toString());
        ErrorResponse errorModel =  ErrorResponse.fromJson(responseJson);
        if(showValue) {
          Get.showSnackbar(GetSnackBar(message: errorModel.errorDescription,
            duration: Duration(seconds: 2),));
        }
        return responseJson;
      case 404:
        var responseJson = json.decode(response.body.toString());
        ErrorResponse errorModel =  ErrorResponse.fromJson(responseJson);
        if(showValue) {
          Get.showSnackbar(GetSnackBar(message: errorModel.errorDescription,
            duration: Duration(seconds: 2),));
        }
        return responseJson;
      case 405:
        var responseJson = json.decode(response.body.toString());
        ErrorResponse errorModel =  ErrorResponse.fromJson(responseJson);
        if(errorModel.errorDescription.toString().contains("different device")){
          defaultDialog(Get.context!, title: alert,alert: errorModel.errorDescription.toString(), cancelable: false, onTap: (){
            logoutFun();
          });
        }else {
          defaultDialog(Get.context!, title: alert,
              alert: errorModel.errorDescription.toString(),
              cancelable: true,
              onTap: () {
                Get.back();
              });
        }
        return responseJson;
      case 500:

        try{
          var responseJson = json.decode(response.body.toString());
          ErrorResponse errorModel =  ErrorResponse.fromJson(responseJson);
          if(showValue) {
            Get.showSnackbar(GetSnackBar(
              message: errorModel.errorDescription.toString(),
              duration: Duration(seconds: 2),));
          }else{

            Get.showSnackbar(GetSnackBar(
              message: "Internal Server Error",
              duration: Duration(seconds: 2),));
          }
          return responseJson;
        }catch(ee){
          Get.showSnackbar(GetSnackBar(
            message: "Internal Server Error",
            duration: Duration(seconds: 2),));
        }

        return "error";


      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }

  // For getting device id which will be added in header of each request...................
  getDeviceId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.model.toString(); // unique ID on iOS
    } else if(Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.model.toString(); // unique ID on Android
    }
  }
}