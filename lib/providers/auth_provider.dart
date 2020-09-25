import 'dart:async';
import 'dart:convert';

import 'package:ShopApp/models/http_exception.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String _token;
  DateTime _expireDate;
  String _userId;
  Timer _authtimer;

  bool get isAuth {
    // return token != null;
    if (token != null) {
      return true;
    }
    return false;
  }

  String get userId {
    return _userId;
  }

  String get token {
    if (_expireDate != null &&
        _expireDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/$urlSegment?key=AIzaSyBIo8gLF_BZFfxwrLe2HNnCOzFEI8WSsRs';

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );
      if (json.decode(response.body)['error'] != null) {
        throw HttpException(json.decode(response.body)['error']['message']);
      }
      _token = json.decode(response.body)['idToken'];
      _userId = json.decode(response.body)['localId'];
      _expireDate = DateTime.now().add(
        Duration(seconds: int.parse(json.decode(response.body)['expiresIn'])),
      );

      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expirydate': _expireDate.toIso8601String(),
      });
      prefs.setString('userData', userData);
    } catch (error) {
      return Future.error(error);
    }
  }

  // Future<void> signup(String email, String password) async {
  //   const url =
  //       'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyBIo8gLF_BZFfxwrLe2HNnCOzFEI8WSsRs';

  //   try {
  //     final response = await http.post(
  //       url,
  //       body: json.encode({
  //         'email': email,
  //         'password': password,
  //         'returnSecureToken': true,
  //       }),
  //     );
  //     if (json.decode(response.body)['error'] != null) {
  //       throw HttpException(json.decode(response.body)['error']['message']);
  //     }

  //     notifyListeners();
  //   } catch (error) {
  //     return Future.error(error);
  //   }
  // }

  // Future<void> login(String email, String password) async {
  //   const url =
  //       'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyBIo8gLF_BZFfxwrLe2HNnCOzFEI8WSsRs';
  //   try {
  //     final response = await http.post(
  //       url,
  //       body: json.encode({
  //         'email': email,
  //         'password': password,
  //         'returnSecureToken': true,
  //       }),
  //     );
  //     if (json.decode(response.body)['error'] != null) {
  //       throw HttpException(json.decode(response.body)['error']['message']);
  //     }
  //     _token = json.decode(response.body)['idToken'];
  //     _userId = json.decode(response.body)['localId'];
  //     _expireDate = DateTime.now().add(
  //       Duration(seconds: int.parse(json.decode(response.body)['expiresIn'])),
  //     );

  //     final prefs = await SharedPreferences.getInstance();
  //     final userData = json.encode({
  //       'token': _token,
  //       'userId': _userId,
  //       'expirydate': _expireDate.toIso8601String(),
  //     });
  //     prefs.setString('userData', userData);
  //   } catch (error) {
  //     return Future.error(error);
  //   }
  //   _autoLogout();
  //   notifyListeners();
  // }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'accounts:signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'accounts:signInWithPassword');
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expireDate = null;
    if (_authtimer != null) {
      _authtimer.cancel();
      _authtimer = null;
    }
  
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void _autoLogout() {
    if (_authtimer != null) {
      _authtimer.cancel();
    }
    final timetoexpiry = _expireDate.difference(DateTime.now()).inSeconds;
    // print(timetoexpiry);//usual expirydate=3600seconds
    _authtimer = Timer(Duration(seconds: timetoexpiry), logout);
  }

  Future<bool> tryLoginAgain() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('userData') == false) {
      return false;
    }

    final extracteduserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extracteduserData['expiryDate']);
    // print(expiryDate);

    if (expiryDate.isAfter(DateTime.now())) {
      return false;
    }

    _token = extracteduserData['token'];
    _userId = extracteduserData['userId'];
    _expireDate = extracteduserData['expiryDate'];
    // print(_token);
    // print(_userId);
    // print(_expireDate);

    notifyListeners();
    _autoLogout();
    return true;
  }
}
