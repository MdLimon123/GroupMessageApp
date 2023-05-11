import 'package:shared_preferences/shared_preferences.dart';

class HelperFuncation {
  static String userLoggedInKey = "LOGGDIDKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";

  static Future<bool> saveUserLoggedInStatus(bool isUserLoggedIn) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.setBool(userLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> saveUserNameStatus(String userName) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.setString(userNameKey, userName);
  }

  static Future<bool> saveUserEmailStatus(String userEmail) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.setString(userEmailKey, userEmail);
  }

  static Future<bool?> getUserLoggedInStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userLoggedInKey);
  }
}
