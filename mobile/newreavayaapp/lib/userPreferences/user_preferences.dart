import 'dart:convert';

import '../model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RememberUserPrefs {
  static Future<void> storeUserInfo(User userInfo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userJsonData = jsonEncode(userInfo.toJson());
    await prefs.setString('currentUser', userJsonData);
  }

  static Future<User?> readUserInfo() async {
    User? currentUserInfo;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userInfo = prefs.getString('currentUser');
    if (userInfo != null) {
      Map<String, dynamic> userDataMap = jsonDecode(userInfo);
      currentUserInfo = User.fromJson(userDataMap);
    }
    return currentUserInfo;
  }

  static Future<void> clearUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('currentUser');
  }
}
