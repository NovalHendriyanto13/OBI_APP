class M_Article {
  final _body;
  final bool _status;
  final _msg;

  M_Article(this._status, this._body, this._msg);

  factory M_Article.fromJson(Map<String, dynamic> map) {
    return M_Article(
      map['status'], 
      map['data'],
      map['message']
    );
  }

  @override
  String toString() {
    return this._body.toString();
  }

  bool getStatus() {
    return this._status;
  }

  Map<String, dynamic> getMessage() {
    if (this._msg == null) {
      return null;
    }

    return this._msg;
  }

  Map<String, dynamic> getData() {
    return this._body;
  }

  List<dynamic> getListData() {
    return this._body;
  }

  String getStringData() {
    return this._body;
  }
}