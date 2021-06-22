import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mysql_uz_v1/model/user_model.dart';
import 'package:mysql_uz_v1/utilits/url.dart';
import 'package:mysql_uz_v1/utilits//shared_preference.dart';


enum Status {
  NotLoggedIn,
  NotRegistered,
  LoggedIn,
  Registered,
  Authenticating,
  Registering,
  LoggedOut
}

class AuthProvider with ChangeNotifier {

  Status _loggedInStatus = Status.NotLoggedIn;
  Status _registeredInStatus = Status.NotRegistered;

  Status get loggedInStatus => _loggedInStatus;
  Status get registeredInStatus => _registeredInStatus;


  Future<Map<String, dynamic>> login(String username, String password) async {
    var result;
    final Map<String, dynamic> loginData = {
        'username': username,
        'password': password
    };

    _loggedInStatus = Status.Authenticating;
    notifyListeners();

    Response response = await post(
      Uri.parse(AppUrl.login),
      body: json.encode(loginData),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body)['user'];
      responseData.addAll({'auth_token' : jsonDecode(response.body)['auth_token']});

      User authUser = User.fromJson(responseData);

      UserPreferences().saveUser(authUser);

      _loggedInStatus = Status.LoggedIn;
      notifyListeners();
      result = {'status': true, 'message': 'Successful', 'user': authUser};
    } else {
      _loggedInStatus = Status.NotLoggedIn;
      notifyListeners();
      result = {
        'status': false,
        'message': jsonDecode(response.body)
      };
    }

    return result;
  }

  Future<Map<String, dynamic>> register(String username, String fullName, String email, String password, String passwordConfirmation) async {
     Map<String, dynamic> result = {};

    final Map<String, dynamic> registrationData = {
        "username": username,
        "fullname": fullName,
        'email': email,
        'password': password,
        'confirm_password': passwordConfirmation
    };
    Response response = await post(
        Uri.parse(AppUrl.register),
        body: json.encode(registrationData),
        headers: {'Content-Type': 'application/json'});

    Map<String, dynamic> responseData = jsonDecode(response.body);
    if (response.statusCode == 201) {
      User authUser = User.fromJson(responseData);
      await UserPreferences().saveUser(authUser);

      result.addAll({
        'status': true,
        'message': 'Successfully registered',
        'data': authUser
      });
    } else {
      result.addAll({
        'status': false,
        'message': 'Registration failed',
        'data': responseData
      });
    }

    return result;
  }

  static Future<Map> onValue(Response response) async {
    Map<String, dynamic> result;
    final Map<String, dynamic> responseData = json.decode(response.body);

    if (response.statusCode == 201) {
      User authUser = User.fromJson(responseData);
      print("WEE");
      print(authUser);
      UserPreferences().saveUser(authUser);

      result.addAll({
        'status': true,
        'message': 'Successfully registered',
        'data': authUser
      });
    } else {
//      if (response.statusCode == 401) Get.toNamed("/login");
      result.addAll({
        'status': false,
        'message': 'Registration failed',
        'data': responseData
      });
    }

    return result;
  }

  static onError(error) {
    print("the error is $error.detail");
    return {'status': false, 'message': 'Unsuccessful Request', 'data': error};
  }

}