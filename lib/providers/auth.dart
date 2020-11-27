import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:proapptive/helpers/credentials_manager.dart';
import 'package:proapptive/models/http_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _email;
  String _userId;
  Timer _authTimer;

  Future<void> _authSegment(
    String email,
    String password,
    String url,
  ) async {
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpCustomException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _email = email;
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate.toIso8601String(),
        'email': _email,
      });
      prefs.setString(
        'userData',
        userData,
      );
    } on HttpCustomException catch (error) {
      print(error);
      throw HttpCustomException(error.message);
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Future<void> signup(
    String email,
    String password,
  ) async {
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=${CredentialsManager.GOOGLE_FIREBASE_KEY}';
    return this._authSegment(
      email,
      password,
      url,
    );
  }

  Future<void> login(String email, String password) async {
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=${CredentialsManager.GOOGLE_FIREBASE_KEY}';
    return _authSegment(email, password, url);
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData = json.decode(prefs.getString('userData'));
    final DateTime expiration = DateTime.parse(extractedUserData['expiryDate']);
    if (!expiration.isAfter(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _expiryDate = expiration;
    _userId = extractedUserData['userId'];
    _email = extractedUserData['email'];
    notifyListeners();
    _autoLogout();
    return true;
  }

  String get token {
    if (_token != null &&
        _expiryDate != null &&
        _expiryDate.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
  }

  bool get isAuth {
    if (token != null) {
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final int timeToExpire = _expiryDate
        .difference(
          DateTime.now(),
        )
        .inSeconds;
    _authTimer = Timer(
      Duration(
        seconds: timeToExpire,
      ),
      logout,
    );
  }

  String get userId {
    return _userId;
  }

  String get userEmail {
    return _email;
  }
}
