import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:obi_mobile/libraries/check_internet.dart';
import 'package:obi_mobile/models/m_article.dart';
import 'package:obi_mobile/repository/article_repo.dart';

class TermCondition extends StatefulWidget {
  static String tag = 'term-condition';
  static String name = 'Syarat dan Ketentuan';

  @override
  _TermConditionState createState() => _TermConditionState();
}

class _TermConditionState extends State<TermCondition> {
  // class
  CheckInternet _checkInternet = CheckInternet();
  
  @override
  void initState() {
    super.initState();
    _checkInternet.check(context);
  }

  @override
  Widget build(BuildContext context) {
    ArticleRepo _articleRepo = ArticleRepo();

    final _dataHtml = FutureBuilder<M_Article>(
      future: _articleRepo.termCondition(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          String _html = snapshot.data.getStringData();
          return Html(
            data: _html,
          );
        }
        else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      }
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(TermCondition.name),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        child: _dataHtml,
      ),
    );
  }
}