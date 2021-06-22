import 'package:mysql_uz_v1/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class UserPreferences {

  // String username, String email, String firstName, String lastName, String authToken, String avatar, int ball
  Future<bool> saveUser(User user) async {
    final SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.setString("username", user.username);
    localStorage.setString("email", user.email ?? "");
    localStorage.setString("fullName", user.fullName);
    localStorage.setString("auth_token", user.authToken);
    localStorage.setString("avatar", user.avatar ?? "");
    localStorage.setInt('ball', user.ball ?? 0);

    // ignore: deprecated_member_use
    return localStorage.commit();
  }

  Future<User> getUser() async {
    final SharedPreferences localStorage = await SharedPreferences.getInstance();

    String name = localStorage.getString("username");
    String email = localStorage.getString("email");
    String fullName = localStorage.getString("fullName");
    String token = localStorage.getString("auth_token");
    String avatar = localStorage.getString("avatar");
    int ball = localStorage.getInt("ball");

    return User(
        username: name,
        email: email,
        fullName: fullName,
        authToken: token,
        avatar: avatar,
        ball: ball
    );
  }

  void removeUser() async {
    final SharedPreferences localStorage = await SharedPreferences.getInstance();

    localStorage.remove("username");
    localStorage.remove("email");
    localStorage.remove("firstName");
    localStorage.remove("lastName");
    localStorage.remove("auth_token");
    localStorage.remove("avatar");
    localStorage.remove("ball");
  }

  Future<String> getToken() async {
    final SharedPreferences localStorage = await SharedPreferences.getInstance();
    String token = localStorage.getString("auth_token");
    return token;
  }
}
