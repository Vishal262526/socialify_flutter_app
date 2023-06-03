import 'package:shared_preferences/shared_preferences.dart';

class HelperFunction {
  // key
  static String userLoggedInKey = "LOGGEDINKEY";
  static String usernamekey = "USERNAMEKEY";
  static String userEmailkey = "USEREMAILKEY";

  // Saving the user status share preferences
  static Future<bool> saveUserLoggedInStatusToSharedPreferences(
      bool isUserLoggedIn) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(userLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> saveUsernameToSharedPreferences(String username) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(usernamekey, username);
  }

  static Future<bool> saveUserEmailToSharedPreferences(String userEmail) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userEmailkey, userEmail);
  }

  // Getting the data from shared preferenences
  static Future<bool?> getUserLoggedInStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userLoggedInKey);
  }

  // Get the User Name from Shared Preferences
  static Future<String?> getUsernameFromSharedPreferences() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(usernamekey);
  }

  // Get the User Email from Shared Preferences
  static Future<String?> getUserEmailFromSharedPreferences() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userEmailkey);
  }
}
