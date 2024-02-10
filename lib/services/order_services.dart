import 'dart:convert';

import 'package:covertosa_2/constants.dart';
import 'package:covertosa_2/local_services/database_helper.dart';
import 'package:covertosa_2/models/orders.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

class OrderServices {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final storage = const FlutterSecureStorage();

  Future saveOrderLocally(Orders order) async {
    try {
      LocationData? locationData = await _getLocation();
      order.lat = locationData!.latitude.toString();
      order.lng = locationData.longitude.toString();
      var dbClient = await _databaseHelper.db;
      await dbClient.insert(
        'orders',
        order.toJson(),
      );
    } catch (e) {
      print(e);
    }
  }

  Future saveOrderDetailsLocally(List<OrdersDetails> orderDetails) async {
    try {
      var dbClient = await _databaseHelper.db;
      for (var orderDetail in orderDetails) {
        await dbClient.insert(
          'order_details',
          orderDetail.toJson(),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  Future sendOrderToServer({
    required Orders order,
    required List<OrdersDetails> orderDetails,
  }) async {
    try {
      LocationData? locationData = await _getLocation();
      order.lat = locationData!.latitude.toString();
      order.lng = locationData.longitude.toString();
      Map<String, dynamic> toData = {
        'code_customer': order.code_customer,
        'date_order': order.date_order,
        'process': order.process,
        'phone_customer': order.phone_customer,
        'route': order.route,
        'identificator': order.identificator,
        'subtotal': order.subtotal,
        'iva': order.iva,
        'total': order.total,
        'lat': order.lat,
        'lng': order.lng,
      };
      List orderToSend = [];
      orderToSend.add(Orders.fromJson(toData));
      List details = [];
      orderDetails.map((item) => details.add(item.toJson())).toList();
      final int? id =
          await storage.read(key: 'id').then((value) => int.parse(value!));
      List<Orders> orders = [];
      orders.add(order);
      List ordersDetails = [];
      for (var element in ordersDetails) {
        ordersDetails.add(element.toJson());
      }
      // ignore: unused_local_variable
      final response = await http.post(
        Uri.parse(POST_ORDERS),
        body: json.encode(
            {"seller_id": id, "order": orderToSend, "details": details}),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json'
        },
      );
    } catch (e) {
      print(e);
    }
  }

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
}
