import 'package:covertosa_2/constants.dart';
import 'package:covertosa_2/local_services/database_helper.dart';
import 'package:covertosa_2/models/customers.dart';
import 'package:covertosa_2/models/orders.dart';
import 'package:covertosa_2/models/products.dart';
// import 'package:covertosa_2/models/trade_routes.dart';
import 'package:flutter/material.dart';

class OrderProvider extends ChangeNotifier {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Customers _customer = Customers();
  Orders _order = Orders();
  List<OrdersDetails> _ordersDetails = [];
  OrdersDetails _ordersDetail = OrdersDetails();
  // List<TradeRoutes> _tradeRoutes = [];
  Products _product = Products();

  // Constructor
  OrderProvider() {
    _ordersDetail.amount = 1;
  }

  // Getters
  Customers get customer => _customer;
  Orders get order => _order;
  List<OrdersDetails> get ordersDetails => _ordersDetails;
  OrdersDetails get ordersDetail => _ordersDetail;
  Products get product => _product;

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

  // Metodos para manejar las cantidades de la orden
  void addBoxToOrder() {
    _ordersDetail.amount = _ordersDetail.amount! + 1;
    notifyListeners();
  }

  void removeBoxToOrder() {
    if (_ordersDetail.amount! > 1) {
      _ordersDetail.amount = _ordersDetail.amount! - 1;
      notifyListeners();
    }
  }

  void resetBoxQuantity() {
    _ordersDetail.amount = 1;
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

  void _createOrderDetailInMemory() {
    _ordersDetail.id_order = _order.id;
    _ordersDetail.id_product = _order.id;
    _ordersDetail.stock = _product.id;
    _ordersDetail.stock = _product.stock;
    _ordersDetail.price = _product.price;
    _ordersDetail.product_code = _product.code;
    _ordersDetail.product = _product.shortname;
    // _ordersDetail.amount = 1;
    _ordersDetail.subtotal = 0;
    _ordersDetail.iva = 0;
    _ordersDetail.total = 0;
    _ordersDetail.tosend = 0;
    _ordersDetail.order_identify = _order.identificator;
  }

  // Metodos para manejar la orden
  Future createOrder() async {
    _createOrderInMemory();
    await _createLocalOrder();
  }

  Future createOrderDetail() async {
    _createOrderDetailInMemory();
    // Verificar si el amount es null
    _ordersDetail.amount ??= 1;
    _calculateOrderDetailTotals();
    // _addDetailTotalsToOrder();
    // await _createLocalOrderDetail();
    _addOrderDetailMemory();
    resetBoxQuantity();
    _createOrderDetailInMemory();
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
    print('Calculando totales');
    _ordersDetail.subtotal = _ordersDetail.amount! * _ordersDetail.price!;
    _ordersDetail.iva = _ordersDetail.subtotal! * IVA_VALUE / 100;
    _ordersDetail.total = _ordersDetail.subtotal! + _ordersDetail.iva!;
    print(_ordersDetail.amount);
    print(_ordersDetail.toJson());
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

  /* 
  Metodos para manejar la logicas en la base de datos remota
  */
  // TODO: Agregar logica para guardar la orden en la base de datos remota con todos sus detalles
  void sendOrder() {
    print('Enviando orden');
    print(_order.toJson());
    print('Enviando detalles de la orden');
    print(_ordersDetail.toJson());
  }
}
