// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

List<Orders> ordersFromJson(String str) =>
    List<Orders>.from(json.decode(str).map((x) => Orders.fromJson(x)));
String ordersToJson(List<Orders> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Orders {
  int? id;
  String? code_customer;
  String? date_order;
  int? process;
  String? phone_customer;
  String? route;
  String? identificator;
  num? subtotal;
  num? iva;
  num? total;
  String? lat;
  String? lng;

  Orders({
    this.id,
    this.code_customer,
    this.date_order,
    this.process,
    this.phone_customer,
    this.route,
    this.identificator,
    this.subtotal,
    this.iva,
    this.total,
    this.lat,
    this.lng,
  });

  int? totalPages;
  late List<Orders> data;

  factory Orders.fromJson(Map<String, dynamic> json) => Orders(
        // id: json['id'],
        id: (json['id'] is String) ? int.parse(json['id']) : json['id'],
        code_customer: json['code_customer'],
        date_order: json['date_order'],
        // process: json['process'],
        process: (json['process'] is String)
            ? int.parse(json['process'])
            : json['process'],
        phone_customer: json['phone_customer'],
        route: json['route'],
        identificator: json['identificator'],
        subtotal: num.parse(json['subtotal'].toString()),
        iva: num.parse(json['iva'].toString()),
        total: num.parse(json['total'].toString()),
        lat: json['lat'],
        lng: json['lng'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'code_customer': code_customer,
        'date_order': date_order,
        'process': process,
        'phone_customer': phone_customer,
        'route': route,
        'identificator': identificator,
        'subtotal': subtotal,
        'iva': iva,
        'total': total,
        'lat': lat,
        'lng': lng,
      };
}

//Detalle de la Orden
List<OrdersDetails> ordersDetFromJson(String str) => List<OrdersDetails>.from(
    json.decode(str).map((x) => OrdersDetails.fromJson(x)));
String ordersDetToJson(List<OrdersDetails> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OrdersDetails {
  int? id;
  int? id_order;
  int? id_product;
  int? stock;
  num? price;
  String? product_code;
  String? product;
  int? amount;
  num? subtotal;
  num? iva;
  num? total;
  int? tosend;
  String? order_identify;

  OrdersDetails({
    this.id,
    this.id_order,
    this.id_product,
    this.stock,
    this.price,
    this.product_code,
    this.product,
    this.amount,
    this.subtotal,
    this.iva,
    this.total,
    this.tosend,
    this.order_identify,
  });

  factory OrdersDetails.fromJson(Map<String, dynamic> json) => OrdersDetails(
        id: json['id'],
        id_order: json['id_order'],
        id_product: json['id_product'],
        stock: json['stock'],
        price: num.parse(json['price'].toString()),
        product_code: json['product_code'],
        product: json['product'],
        amount: json['amount'],
        subtotal: num.parse(json['subtotal'].toString()),
        iva: num.parse(json['iva'].toString()),
        total: num.parse(json['total'].toString()),
        tosend: json['tosend'],
        order_identify: json['order_identify'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'id_order': id_order,
        'id_product': id_product,
        'stock': stock,
        'price': price,
        'product_code': product_code,
        'product': product,
        'amount': amount,
        'subtotal': subtotal,
        'iva': iva,
        'total': total,
        'tosend': tosend,
        'order_identify': order_identify,
      };
}
