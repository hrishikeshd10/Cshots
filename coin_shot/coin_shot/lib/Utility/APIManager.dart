import 'dart:convert';
import 'dart:io';
import 'package:coin_shot/Utility/AppEror.dart';
import 'package:coin_shot/models/GetLoginResp.dart';
import 'package:coin_shot/models/GetLoginResponse.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

enum API {
  userlogin,
}

enum HTTPMethod { GET, POST, PUT, DELETE }

typedef successCallback = void Function(dynamic response);
typedef progressCallback = void Function(int progress);
typedef failureCallback = void Function(AppError error);

class APIManager {
  static String baseURLComm = "http://3.109.243.231";
  static String googleApiKay = "AIzaSyD6W5XiML6jIK6_MTLm3kN0x_R0dxm7RSk";
  static Duration timeout;
  static String token;
  static String baseURL;
  static String apiVersion;
  var taskId;

  APIManager._privateConstructor();

  static final APIManager _instance = APIManager._privateConstructor();

  factory APIManager() {
    return _instance;
  }

  void loadConfiguration(String configString) {
    Map config = jsonDecode(configString);
    var env = config['environment'];
    baseURL = config[env]['hostUrl'];
    apiVersion = config['version'];
    timeout = Duration(seconds: config[env]['timeout']);
  }

  void setToken(String value) {
    token = value;
  }

  String apiBaseURL() {
    return baseURL;
  }

  Future<String> apiEndPoint(API api) async {
    var apiPathString = "";

    switch (api) {
      case API.userlogin:
        apiPathString = "coinshots/api/v1/Login";
        break;

      default:
        apiPathString = "";
    }
    print(apiBaseURL());
    return this.apiBaseURL() + apiPathString;
  }

  HTTPMethod apiHTTPMethod(API api) {
    HTTPMethod method;
    switch (api) {

      // case API.getCatastrophicList:
      //   method = HTTPMethod.GET;
      //   break;

      default:
        method = HTTPMethod.POST;
    }
    return method;
  }

  String classNameForAPI(API api) {
    String className;
    switch (api) {
      case API.userlogin:
        className = "GetLoginResp";
        break;
      default:
        className = 'CommonResponse';
    }
    return className;
  }

  dynamic parseResponse(String className, var json) {
    dynamic responseObj;
    if (className == 'GetLoginResp') {
      responseObj = GetLoginResp.fromJson(json);
    } else if (className == 'CommonResponse') {
      //responseObj = CommonResponse.fromJson(json);
    }
    return responseObj;
  }

  Future<void> apiRequest(BuildContext context, API api,
      successCallback onSuccess, failureCallback onFailure,
      {dynamic parameter, dynamic params, dynamic path}) async {
    var jsonResponse;
    http.Response response;

    var body = (parameter != null ? json.encode(parameter) : null);

    var url = await this.apiEndPoint(api);
    if (path != null) {
      url = url + path;
    }
    print('URL is $url');

    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    print("header is $headers");

    try {
      if (this.apiHTTPMethod(api) == HTTPMethod.POST) {
        response =
            await http.post(url, body: body, headers: headers).timeout(timeout);
        print(response.body);
        print('response of post');
      } else if (this.apiHTTPMethod(api) == HTTPMethod.GET) {
        response = await http.get(url, headers: headers).timeout(timeout);
        print('response of get');
      } else if (this.apiHTTPMethod(api) == HTTPMethod.PUT) {
        print('body is -' + body);
        response = await http
            .put(
              url,
              body: body,
              headers: headers,
            )
            .timeout(timeout);
      } else if (this.apiHTTPMethod(api) == HTTPMethod.DELETE) {
        response = await http.delete(url, headers: headers).timeout(timeout);
      }

      //TODO : Handle 201 status code as well
      print('Resp is ${response.statusCode}');
      if (response.statusCode == 200) {
        jsonResponse = json.decode(response.body);
        print('BODY is--> $jsonResponse');

        onSuccess(this.parseResponse(this.classNameForAPI(api), jsonResponse));

      } else if (response.statusCode == 201 || response.statusCode == 200) {
        jsonResponse = json.decode(response.body);
        print('Creted Resp dict ${jsonResponse.toString()}');

        onSuccess(this.parseResponse(this.classNameForAPI(api), jsonResponse));
      } else if (response.statusCode == 401) {
        Fluttertoast.showToast(
            msg: "Server not responding",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        var appError = this.parseError(response);
        onFailure(appError);
      }
    } on Exception catch (exception) {
      print('Exception ${exception.toString()}');
      var appError = FetchDataError(exception.toString());

      onFailure(appError);
    } catch (error) {
      print('Exception ${error.toString()}');

      var appError = FetchDataError(error.toString());
      onFailure(appError);
    }
  }

  dynamic parseUploadError(String response, int statusCode) {
    var jsonResponse;
    var message;
    if (response != null && response.length > 0) {
      jsonResponse = json.decode(response);
      if (jsonResponse != null && jsonResponse["status_Message"] != null) {
        message = jsonResponse["status_Message"];
      } else {
        message = response;
      }
    }

    switch (statusCode) {
      case 400:
        return BadRequestError(message);
      case 401:
      case 403:
        return UnauthorisedError(message);
      case 500:
      default:
        return FetchDataError(
            'Error occured while Communication with Server with StatusCode : ${statusCode}');
    }
  }

  dynamic parseError(http.Response response) {
    var jsonResponse;
    var message;

    if (response.body != null && response.body.toString().length > 0) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null && jsonResponse["desc"] != null) {
        message = jsonResponse["desc"];
      } else {
        message = response.body.toString();
      }
    }

    switch (response.statusCode) {
      case 400:
        return BadRequestError(message);
      case 200:
        return MessageError(message);
      case 401:
      case 403:
        return UnauthorisedError(message);
      case 500:
      default:
        return FetchDataError(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
