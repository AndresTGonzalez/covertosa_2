// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:covertosa_2/constants.dart';
import 'package:covertosa_2/local_services/database_helper.dart';
import 'package:covertosa_2/models/customers.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

import 'package:http/http.dart' as http;

class CustomersProvider extends ChangeNotifier {
  List<Customers> _customers = [];

  final _databaseHelper = DatabaseHelper();

  // Campos para el CRUD
  String _code = '';
  String _document = '';
  String _name = '';
  String _lastName = '';
  String _phone = '';
  String _address = '';
  String _email = '';

  bool _isLoading = false;

  CustomersProvider() {
    getCustomers();
  }

  List<Customers> get customers => _customers;
  bool get isLoading => _isLoading;

  String get code => _code;
  String get document => _document;
  String get name => _name;
  String get lastName => _lastName;
  String get phone => _phone;
  String get address => _address;
  String get email => _email;

  set code(String value) {
    _code = value;
    notifyListeners();
  }

  set document(String value) {
    _document = value;
    notifyListeners();
  }

  set name(String value) {
    _name = value;
    notifyListeners();
  }

  set lastName(String value) {
    _lastName = value;
    notifyListeners();
  }

  set phone(String value) {
    _phone = value;
    notifyListeners();
  }

  set address(String value) {
    _address = value;
    notifyListeners();
  }

  set email(String value) {
    _email = value;
    notifyListeners();
  }

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future getCustomers() async {
    isLoading = true;
    final db = await _databaseHelper.db;
    final res = await db.rawQuery("SELECT * FROM customers");
    List<Customers> list =
        res.isNotEmpty ? res.map((c) => Customers.fromJson(c)).toList() : [];
    _customers = list;
    isLoading = false;
  }

  // Funciones para el CRUD

  Future addCustomer(Customers customer) async {
    await addCustomerLocal(customer);
    // await sendCustomer(customer);
  }

  Future addCustomerLocal(Customers customer) async {
    _isLoading = true;
    notifyListeners();
    LocationData? locationData = await _getLocation();
    customer.lat = locationData!.latitude.toString();
    customer.lng = locationData.longitude.toString();
    isLoading = true;
    final db = await _databaseHelper.db;
    final res = await db.insert('customers', customer.toJson());
    _customers.add(customer);
    _isLoading = false;
    notifyListeners();
    sendCustomer(customer);
    return res;
  }

  Future deleteCustomerLocal(int id) async {
    _isLoading = true;
    notifyListeners();
    final db = await _databaseHelper.db;
    final res = await db.delete('customers', where: 'id = ?', whereArgs: [id]);
    _customers.removeWhere((customer) => customer.id == id);
    getCustomers();
    _isLoading = false;
    notifyListeners();
    return res;
  }

  Future updateCustomerLocal(Customers customer) async {
    isLoading = true;
    notifyListeners();
    final db = await _databaseHelper.db;
    final res = await db.update('customers', customer.toJson(),
        where: 'id = ?', whereArgs: [customer.id]);
    getCustomers();
    isLoading = false;
    notifyListeners();
    return res;
  }

  // Primero obtener el location
  Future<LocationData?> _getLocation() async {
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return null;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    locationData = await location.getLocation();

    return locationData;
  }

  Future sendCustomer(Customers customer) async {
    _isLoading = true;
    notifyListeners();
    Map<String, dynamic> requestBody = {
      "id": null,
      "address": customer.address,
      "cod": customer.cod,
      "tradename": '${customer.name!} ${customer.lastname!}',
      "document": customer.document,
      "customer_type_id": 2,
      "email": customer.email,
      "lastname": customer.lastname,
      "name": customer.name,
      "phone": customer.phone,
      "route": null,
      "lat": customer.lat ?? 0,
      "lng": customer.lng ?? 0
    };
    String requestBodyJson = jsonEncode(requestBody);
    final resp = await http.post(
      Uri.parse(SET_CUSTOMERS),
      headers: {'Content-Type': 'application/json'},
      body: requestBodyJson,
    );
    if (resp.statusCode == 200) {
      print('Cliente enviado');
      print(resp.body);
    } else {
      print('Error en el envio');
      print(resp.body);
    }
    _isLoading = false;
    notifyListeners();
  }
}
