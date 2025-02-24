import 'package:get/get.dart';
import 'package:reavaya_app/userPreferences/user_preferences.dart';
import '../model/user.dart';

class CurrentUser extends GetxController {
  //for managing balance
  RxInt pointsBalance = 0.obs;

  final Rx<User> _currentUser = User(
    0,
    '',
    '',
    '',
    '',
    0,
    0,
    0,
    DateTime.timestamp(),
    0,
    DateTime.timestamp(),
    DateTime.timestamp(),
    '',
  ).obs;
  User get user => _currentUser.value;

  getUserInfo() async {
    User? getUserInfoFromLocalStorage = await RememberUserPrefs.readUserInfo();
    _currentUser.value = getUserInfoFromLocalStorage!;
  }

  void logout() async {
    // Clear the current user info from SharedPreferences
    await RememberUserPrefs.clearUserInfo();
    _currentUser.value = User(0, '', '', '', '', 0, 0, 0, DateTime.now(), 0,
      DateTime.now(), DateTime.now(), '',);
  }

  void updateUserInfo() {
    getUserInfo();
  }
}
