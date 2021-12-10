// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

LoginResponse loginResponseFromJson(String str) => LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
    LoginResponse({
        this.loginList,
        this.response,
    });

    LoginList loginList;
    Response response;

    factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        loginList: LoginList.fromJson(json["LoginList"] == null ? {} : json["LoginList"]),
        response: Response.fromJson(json["Response"]),
    );

    Map<String, dynamic> toJson() => {
        "LoginList": loginList.toJson(),
        "Response": response.toJson(),
    };
}

class LoginList {
    LoginList({
        this.username,
        this.password,
        this.ipAddress,
        this.userId,
        this.title,
        this.fName,
        this.mName,
        this.lName,
        this.email,
        this.mobileNo,
        this.dob,
        this.marriageDate,
        this.departmentId,
        this.departmentName,
        this.cityId,
        this.doj,
        this.fromDate,
        this.toDate,
        this.active,
        this.status,
        this.cityName,
        this.token,
        this.employeeId,
    });

    dynamic username;
    dynamic password;
    dynamic ipAddress;
    String userId;
    String title;
    String fName;
    String mName;
    String lName;
    String email;
    String mobileNo;
    String dob;
    String marriageDate;
    int departmentId;
    dynamic departmentName;
    int cityId;
    String doj;
    dynamic fromDate;
    dynamic toDate;
    int active;
    dynamic status;
    dynamic cityName;
    dynamic token;
    String employeeId;

    factory LoginList.fromJson(Map<String, dynamic> json) => LoginList(
        username: json["Username"],
        password: json["Password"],
        ipAddress: json["IpAddress"],
        userId: json["UserId"],
        title: json["Title"],
        fName: json["FName"],
        mName: json["MName"],
        lName: json["LName"],
        email: json["Email"],
        mobileNo: json["MobileNo"],
        dob: json["DOB"],
        marriageDate: json["MarriageDate"],
        departmentId: json["DepartmentId"],
        departmentName: json["Department_Name"],
        cityId: json["CityId"],
        doj: json["DOJ"],
        fromDate: json["FromDate"],
        toDate: json["ToDate"],
        active: json["Active"],
        status: json["Status"],
        cityName: json["CityName"],
        token: json["Token"],
        employeeId: json["EmployeeId"],
    );

    Map<String, dynamic> toJson() => {
        "Username": username,
        "Password": password,
        "IpAddress": ipAddress,
        "UserId": userId,
        "Title": title,
        "FName": fName,
        "MName": mName,
        "LName": lName,
        "Email": email,
        "MobileNo": mobileNo,
        "DOB": dob,
        "MarriageDate": marriageDate,
        "DepartmentId": departmentId,
        "Department_Name": departmentName,
        "CityId": cityId,
        "DOJ": doj,
        "FromDate": fromDate,
        "ToDate": toDate,
        "Active": active,
        "Status": status,
        "CityName": cityName,
        "Token": token,
        "EmployeeId": employeeId,
    };
}

class Response {
    Response({
        this.msg,
        this.n,
        this.rStatus,
        this.userId,
        this.userName,
        this.ipara11,
        this.ipara1,
        this.ipara2,
        this.ipara3,
        this.ispara1,
        this.ispara2,
        this.ispara3,
        this.ispara4,
        this.ispara5,
        this.ispara6,
        this.ispara7,
        this.ispara8,
        this.ispara9,
    });

    String msg;
    int n;
    dynamic rStatus;
    int userId;
    dynamic userName;
    int ipara11;
    dynamic ipara1;
    dynamic ipara2;
    dynamic ipara3;
    String ispara1;
    String ispara2;
    String ispara3;
    String ispara4;
    dynamic ispara5;
    dynamic ispara6;
    dynamic ispara7;
    dynamic ispara8;
    dynamic ispara9;

    factory Response.fromJson(Map<String, dynamic> json) => Response(
        msg: json["Msg"],
        n: json["n"],
        rStatus: json["RStatus"],
        userId: json["UserId"],
        userName: json["UserName"],
        ipara11: json["ipara11"],
        ipara1: json["ipara1"],
        ipara2: json["ipara2"],
        ipara3: json["ipara3"],
        ispara1: json["ispara1"],
        ispara2: json["ispara2"],
        ispara3: json["ispara3"],
        ispara4: json["ispara4"],
        ispara5: json["ispara5"],
        ispara6: json["ispara6"],
        ispara7: json["ispara7"],
        ispara8: json["ispara8"],
        ispara9: json["ispara9"],
    );

    Map<String, dynamic> toJson() => {
        "Msg": msg,
        "n": n,
        "RStatus": rStatus,
        "UserId": userId,
        "UserName": userName,
        "ipara11": ipara11,
        "ipara1": ipara1,
        "ipara2": ipara2,
        "ipara3": ipara3,
        "ispara1": ispara1,
        "ispara2": ispara2,
        "ispara3": ispara3,
        "ispara4": ispara4,
        "ispara5": ispara5,
        "ispara6": ispara6,
        "ispara7": ispara7,
        "ispara8": ispara8,
        "ispara9": ispara9,
    };
}
