import 'dart:convert';

import 'package:covertosa_2/constants.dart';
import 'package:covertosa_2/local_services/database_helper.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';

class AuthServices {
  final storage = const FlutterSecureStorage();
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  // Ofline services
  Future<User?> loginOffline({
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

  Future<int> registerUserLocaly(User user) async {
    var dbClient = await _databaseHelper.db;
    // Verificar si el usuario ya existe
    var res = await dbClient
        .rawQuery("SELECT * FROM users WHERE email = '${user.email}'");
    if (res.isNotEmpty) {
      return -1;
    } else {
      int result = await dbClient.insert("users", user.toJson());
      return result;
    }
  }

  // Online services
  Future<User?> loginOnline({
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
}
