import 'package:covertosa_2/constants.dart';
import 'package:covertosa_2/models/customers.dart';
import 'package:covertosa_2/models/orders.dart';
import 'package:covertosa_2/models/products.dart';
import 'package:covertosa_2/services/services.dart';
import 'package:flutter/material.dart';

class OrderProvider extends ChangeNotifier {
  final NetworkStatusServices _networkStatusServices = NetworkStatusServices();
  final OrderServices _orderServices = OrderServices();

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

  set product(Products value) {
    _product = value;
    notifyListeners();
  }

  // Metodos para manejar las cantidades de la orden
  void addBoxToOrder() {
    _amountBox = _amountBox + 1;
    _totalAmount = (_amountBox * _product.present!) + _amountUnits;
    notifyListeners();
  }

  void removeBoxToOrder() {
    if (_amountBox > 0) {
      _amountBox = _amountBox - 1;
      _totalAmount = _amountBox * _product.present!;
      notifyListeners();
    }
  }

  void resetBoxQuantity() {
    _amountBox = 0;
    _totalAmount = (_amountBox * _product.present!) + _amountUnits;
    notifyListeners();
  }

  void addUnitsToOrder() {
    _amountUnits = _amountUnits + 1;
    _totalAmount = _totalAmount + 1;
    notifyListeners();
  }

  void removeUnitsToOrder() {
    if (_amountUnits > 0) {
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
    // await _createLocalOrder();
  }

  Future createOrderDetail({required int amountBox}) async {
    _ordersDetail.amount = _amountUnits;
    _calculateOrderDetailTotals();
    _addDetailTotalsToOrder();
    _addOrderDetailMemory();
    resetBoxQuantity();
    resetUnitsQuantity();
    // await _createLocalOrderDetail();
  }

  void _addOrderDetailMemory() async {
    _ordersDetail.tosend = 1;
    _ordersDetails.add(_ordersDetail);
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

  bool hasProductsInOrder() {
    if (_ordersDetails.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  void addAmountToDetail({required int index}) {
    num subtotal = _ordersDetails[index].subtotal!;
    num iva = _ordersDetails[index].iva!;
    num total = _ordersDetails[index].total!;
    bool taxeable = true;

    if (_ordersDetails[index].iva! > 0) {
      taxeable = true;
    } else {
      taxeable = false;
    }
    _ordersDetails[index].amount = _ordersDetails[index].amount! + 1;
    _order.subtotal = _order.subtotal! - subtotal;
    _order.iva = _order.iva! - iva;
    _order.total = _order.total! - total;
    _ordersDetails[index].subtotal =
        _ordersDetails[index].amount! * _ordersDetails[index].price!;
    if (taxeable) {
      _ordersDetails[index].iva =
          _ordersDetails[index].subtotal! * (IVA_VALUE / 100);
    } else {
      _ordersDetails[index].iva = 0;
    }
    _ordersDetails[index].total =
        _ordersDetails[index].subtotal! + _ordersDetails[index].iva!;
    _order.subtotal = _order.subtotal! + _ordersDetails[index].subtotal!;
    _order.iva = _order.iva! + _ordersDetails[index].iva!;
    _order.total = _order.total! + _ordersDetails[index].total!;
    _order.total = _order.subtotal! + _order.iva!;

    notifyListeners();
  }

  void removeAmountToDetail({required int index}) {
    num subtotal = _ordersDetails[index].subtotal!;
    num iva = _ordersDetails[index].iva!;
    num total = _ordersDetails[index].total!;
    bool taxeable = true;

    if (_ordersDetails[index].amount! > 1) {
      if (_ordersDetails[index].iva! > 0) {
        taxeable = true;
      } else {
        taxeable = false;
      }
      _ordersDetails[index].amount = _ordersDetails[index].amount! - 1;
      _order.subtotal = _order.subtotal! - subtotal;
      _order.iva = _order.iva! - iva;
      _order.total = _order.total! - total;
      _ordersDetails[index].subtotal =
          _ordersDetails[index].amount! * _ordersDetails[index].price!;
      if (taxeable) {
        _ordersDetails[index].iva =
            _ordersDetails[index].subtotal! * (IVA_VALUE / 100);
      } else {
        _ordersDetails[index].iva = 0;
      }
      _ordersDetails[index].total =
          _ordersDetails[index].subtotal! + _ordersDetails[index].iva!;
      _order.subtotal = _order.subtotal! + _ordersDetails[index].subtotal!;
      _order.iva = _order.iva! + _ordersDetails[index].iva!;
      _order.total = _order.total! + _ordersDetails[index].total!;
      _order.total = _order.subtotal! + _order.iva!;

      notifyListeners();
    }
  }

  Future sendOrder() async {
    _isLoading = true;
    notifyListeners();
    bool hasInternet = await _networkStatusServices.getNetworkStatus();
    if (hasInternet) {
      await _orderServices.sendOrderToServer(
        order: _order,
        orderDetails: _ordersDetails,
      );
    } else {
      await _orderServices.saveOrderLocally(_order);
      await _orderServices.saveOrderDetailsLocally(_ordersDetails);
      _order = Orders();
      _ordersDetails = [];
    }
    _isLoading = false;
    notifyListeners();
  }
}
