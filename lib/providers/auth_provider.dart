import 'dart:convert';

import 'package:covertosa_2/constants.dart';
import 'package:covertosa_2/local_services/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;

import '../models/user.dart';

class AuthProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final storage = const FlutterSecureStorage();

  final DatabaseHelper _databaseHelper = DatabaseHelper();

  String _user = '';
  String _password = '';
  String _name = '';
  bool _isLoading = false;

  String get user => _user;
  String get password => _password;
  String get name => _name;
  bool get isLoading => _isLoading;

  set user(String value) {
    _user = value;
    notifyListeners();
  }

  set password(String value) {
    _password = value;
    notifyListeners();
  }

  set name(String value) {
    _name = value;
    notifyListeners();
  }

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }

  AuthProvider() {
    readValues();
  }

  Future<User?> login({
    required bool isOnline,
    required BuildContext context,
  }) async {
    isLoading = true;
    if (!isValidForm()) {
      isLoading = false;
      return null;
    }
    if (isOnline) {
      final user = await _loginOnline(
        user: _user,
        password: _password,
      );
      if (user != null) {
        await _registerUser(user);
        _isLoading = false;
        notifyListeners();
        try {
          _loginStorage(
            user: user.email!,
            password: user.password!,
            name: user.name!,
            id: user.userid!,
          );
          print('Usuario registrado');
        } catch (e) {
          print(e);
        }
        return user;
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Usuario o contraseña incorrectos'),
          ),
        );
        _isLoading = false;
        notifyListeners();
        return null;
      }
    } else {
      final user = await _loginOffline(
        user: _user,
        password: _password,
      );
      if (user != null) {
        _isLoading = false;
        notifyListeners();
        try {
          _loginStorage(
            user: user.email!,
            password: user.password!,
            name: user.name!,
            id: user.userid!,
          );
        } catch (e) {
          print(e);
        }
        return user;
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Usuario o contraseña incorrectos'),
          ),
        );
        _isLoading = false;
        notifyListeners();
        return null;
      }
    }
  }

  Future<User?> _loginOnline({
    required String user,
    required String password,
  }) async {
    try {
      final resp = await http.post(Uri.parse(LOGIN_URL), body: {
        'email': user,
        'password': password,
      });
      final Map<String, dynamic> responseJSON = json.decode(resp.body);
      if (responseJSON['status'] == "ok") {
        final Map<String, dynamic> userData = responseJSON['data'];
        final fin = User.fromJson(userData);

        User userReturn = User(
          userid: fin.userid,
          email: user,
          password: password,
          name: fin.name,
          surname: fin.surname,
        );
        return userReturn;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<User?> _loginOffline({
    required String user,
    required String password,
  }) async {
    var dbClient = await _databaseHelper.db;
    var res = await dbClient.rawQuery(
        "SELECT * FROM users WHERE email = '$user' and password = '$password'");

    if (res.isNotEmpty) {
      return User.fromJson(res.first);
    } else {
      return null;
    }
  }

  Future<int> _registerUser(User user) async {
    var dbClient = await _databaseHelper.db;
    int res = await dbClient.insert("users", user.toJson());
    return res;
  }

  // Manejo de la sesion

  Future<void> _loginStorage({
    required String user,
    required String password,
    required String name,
    required int id,
  }) async {
    storage.write(key: 'user', value: user);
    storage.write(key: 'password', value: password);
    storage.write(key: 'name', value: name);
    storage.write(key: 'id', value: id.toString());
  }

  Future<void> logout() async {
    await storage.deleteAll();
  }

  Future<void> readValues() async {
    _user = await storage.read(key: 'user') ?? '';
    _name = await storage.read(key: 'name') ?? '';
    notifyListeners();
  }

  Future<String> isLogged() async {
    return await storage.read(key: 'user') ?? '';
  }
}
