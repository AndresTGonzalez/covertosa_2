// TODO: Crear la pagina de la orden

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/providers.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    return Scaffold(
      body: Center(
        child: MaterialButton(
          onPressed: () {
            // print(orderProvider.orders);
            print(orderProvider.order.toJson());
          },
          child: Text('Ordenes'),
        ),
      ),
    );
  }
}
