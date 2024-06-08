import 'package:covertosa_2/constants.dart';
import 'package:covertosa_2/local_services/database_helper.dart';
import 'package:covertosa_2/models/customers.dart';
import 'package:covertosa_2/models/products.dart';
import 'package:covertosa_2/models/trade_routes.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SyncProvider extends ChangeNotifier {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final storage = const FlutterSecureStorage();

  int userId = 0;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  SyncProvider() {
    _getUserId();
  }

  Future _getUserId() async {
    userId = int.parse(await storage.read(key: 'id') as String);
  }

  Future<bool> sync() async {
    isLoading = true;
    bool result =
        await syncCustomers() && await _syncRoutes() && await syncProducts();
    isLoading = false;
    return result;
  }

  Future<bool> _syncRoutes() async {
    try {
      _clearLocalRoutes();
      await _getRoutes();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> syncCustomers() async {
    try {
      _clearLocalCustomers();
      await _getCustomers();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> syncProducts() async {
    try {
      _clearLocalProducts();
      await _getProducts();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<dynamic>?> _getRoutes() async {
    Response response =
        await Dio().get(GET_TRADE_SELLER_ROUTE + userId.toString());

    if (!response.data.isEmpty) {
      return (response.data['data'] as List).map((route) {
        _insertRoute(TradeRoutes.fromJson(route));
      }).toList();
    }
    return null;
  }

  _insertRoute(TradeRoutes route) async {
    var dbClient = await _databaseHelper.db;
    var res = await dbClient.insert("trade_routes", route.toJson());
    return res;
  }

  Future<List<dynamic>?> _getCustomers() async {
    Response response =
        await Dio().get(GET_CUSTOMERS_ROUTE + userId.toString());

    if (!response.data.isEmpty) {
      return (response.data['data'] as List).map((customer) {
        _insertCustomer(Customers.fromJson(customer));
      }).toList();
    }
    return null;
  }

  _insertCustomer(Customers customer) async {
    var dbClient = await _databaseHelper.db;
    var res = await dbClient.insert("customers", customer.toJson());
    return res;
  }

  Future<List<dynamic>?> _getProducts() async {
    Response response = await Dio().get('$GET_PRODUCTS/1');

    if (!response.data.isEmpty) {
      return (response.data['data'] as List).map((product) {
        _insertProduct(Products.fromJson(product));
      }).toList();
    }
    return null;
  }

  _insertProduct(Products product) async {
    var dbClient = await _databaseHelper.db;
    var res = await dbClient.insert("products", product.toJson());
    return res;
  }

  // Metodo para limpiar las rutas de la base local
  Future<bool> _clearLocalRoutes() async {
    final db = await _databaseHelper.db;
    final res = await db.rawDelete('DELETE FROM trade_routes');
    if (res == 0) {
      return false;
    }
    return true;
  }

  // Metodo para limpiar los clientes de la base local
  Future<bool> _clearLocalCustomers() async {
    final db = await _databaseHelper.db;
    final res = await db.rawDelete('DELETE FROM customers');
    if (res == 0) {
      return false;
    }
    return true;
  }

  // Metodo para limpiar los productos de la base local
  Future<bool> _clearLocalProducts() async {
    final db = await _databaseHelper.db;
    final res = await db.rawDelete('DELETE FROM products');
    if (res == 0) {
      return false;
    }
    return true;
  }
}
