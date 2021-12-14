import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:obi_mobile/configs/config.dart' as config;
import 'package:obi_mobile/models/m_npl.dart';
import 'package:obi_mobile/libraries/session.dart';

class NplRepo {
  
  final String apiUrl = config.API_URL;

  Future<M_Npl> list() async{
    
    Session _session = new Session();
    String token = await _session.getString('token');

    Map<String, String> header = {
      "Content-Type": "application/json",
      "Authorization": "Bearer " + token
    };

    final response = await http.post(
      Uri.http(apiUrl, 'npl'),
      headers: header
    );

    if (response.statusCode==200) {
      return M_Npl.fromJson(jsonDecode(response.body));
    }
    else {
      throw Exception('Connect to Api Failed');
    }
  }

  Future<M_Npl> activeNpl(params) async{
    
    Session _session = new Session();
    String token = await _session.getString('token');

    final data = jsonEncode(params);

    Map<String, String> header = {
      "Content-Type": "application/json",
      "Authorization": "Bearer " + token
    };

    final response = await http.post(
      Uri.http(apiUrl, 'active-npl'),
      headers: header,
      body: data
    );

    if (response.statusCode==200) {
      return M_Npl.fromJson(jsonDecode(response.body));
    }
    else {
      throw Exception('Connect to Api Failed');
    }
  }

  Future<M_Npl> create(params, fileTransfer) async{
    
    Session _session = new Session();
    String token = await _session.getString('token');
    Map<String, String> header = {
      "Authorization": "Bearer " + token
    };

    final request = await http.MultipartRequest('POST', Uri.http(apiUrl, 'npl/create'));
    request.fields.addAll({
      'auction_id': params['auction_id'],
      'type': params['type'],
      'an': params['an'],
      'deposit': params['deposit'],
      'qty': params['qty'],
      'nominal': params['nominal'],
    });
    request.headers.addAll(header);

    if (fileTransfer != null) {
      request.files.add(await http.MultipartFile.fromPath('attach', fileTransfer.path.toString()));
    }

    final response = await request.send();
    final res = await response.stream.bytesToString();
    
    if (response.statusCode==200) {
      return M_Npl.fromJson(jsonDecode(res));
    }
    else {
      throw Exception('Connect to Api Failed');
    }
  }
   
}