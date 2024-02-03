import 'dart:convert';

import 'package:covertosa_2/constants.dart';
import 'package:covertosa_2/local_services/database_helper.dart';
import 'package:covertosa_2/models/customers.dart';
import 'package:covertosa_2/models/orders.dart';
import 'package:covertosa_2/models/products.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:location/location.dart';

class OrderProvider extends ChangeNotifier {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Customers _customer = Customers();
  Orders _order = Orders();
  List<OrdersDetails> _ordersDetails = [];
  OrdersDetails _ordersDetail = OrdersDetails();
  Products _product = Products();
  int _amountBox = 0;
  int _amountUnits = 0;
  int _totalAmount = 0;
  bool _isLoading = false;
  // Getters
  Customers get customer => _customer;
  Orders get order => _order;
  List<OrdersDetails> get ordersDetails => _ordersDetails;
  OrdersDetails get ordersDetail => _ordersDetail;
  Products get product => _product;
  int get amountBox => _amountBox;
  int get amountUnits => _amountUnits;
  int get totalAmount => _totalAmount;
  bool get isLoading => _isLoading;

  // Setters
  set customer(Customers value) {
    _customer = value;
    notifyListeners();
  }

  set order(Orders value) {
    _order = value;
    notifyListeners();
  }

  set ordersDetails(List<OrdersDetails> value) {
    _ordersDetails = value;
    notifyListeners();
  }

  set ordersDetail(OrdersDetails value) {
    _ordersDetail = value;
    notifyListeners();
  }

  set product(Products value) {
    _product = value;
    notifyListeners();
  }

  set amountBox(int value) {
    _amountBox = value;
    notifyListeners();
  }

  set amountUnits(int value) {
    _amountUnits = value;
    notifyListeners();
  }

  set totalAmount(int value) {
    _totalAmount = value;
    notifyListeners();
  }

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Metodos para manejar las cantidades de la orden
  void addBoxToOrder() {
    _amountBox = _amountBox + 1;
    _totalAmount = _amountBox * _product.present!;
    notifyListeners();
  }

  void removeBoxToOrder() {
    if (_amountBox > 1) {
      _amountBox = _amountBox - 1;
      _totalAmount = _amountBox * _product.present!;
      notifyListeners();
    }
  }

  void resetBoxQuantity() {
    _amountBox = 0;
    _totalAmount = _amountBox * _product.present!;
    notifyListeners();
  }

  void addUnitsToOrder() {
    _amountUnits = _amountUnits + 1;
    _totalAmount = _totalAmount + 1;
    notifyListeners();
  }

  void removeUnitsToOrder() {
    if (_amountUnits > 1) {
      _amountUnits = _amountUnits - 1;
      _totalAmount = _totalAmount - 1;
      notifyListeners();
    }
  }

  void resetUnitsQuantity() {
    _amountUnits = 0;
    if (_amountBox == 0) {
      _totalAmount = _amountUnits;
    } else {
      _totalAmount = _amountBox * _product.present!;
    }
    notifyListeners();
  }

  void resetValues() {
    _amountBox = 0;
    _amountUnits = 0;
    _totalAmount = 0;
    notifyListeners();
  }

  // Metodos para manejar la orden en memoria
  void _createOrderInMemory() {
    _order.code_customer = _customer.cod;
    _order.date_order = DateTime.now().toString();
    _order.process = 0;
    _order.phone_customer = _customer.phone;
    _order.route = _customer.route.toString();
    _order.identificator = _customer.document;
    _order.subtotal = 0;
    _order.iva = 0;
    _order.total = 0;
  }

  void inicializateOrderDetail({required int amount}) {
    OrdersDetails result = OrdersDetails();
    result.id_order = _order.id;
    result.id_product = product.id;
    result.stock = product.stock;
    result.price = product.price;
    result.product_code = product.code;
    result.product = product.shortname;
    result.subtotal = 0;
    result.iva = 0;
    result.total = 0;
    result.tosend = 0;
    result.order_identify = _order.identificator;
    result.amount = amount;
    _ordersDetail = result;
  }

  void removeOrderDetail({required int index}) {
    _order.subtotal = _order.subtotal! - _ordersDetails[index].subtotal!;
    _order.iva = _order.iva! - _ordersDetails[index].iva!;
    _order.total = _order.total! - _ordersDetails[index].total!;
    _ordersDetails.removeAt(index);
    notifyListeners();
  }

  void deleteOrder() {
    _order = Orders();
    _ordersDetails = [];
    notifyListeners();
  }

  // Metodos para manejar la orden
  Future createOrder() async {
    _createOrderInMemory();
    await _createLocalOrder();
  }

  Future createOrderDetail({required int amountBox}) async {
    _ordersDetail.amount = _amountUnits;
    _calculateOrderDetailTotals();
    _addDetailTotalsToOrder();
    _addOrderDetailMemory();
    resetBoxQuantity();
    resetUnitsQuantity();
    await _createLocalOrderDetail();
  }

