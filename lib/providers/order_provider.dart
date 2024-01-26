import 'package:covertosa_2/constants.dart';
import 'package:covertosa_2/models/customers.dart';
import 'package:covertosa_2/models/orders.dart';
import 'package:covertosa_2/models/products.dart';
import 'package:flutter/material.dart';

class OrderProvider extends ChangeNotifier {
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
    _recalculateValues();
    notifyListeners();
  }

  void removeBoxToOrder() {
    if (_ordersDetail.amount! > 1) {
      _ordersDetail.amount = _ordersDetail.amount! - 1;
      _recalculateValues();
      notifyListeners();
    }
  }

  void _recalculateValues() {
    _ordersDetail.subtotal = _product.price! * _ordersDetail.amount!;
    _ordersDetail.iva = _ordersDetail.subtotal! * IVA_VALUE;
    _ordersDetail.total = _ordersDetail.amount! * _product.price!;
  }

  void resetBoxQuantity() {
    _ordersDetail.amount = 1;
    notifyListeners();
  }

  void createOrderDetail() {
    _ordersDetail.product = _product.shortname;

    _ordersDetail.price = _product.price;
    _ordersDetail.total = _product.price;
    _ordersDetail.id_product = _product.id;
    _ordersDetail.id_order = _order.id;
    _ordersDetail.product_code = _product.code;
    _ordersDetail.stock = _product.stock;
    _ordersDetail.iva = _product.price! * IVA_VALUE;
    _ordersDetail.subtotal = _product.price! * IVA_VALUE;
    _ordersDetail.amount = 1;
  }
}
