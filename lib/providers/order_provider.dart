import 'package:covertosa_2/local_services/database_helper.dart';
import 'package:covertosa_2/models/customers.dart';
import 'package:covertosa_2/models/orders.dart';
import 'package:covertosa_2/models/products.dart';
import 'package:covertosa_2/models/trade_routes.dart';
import 'package:flutter/material.dart';

class OrderProvider extends ChangeNotifier {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Customers _customer = Customers();
  Orders _order = Orders();
  List<OrdersDetails> _ordersDetails = [];
  OrdersDetails _ordersDetail = OrdersDetails();
  List<TradeRoutes> _tradeRoutes = [];
  Products _product = Products();

  OrderProvider() {
    _ordersDetail.amount = 1;
  }

  Customers get customer => _customer;
  Orders get order => _order;
  List<OrdersDetails> get ordersDetails => _ordersDetails;
  OrdersDetails get ordersDetail => _ordersDetail;
  Products get product => _product;

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
    _ordersDetail.id_order = 0;
    _ordersDetail.id_product = _order.id;
    _ordersDetail.stock = _product.id;
    _ordersDetail.stock = _product.stock;
    _ordersDetail.price = _product.price;
    _ordersDetail.product_code = _product.code;
    _ordersDetail.product = _product.shortname;
    _ordersDetail.amount = 0;
    _ordersDetail.subtotal = 0;
    _ordersDetail.iva = 0;
    _ordersDetail.total = 0;
    _ordersDetail.tosend = 0;
    _ordersDetail.order_identify = _order.identificator;
  }

  Future createOrder() async {
    _createOrderInMemory();
    await _createLocalOrder();
  }

  Future createOrderDetail() async {
    _createOrderDetailInMemory();
    await _createLocalOrderDetail();
  }

  Future _clearOrders() async {
    var dbClient = await _databaseHelper.db;
    // Elimino todo lo que tenga la tabla orders
    await dbClient.delete('orders');
  }

  Future _clearOrdersDetails() async {
    var dbClient = await _databaseHelper.db;
    // Elimino todo lo que tenga la tabla orders_details
    await dbClient.delete('order_details');
  }

  // TODO: Agregar logica para agregar un producto a la orden
  void addOrderDetail() async {}

  // TODO: Agregar logica para remover un producto de la orden
  void removeOrderDetail() async {}

  // TODO: Agregar logica para calcular el subtotal del detalle de la orden
  void calculateDetailSubtotal() async {}

  // TODO: Agregar logica para calcular los totales de la orden
  // Total, IVA, Subtotal
  void calculateOrderTotals() async {}

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

  // TODO: Agregar logica para obtener la orden de la base de datos local
  void getLocalOrder() async {
    var dbClient = await _databaseHelper.db;
  }

  // TODO: Agregar logica para obtener los detalles de la orden de la base de datos local
  void getLocalOrderDetails() async {
    var dbClient = await _databaseHelper.db;
  }

  // TODO: Agregar logica para eliminar la orden de la base de datos local
  void deleteLocalOrder() async {
    var dbClient = await _databaseHelper.db;
  }

  // TODO: Agregar logica para eliminar un detalle de la orden de la base de datos local
  void deleteLocalOrderDetail() async {
    var dbClient = await _databaseHelper.db;
  }

  // TODO: Agregar logica para eliminar todos los detalles de la orden de la base de datos local
  void deleteLocalOrderDetails() async {
    var dbClient = await _databaseHelper.db;
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
