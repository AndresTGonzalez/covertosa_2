import 'package:covertosa_2/local_services/database_helper.dart';
import 'package:covertosa_2/models/customers.dart';
import 'package:covertosa_2/models/orders.dart';
import 'package:covertosa_2/models/products.dart';
import 'package:flutter/material.dart';

class OrderProvider extends ChangeNotifier {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Customers _customer = Customers();
  Orders _order = Orders();
  List<OrdersDetails> _ordersDetails = [];
  OrdersDetails _ordersDetail = OrdersDetails();

  late Products _product;

  OrderProvider({
    required Products product,
  }) {
    _product = product;
    _ordersDetail.amount = 1;
  }

  Customers get customer => _customer;
  Orders get order => _order;
  List<OrdersDetails> get ordersDetails => _ordersDetails;
  OrdersDetails get ordersDetail => _ordersDetail;

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

  // TODO: Agregar logica para crear la orden en memoria
  void createOrder() {
    _order.code_customer = _customer.cod;
    _order.date_order = DateTime.now().toString();
  }

  // TODO: Agregar logica para agregar un producto a la orden
  void addOrderDetail() async {
    var dbClient = await _databaseHelper.db;
  }

  // TODO: Agregar logica para remover un producto de la orden
  void removeOrderDetail() async {
    var dbClient = await _databaseHelper.db;
  }

  // TODO: Agregar logica para calcular el subtotal del detalle de la orden
  void calculateDetailSubtotal() async {
    var dbClient = await _databaseHelper.db;
  }

  // TODO: Agregar logica para calcular los totales de la orden
  // Total, IVA, Subtotal
  void calculateOrderTotals() async {
    var dbClient = await _databaseHelper.db;
  }

  /* 
  Metodos para manejar la logica en la base de datos local
  */
  // TODO: Agregar logica para guardar la orden en la base de datos local
  void createLocalOrder() {}

  // TODO: Agregar logica para guardar el detalle de la orden en la base de datos local
  void createLocalOrderDetail() {}

  // TODO: Agregar logica para obtener la orden de la base de datos local
  void getLocalOrder() {}

  // TODO: Agregar logica para obtener los detalles de la orden de la base de datos local
  void getLocalOrderDetails() {}

  // TODO: Agregar logica para eliminar la orden de la base de datos local
  void deleteLocalOrder() {}

  // TODO: Agregar logica para eliminar un detalle de la orden de la base de datos local
  void deleteLocalOrderDetail() {}

  // TODO: Agregar logica para eliminar todos los detalles de la orden de la base de datos local
  void deleteLocalOrderDetails() {}

  /* 
  Metodos para manejar la logicas en la base de datos remota
  */
  // TODO: Agregar logica para guardar la orden en la base de datos remota con todos sus detalles
  void sendOrder() {}
}
