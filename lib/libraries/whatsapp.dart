import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:obi_mobile/configs/config.dart' as config;

class Whatsapp {
  BuildContext _context;
  final String _waPhone = config.waPhone;
  final String _waUrlAndroid = "whatsapp://send";
  final String _waUrlIos ="https://wa.me/";

  Whatsapp(BuildContext context) {
    this._context = context;
  }

  void openWhatsapp(String msg) async{
    if(Platform.isIOS){
      // for iOS phone only
      String ios = _waUrlIos + _waPhone + "?text=${Uri.parse(msg)}";
      if( await canLaunch(ios)){
        await launch(ios, forceSafariVC: false);
      }else{
        ScaffoldMessenger.of(this._context).showSnackBar(
            SnackBar(content: new Text("Whatsapp no installed")));

      }

    }else{
      // android , web
      String android = _waUrlAndroid + "?phone="+_waPhone+"&text=" + msg;
      if( await canLaunch(android)){
        await launch(android);
      }else{
        ScaffoldMessenger.of(this._context).showSnackBar(
            SnackBar(content: new Text("whatsapp no installed")));

      }
    }
  }
}