import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:coin_shot/models/GetCryptoList.dart' as crypto;

class SPManager {
  final String authToken = "authToken";
  final String otp = "otp";
  final String email = "Email";
  final String contactId = "contact";
  final String notificationToken = "notificationToken";
  final String token = "token";
  final String password = 'Password';
  final String rememberMe = 'check';
  final String checkInDate = "check-in-date";
  final String checkInID = "check-in-id";
  final String dataVersion = 'data_version';
  final String modelVersion = 'model_version';
  final String userId = 'user_id';
  final String remEmail = 'remEmail';
  final String remPwd = 'remPwd';
  final String remBool = 'remBool';
  final String storeId = "store_id";
  final String userName = 'user_name';
  final String userRole = 'user_role';
  final String empId = 'emp_id';
  final String departmentId = 'depart_id';
  final String firstName = 'first_name';
  final String lastName = 'last_name';
  final String userMobile = 'user_mobile';
  final String userEmail = 'user_email';
  final String role = 'role';
  final String userType = 'user_type';
  final String userDesignation = 'user_designation';

  //to save userinfo
  Future setUserInfo(String key, value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    pref.setString(key, json.encode(value));
  }

  //to fetch user info
  Future getUserInfo(String key) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    return json.decode(pref.getString(key));
  }

  //set auth token into shared preferences
  Future<void> setUserId(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(this.userId, token);
  }

  //get auth token id from shared preferences
  Future<String> getUserId() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String token;
    token = pref.getString(this.userId) ?? null;
    return token;
  }

  //set auth token into shared preferences
  Future<void> setUserNamer(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(this.remEmail, token);
  }

  //get auth token id from shared preferences
  Future<String> getUserNamer() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String token;
    token = pref.getString(this.remEmail) ?? null;
    return token;
  }

  //set auth token into shared preferences
  Future<void> setPwd(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(this.remPwd, token);
  }

  //get auth token id from shared preferences
  Future<String> getPwd() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String token;
    token = pref.getString(this.remPwd) ?? null;
    return token;
  }

  Future<void> setEmpId(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(this.empId, token);
  }

  //get auth token id from shared preferences
  Future<String> getEmpId() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String token;
    token = pref.getString(this.empId) ?? null;
    return token;
  }

  Future<void> setDepartmentId(int token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(this.departmentId, token);
  }

  //get auth token id from shared preferences
  Future<int> getDepartmentId() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    int token;
    token = pref.getInt(this.departmentId) ?? 0;
    return token;
  }

  //set auth token into shared preferences
  Future<void> setAuthToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(this.authToken, token);
  }

  //get auth token into shared preferences
  Future<String> getAuthToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String val;
    val = prefs.getString(this.authToken) ?? null;
    return val;
  }

  //set username into shared preferences
  Future<void> setName(String val) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(this.userName, val);
  }

  //get user name from shared preferences
  Future<String> getUserName() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String val;
    val = pref.getString(this.userName) ?? null;
    return val;
  }

  Future<void> setFN(String val) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(this.firstName, val);
  }

  //get user name from shared preferences
  Future<String> getFN() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String val;
    val = pref.getString(this.firstName) ?? "";
    return val;
  }

  Future<void> setLN(String val) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(this.lastName, val);
  }

  //get user name from shared preferences
  Future<String> getLN() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String val;
    val = pref.getString(this.lastName) ?? "";
    return val;
  }

  Future<void> setMobile(String val) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(this.userMobile, val);
  }

  //get user name from shared preferences
  Future<String> getMobile() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String val;
    val = pref.getString(this.userMobile) ?? "";
    return val;
  }

  Future<void> setEmail(String val) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(this.userEmail, val);
  }

  //get user name from shared preferences
  Future<String> getEmail() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String val;
    val = pref.getString(this.userEmail) ?? "";
    return val;
  }

  //set userrole into shared preferences
  Future<void> setUserRole(int val) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(this.userRole, val);
  }

  //get user role from shared preferences
  Future<int> getUserRole() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    int val;
    val = pref.getInt(this.userRole) ?? null;
    return val;
  }

  //set email id into shared preferences
  Future<void> setEmailId(String email) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(this.email, email);
  }

  //get email id from shared preferences
  Future<String> getEmailid() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(this.email) ?? null;
  }

  //set store id into shared preferences
  Future<void> setStoreId(String val) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(this.storeId, val);
  }

  //get store id from shared preferences
  Future<String> getStoreId() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(this.storeId) ?? null;
  }

  Future<void> setUserType(int val) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(this.userType, val);
  }

  //get userType from shared preferences
  Future<int> getUserType() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getInt(this.userType) ?? null;
  }

  Future<void> setUserDesignation(int val) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(this.userDesignation, val);
  }

  //get userDesignation from shared preferences
  Future<int> getUserDesignation() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getInt(this.userDesignation) ?? null;
  }

  Future<void> setCheckInID(String iD) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(this.checkInID, iD);
  }

  //get email id from shared preferences
  Future<String> getCheckInID() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(this.checkInID) ?? null;
  }

  //set contact id into shared preferences
  Future<void> setContactId(String contact) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(this.contactId, contact);
  }

  //get contact id from shared preferences
  Future<String> getContactId() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(this.contactId) ?? null;
  }

  //set notification token into shared preferences
  Future<void> setNotificationToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(this.notificationToken, token);
  }

  //get notification token id from shared preferences
  Future<String> getNotificationToken() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String notificationToken;
    notificationToken = pref.getString(this.notificationToken) ?? "";
    return notificationToken;
  }

  //set notification token into shared preferences
  Future<void> setToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(this.token, token);
  }

  //get notification token id from shared preferences
  Future<String> getToken() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String notificationToken;
    notificationToken = pref.getString(this.token) ?? "";
    return notificationToken;
  }

  //set password into shared preferences
  Future<void> setRole(String val) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(this.role, val);
  }

  //get role from shared preferences
  Future<String> getRole() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String val;
    val = pref.getString(this.role) ?? null;
    return val;
  }

  //set password into shared preferences
  Future<void> setPassword(String pass) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(this.password, pass);
  }

  //get password from shared preferences
  Future<String> getPassword() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String pass;
    pass = pref.getString(this.password) ?? null;
    return pass;
  }

  //set data version into shared preferences
  Future<void> setDataVersion(String version) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(this.dataVersion, version);
  }

  //get data version from shared preferences
  Future<String> getDataVersion() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String version;
    version = pref.getString(this.dataVersion) ?? "0.0";
    return version;
  }

  //set model version into shared preferences
  Future<void> setModelVersion(String version) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(this.modelVersion, version);
  }

  //get data version from shared preferences
  Future<String> getModelVersion() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String version;
    version = pref.getString(this.modelVersion) ?? "0.0";
    return version;
  }

  //set rememberMe into shared preferences
  Future<void> setRememberme(bool check) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(this.remBool, check);
  }

  //get rememberMe from shared preferences
  Future<bool> getRememberme() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    bool check;
    check = pref.getBool(this.remBool) ?? null;
    return check;
  }

  Future<dynamic> getFromDisk(String key) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    var value = pref.get(key);
    // print('(TRACE) LocalStorageService:_getFromDisk. key: $key value: $value');
    return value;
  }

  Future<void> saveStringToDisk(String key, String content) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    // print(
    //     '(TRACE) LocalStorageService:_saveStringToDisk. key: $key value: $content');
    if (content != null) pref.setString(key, content);
  }

  Future<void> clear() async {
    String token = await getNotificationToken();
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
    setNotificationToken(token);
  }
}
