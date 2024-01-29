// ignore_for_file: equal_keys_in_map

import 'package:covertosa_2/constants.dart';
import 'package:flutter/material.dart';

import 'pages/pages.dart';

final Map<String, WidgetBuilder> routes = {
  LOGIN_ROUTE: (context) => const LoginPage(),
  HOME_ROUTE: (context) => const HomeRoute(),
  CUSTOMERS_ROUTE: (context) => CustomersPage(isCrud: true),
  CUSTOMERS_ROUTE_NC: (context) => CustomersPage(isCrud: false),
  PRODUCTS_ROUTE: (context) => ProductsPage(isCrud: true),
  PRODUCTS_ROUTE_NC: (context) => ProductsPage(isCrud: false),
  SELECT_PRODUCT_ROUTE: (context) => SelectProductPage(isOrder: true),
  SELECT_PRODUCT_ROUTE_NO: (context) => SelectProductPage(isOrder: false),
  CUSTOMER_PAGE_ROUTE: (context) => const CustomerPage(),
  ORDER_PAGE_ROUTE: (context) => const OrderPage(),
};
