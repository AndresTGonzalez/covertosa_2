import 'dart:io';

import 'package:covertosa_2/local_services/tables_bd.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';

// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  static Database? _db;
  static Batch? _batch = _db?.batch();

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await _initDb();
    return _db!;
  }

  Future<Batch?> get batch async {
    if (_batch != null) {
      return _batch;
    }
    _batch = await _initDb();
    return _batch;
  }

  DatabaseHelper.internal();

  _initDb() async {
    try {
      Directory documentDirectory = await getApplicationDocumentsDirectory();
      String path = join(documentDirectory.path, "data_covertosa.db");
      var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
      return ourDb;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _onCreate(Database db, int version) async {
    await db.execute(TablesBd.crearTablaUsers);
    await db.execute(TablesBd.crearTablaOrders);
    await db.execute(TablesBd.crearTablaOrderDetails);
    await db.execute(TablesBd.crearTablaCustomers);
    await db.execute(TablesBd.crearTablaCategories);
    await db.execute(TablesBd.crearTablaProdusts);
    await db.execute(TablesBd.crearTablaProductsDetails);
    await db.execute(TablesBd.crearTradeRoutes);
    debugPrint("Tablas creadas");
  }
}
