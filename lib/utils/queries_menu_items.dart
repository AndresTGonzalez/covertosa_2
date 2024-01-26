import 'package:covertosa_2/constants.dart';
import 'package:covertosa_2/models/menu_item.dart';
import 'package:flutter/material.dart';

class QueriesMenuItems {
  static List<MenuItem> items = [
    MenuItem('Clientes', CUSTOMERS_ROUTE, Icons.people),
    MenuItem('Productos', PRODUCTS_ROUTE, Icons.inventory),
  ];
}
