import 'package:intl/intl.dart';
import 'package:obi_mobile/libraries/session.dart';
import 'package:obi_mobile/repository/user_repo.dart';

class RefreshToken {
  Session _session = new Session();
  UserRepo _userRepo = new UserRepo();
  
  DateTime now;

  run() async{
    final _now = DateTime.now();
    final _nowDt = DateFormat('yyyy-MM-dd hh:mm').format(_now);
    final _validTokenTime = await this._session.getString('valid_token');
    final _expireIn = await this._session.getInt('expireIn');

    final _d1 = DateTime.parse(_nowDt);
    final _d2 = DateTime.parse(_validTokenTime);

    final _diff = _d2.difference(_d1).inSeconds;
    if (_diff < 0) {
      await refreshToken();
    }
  }

  refreshToken() async{
      String _username = await this._session.getString("username");
      String _password = await this._session.getString("pass");
      String token;
      int expireIn;

      this._userRepo.login(_username, _password).then((value) {
        bool isLogin = value.getStatus();
        if (isLogin == true) {
          Map data = value.getData();
          token = data['token'];
          expireIn = data['expire_in'];

          _session.setString('token', token);
          _session.setInt('expireIn', expireIn);
          _session.setBool('isLogin', isLogin);

          this.setTime();

        }
      });
  }

  setTime() async{
    DateTime _now = DateTime.now();
    int _delay = await this._session.getInt("expireIn");
    var _duration = Duration(seconds: _delay);
    DateTime _validTime = _now.add(_duration);

    this.now = _validTime;
    String _dtValid = DateFormat('yyyy-MM-dd hh:mm').format(_validTime);
    _session.setString('valid_token', _dtValid);

    return this;
  }

}