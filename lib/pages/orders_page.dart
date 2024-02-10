import 'package:flutter/material.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ordenes'),
      ),
      body: Center(
        child: MaterialButton(
          onPressed: () {
            // orderProvider.clearLocalOrders();
          },
          child: const Text('Eliminar las ordenas de forma local'),
        ),
      ),
    );
  }
}
