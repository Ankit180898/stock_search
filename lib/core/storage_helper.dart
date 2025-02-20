import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_search/core/constants.dart';

class StorageHelper {
  
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> saveToken(String token) async {
    await _prefs.setString(AppConstants.tokenKey, token);
  }

  static String? getToken() {
    return _prefs.getString(AppConstants.tokenKey);
  }

  static Future<void> clearToken() async {
    await _prefs.remove(AppConstants.tokenKey);
  }

  static bool isLoggedIn() {
    return getToken() != null;
  }
}