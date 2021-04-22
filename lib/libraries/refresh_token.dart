import 'dart:async';

import 'package:obi_mobile/libraries/session.dart';
import 'package:obi_mobile/repository/user_repo.dart';

class RefreshToken {
  Session _session = new Session();
  UserRepo _userRepo = new UserRepo();
  
  DateTime now;

  run() async{
    final _now = DateTime.now();
    final _diff = _now.difference(this.now).inSeconds;
    int _delay = await this._session.getInt("expireIn");
    if (_diff > _delay) {
      await refreshToken();
    }
  }

  refreshToken() async{
      String _username = await this._session.getString("username");
      String _password = await this._session.getString("password");
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

    return this;
  }

}