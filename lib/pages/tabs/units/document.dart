import 'package:flutter/material.dart';

class Document extends StatelessWidget {
  final Map data;

  Document({this.data});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Document')
    );
  }
}