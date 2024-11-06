import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  // Future<void> setFirstInstall() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setBool('isFirstInstall', true);
  // }

  // Future<bool> getFirstInstall() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final firstInstall = prefs.getBool('isFirstInstall') ?? false;
  //   return firstInstall;
  // }

  Future<void> setCarbonValue(String carbonValue) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('carbonValue', carbonValue);
  }

  Future<String> getCarbonValue() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('carbonValue') ?? '--';
  }

  Future<void> setIndexValue(String carbonIndex) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('carbonIndex', carbonIndex);
  }

  Future<String> getIndexValue() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('carbonIndex') ?? '--';
  }

  Future<void> setLastUpdatedValue(String lastUpdated) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('lastUpdated', lastUpdated);
  }

  Future<String> getLastUpdatedValue() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('lastUpdated') ?? '--';
  }
}
