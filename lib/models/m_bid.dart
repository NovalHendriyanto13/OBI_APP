class M_Bid {
  final _body;
  final bool _status;
  final _msg;

  M_Bid(this._status, this._body, this._msg);

  factory M_Bid.fromJson(Map<String, dynamic> map) {
    return M_Bid(
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

  List<dynamic> getData() {
    return this._body;
  }

  Map<String, dynamic> getDataMap() {
    return this._body;
  }

}