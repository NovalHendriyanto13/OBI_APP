import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:obi_mobile/configs/config.dart' as config;
import 'package:obi_mobile/models/m_user.dart';
import 'package:obi_mobile/libraries/session.dart';

class UserRepo {
  
  final String apiUrl = config.API_URL;

  Future<M_User> login(String username, String password) async{
    final data = jsonEncode({
      "username": username,
      "password": password
    });

    Map<String, String> header = {"Content-Type": "application/json"};

    final response = await http.post(
      Uri.http(apiUrl, 'login'),
      headers: header,
      body: data
    );

    if (response.statusCode==200) {
      return M_User.fromJson(jsonDecode(response.body));
    }
    else {
      throw Exception('Connect to Api Failed');
    }
  }

  Future<M_User> changePassword(String oldPassword, String newPassword, String rePassword) async{
    final data = jsonEncode({
      "old_password": oldPassword,
      "password": newPassword,
      "re_password": rePassword
    });

    Session _session = new Session();
    String token = await _session.getString('token');

    Map<String, String> header = {
      "Content-Type": "application/json",
      "Authorization": "Bearer " + token
    };

    final response = await http.post(
      Uri.http(apiUrl, 'change-password'),
      headers: header,
      body: data
    );

    if (response.statusCode==200) {
      return M_User.fromJson(jsonDecode(response.body));
    }
    else {
      throw Exception('Connect to Api Failed');
    }
  }

  Future<M_User> detail() async{
    
    Session _session = new Session();
    String token = await _session.getString('token');
    int id = await _session.getInt('id');

    Map<String, String> header = {
      "Content-Type": "application/json",
      "Authorization": "Bearer " + token
    };

    final response = await http.post(
      Uri.http(apiUrl, 'user/' + id.toString()),
      headers: header,
    );

    if (response.statusCode==200) {
      return M_User.fromJson(jsonDecode(response.body));
    }
    else {
      throw Exception('Connect to Api Failed');
    }
  }

  Future<M_User> update(data) async{
    
    Session _session = new Session();
    String token = await _session.getString('token');
    int id = await _session.getInt('id');

    Map<String, String> header = {
      "Content-Type": "application/json",
      "Authorization": "Bearer " + token
    };

    final response = await http.post(
      Uri.http(apiUrl, 'user/update/' + id.toString()),
      headers: header,
      body: data
    );

    if (response.statusCode==200) {
      return M_User.fromJson(jsonDecode(response.body));
    }
    else {
      throw Exception('Connect to Api Failed');
    }
  }

  Future<M_User> forgot(email) async{

    final data = jsonEncode({
      "email": email
    });
    Map<String, String> header = {
      "Content-Type": "application/json"
    };

    final response = await http.post(
      Uri.http(apiUrl, 'forgot-password'),
      headers: header,
      body: data
    );

    if (response.statusCode==200) {
      return M_User.fromJson(jsonDecode(response.body));
    }
    else {
      throw Exception('Connect to Api Failed');
    }
  }
  
}