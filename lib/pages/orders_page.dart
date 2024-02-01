import 'package:covertosa_2/providers/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ordenes'),
      ),
      body: Center(
        child: MaterialButton(
          onPressed: () {
            orderProvider.clearLocalOrders();
          },
          child: const Text('Eliminar las ordenas de forma local'),
        ),
      ),
    );
  }
}
