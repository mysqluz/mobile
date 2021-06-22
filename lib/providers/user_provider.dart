import 'package:flutter/foundation.dart';
import 'package:mysql_uz_v1/model/user_model.dart';

class UserProvider with ChangeNotifier {
  User _user = new User();

  User get user => _user;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }
}