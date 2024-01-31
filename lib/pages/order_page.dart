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
      appBar: AppBar(
        title: const Text('Orden'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          print(orderProvider.order.toJson());
        },
        // child: const Icon(Icons.send),
        label: const Text('Enviar'),
        icon: const Icon(Icons.send),
      ),
      body: Container(),
    );
  }
}