  void _addOrderDetailMemory() async {
    _ordersDetail.tosend = 1;
    _ordersDetails.add(_ordersDetail);
  }

  Future _clearOrders() async {
    var dbClient = await _databaseHelper.db;
    await dbClient.delete('orders');
  }

  Future _clearOrdersDetails() async {
    var dbClient = await _databaseHelper.db;
    await dbClient.delete('order_details');
  }

  void _calculateOrderDetailTotals() {
    int quantityBox = 0;
    int quantityUnits = 0;
    int quantity = 0;
    if (!(_amountBox == 0)) {
      quantityBox = (_amountBox * _product.present!);
    }
    if (!(_amountUnits == 0)) {
      quantityUnits = quantityUnits + _amountUnits;
    }
    quantity = quantityBox + quantityUnits;
    _ordersDetail.amount = quantity;
    _ordersDetail.subtotal = quantity * _ordersDetail.price!;
    if (_product.taxable == 1) {
      _ordersDetail.iva = _ordersDetail.subtotal! * (IVA_VALUE / 100);
    } else {
      _ordersDetail.iva = 0;
    }
    _ordersDetail.total = _ordersDetail.subtotal! + _ordersDetail.iva!;
  }

  void _addDetailTotalsToOrder() {
    _order.subtotal = _order.subtotal! + _ordersDetail.subtotal!;
    _order.iva = _order.iva! + _ordersDetail.iva!;
    _order.total = _order.total! + _ordersDetail.total!;
  }

  /* 
  Metodos para manejar la logica en la base de datos local
  */
  Future _createLocalOrder() async {
    _clearOrders();
    var dbClient = await _databaseHelper.db;
    await dbClient.insert(
      'orders',
      _order.toJson(),
    );
    List<Map<String, dynamic>> order = await dbClient.rawQuery(
      'SELECT id FROM orders WHERE code_customer = ?',
      [_order.code_customer],
    );
    _order.id = order[0]['id'];
  }

  Future _createLocalOrderDetail() async {
    _clearOrdersDetails();
    var dbClient = await _databaseHelper.db;
    dynamic resp = await dbClient.insert(
      'order_details',
      _ordersDetail.toJson(),
    );
    _ordersDetail.id = resp;
  }

  Future clearLocalOrders() async {
    _clearOrders();
    _clearOrdersDetails();
  }

  /* 
  Metodos para manejar la logicas en la base de datos remota
  */

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

  Future sendOrder() async {
    _isLoading = true;
    notifyListeners();
    LocationData? locationData = await _getLocation();
    _order.lat = locationData!.latitude.toString();
    _order.lng = locationData.longitude.toString();
    Map<String, dynamic> toData = {
      'code_customer': _order.code_customer,
      'date_order': _order.date_order,
      'process': _order.process,
      'phone_customer': _order.phone_customer,
      'route': _order.route,
      'identificator': _order.identificator,
      'subtotal': _order.subtotal,
      'iva': _order.iva,
      'total': _order.total,
      'lat': _order.lat,
      'lng': _order.lng,
    };
    List orderToSend = [];
    orderToSend.add(Orders.fromJson(toData));
    List details = [];
    _ordersDetails.map((item) => details.add(item.toJson())).toList();
    const storage = FlutterSecureStorage();
    final int? id =
        await storage.read(key: 'id').then((value) => int.parse(value!));
    List<Orders> orders = [];
    orders.add(_order);
    List ordersDetails = [];
    for (var element in _ordersDetails) {
      ordersDetails.add(element.toJson());
    }
    final response = await http.post(
      Uri.parse(POST_ORDERS),
      body: json
          .encode({"seller_id": id, "order": orderToSend, "details": details}),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      },
    );

    if (response.statusCode == 200) {
      _ordersDetails = [];
      // Actualizar el estado de la orden en la base de datos local
      var dbClient = await _databaseHelper.db;
      await dbClient.update(
        'orders',
        {'process': 1},
        where: 'id = ?',
        whereArgs: [_order.id],
      );
    } else {
      // Mostrar un mensaje de error con un snackbar
    }
    _isLoading = false;
    notifyListeners();
  }

  // Metodo booleano para verificar si hay ordenes con estado cero
  Future<bool> hasOrdersToSend() async {
    var dbClient = await _databaseHelper.db;
    List<Map<String, dynamic>> orders = await dbClient.query(
      'orders',
      where: 'process = ?',
      whereArgs: [0],
    );
    if (orders.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  // Método para que devuelve un bool si se tiene productos en la orden
  bool hasProductsInOrder() {
    if (_ordersDetails.isEmpty) {
      return false;
    } else {
      return true;
    }
  }
}
