import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import '../model/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  String _userId;
  DateTime _expiryDate;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }

    return null;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    const String api = 'AIzaSyAZnHjxzbhodkbq5c253sazaMc4GXIYF3c';
    final String url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=$api';
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));
      final resBody = json.decode(response.body);
      if (resBody['error'] != null) {
        throw HttpsException(resBody['error']['message']);
      }

      _token = resBody['idToken'];
      _userId = resBody['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(resBody['expiresIn'])));

      print(token);
      print(_userId);
      print(_expiryDate);

      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> signup(String email, String password) async {
//    signUp
    return _authenticate(email, password, 'signUp');
  }

  Future<void> signin(String email, String password) async {
    //signInWithPassword
    return _authenticate(email, password, 'signInWithPassword');
  }
}
