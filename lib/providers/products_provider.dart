import 'package:covertosa_2/local_services/database_helper.dart';
import 'package:covertosa_2/models/products.dart';
import 'package:flutter/material.dart';

class ProductsProvider extends ChangeNotifier {
  List<Products> _products = [];

  final _databaseHelper = DatabaseHelper();

  bool _isLoading = false;

  ProductsProvider() {
    getProducts();
  }

  List<Products> get products => _products;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future getProducts() async {
    isLoading = true;
    final db = await _databaseHelper.db;
    final res = await db.rawQuery("SELECT * FROM products");
    List<Products> list =
        res.isNotEmpty ? res.map((c) => Products.fromJson(c)).toList() : [];
    _products = list;
    isLoading = false;
  }
}
