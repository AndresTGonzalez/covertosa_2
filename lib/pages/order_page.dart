import 'package:covertosa_2/constants.dart';
import 'package:covertosa_2/design/app_colors.dart';
import 'package:covertosa_2/utils/snackbar_message.dart';
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
        actions: [
          IconButton(
            onPressed: () {
              orderProvider.deleteOrder();
              orderProvider.resetBoxQuantity();
              orderProvider.resetUnitsQuantity();
              Navigator.pushReplacementNamed(context, CUSTOMERS_ROUTE_NC);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.delete,
            ),
          ),
        ],
      ),
      floatingActionButton: orderProvider.isLoading
          ? FloatingActionButton(
              backgroundColor: AppColors.primary,
              onPressed: () {},
              child: CircularProgressIndicator(
                color: AppColors.white,
              ),
            )
          : FloatingActionButton.extended(
              backgroundColor: AppColors.primary,
              onPressed: () async {
                await orderProvider.sendOrder();
                orderProvider.resetBoxQuantity();
                orderProvider.resetUnitsQuantity();
                // ignore: use_build_context_synchronously
                Navigator.pushReplacementNamed(context, CUSTOMERS_ROUTE_NC);
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
                // ignore: use_build_context_synchronously
                SnackbarMessage.show(
                  context: context,
                  message: 'Orden enviada',
                  isError: false,
                );
              },
              // child: const Icon(Icons.send),
              label: Text(
                'Enviar',
                style: TextStyle(
                  color: AppColors.white,
                ),
              ),
              icon: Icon(
                Icons.send,
                color: AppColors.white,
              ),
            ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.15,
              width: double.infinity,
              // color: Colors.red,
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      children: [
                        const Text(
                          'Cliente: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${orderProvider.customer.name}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      children: [
                        const Text(
                          'Identificación: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${orderProvider.customer.document}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      children: [
                        const Text(
                          'Dirección: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 250,
                          child: Text(
                            '${orderProvider.customer.address}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              width: double.infinity,
              // color: Colors.blue,
              child: ListView.builder(
                itemCount: orderProvider.ordersDetails.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                                'Cantidad: ${orderProvider.ordersDetails[index].amount}'),
                            IconButton(
                              onPressed: () {
                                orderProvider.addAmountToDetail(index: index);
                              },
                              icon: Icon(
                                Icons.add_circle,
                                color: AppColors.success,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                orderProvider.removeAmountToDetail(
                                    index: index);
                              },
                              icon: Icon(
                                Icons.remove_circle,
                                color: AppColors.danger,
                              ),
                            ),
                          ],
                        ),
                        Text(
                            'Subtotal: \$${orderProvider.ordersDetails[index].subtotal!.toStringAsFixed(2)}')
                      ],
                    ),
                    title:
                        Text('${orderProvider.ordersDetails[index].product}'),
                    trailing: IconButton(
                      onPressed: () {
                        orderProvider.removeOrderDetail(index: index);
                      },
                      icon: Icon(
                        Icons.delete,
                        color: AppColors.danger,
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.15,
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Subtotal: \$${(orderProvider.order.subtotal ?? 0).toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'IVA: \$${(orderProvider.order.iva ?? 0).toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Total: \$${(orderProvider.order.total ?? 0).toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
