// ignore_for_file: avoid_print

import 'package:covertosa_2/services/services.dart';
import 'package:covertosa_2/utils/snackbar_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/user.dart';

class AuthProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final storage = const FlutterSecureStorage();
  final AuthServices _authServices = AuthServices();

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
    required BuildContext context,
  }) async {
    bool isOnline = await NetworkStatusServices().getNetworkStatus();
    isLoading = true;
    if (!isValidForm()) {
      isLoading = false;
      return null;
    }
    if (isOnline) {
      final user = await _authServices.loginOnline(
        user: _user,
        password: _password,
      );
      if (user != null) {
        await _authServices.registerUserLocaly(user);
        _isLoading = false;
        notifyListeners();
        try {
          _loginStorage(
            user: user.email!,
            password: user.password!,
            name: user.name!,
            id: user.userid!,
          );
          debugPrint('Usuario registrado');
        } catch (e) {
          print(e);
        }
        // ignore: use_build_context_synchronously
        SnackbarMessage.show(
          context: context,
          message: 'Bienvenido ${user.name}',
          isError: false,
        );
        return user;
      } else {
        // ignore: use_build_context_synchronously
        SnackbarMessage.show(
          context: context,
          message: 'Usuario o contraseña incorrectos',
          isError: true,
        );
        _isLoading = false;
        notifyListeners();
        return null;
      }
    } else {
      print('Login offline');
      final user = await _authServices.loginOffline(
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
        SnackbarMessage.show(
          context: context,
          message: 'Usuario o contraseña incorrectos',
          isError: true,
        );
        _isLoading = false;
        notifyListeners();
        return null;
      }
    }
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
