import 'package:shared_preferences/shared_preferences.dart';

class Session {
  void setInt(String name, int value) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(name, value);
  }

  Future<int> getInt(String name) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(name);
  }

  void setString(String name, String value) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(name, value);
  }

  Future<String> getString(String name) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(name);
  }

  void setBool(String name, bool value) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(name, value);
  }

  Future<bool> getBool(String name) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(name);
  }

  void clear() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void reLogin(String msg) async{
    if (msg == 'jwt expired') {
      
    }
  }
  
}