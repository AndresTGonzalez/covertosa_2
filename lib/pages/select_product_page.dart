// ignore_for_file: deprecated_member_use

import 'package:barcode_widget/barcode_widget.dart';
import 'package:covertosa_2/constants.dart';
import 'package:covertosa_2/design/app_colors.dart';
import 'package:covertosa_2/models/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/providers.dart';

// ignore: must_be_immutable
class SelectProductPage extends StatelessWidget {
  bool isOrder;

  SelectProductPage({super.key, required this.isOrder});

  @override
  Widget build(BuildContext context) {
    // Recibir el producto
    final Products product =
        ModalRoute.of(context)!.settings.arguments as Products;

    return _Content(
      product: product,
      isOrder: isOrder,
    );
  }
}

// ignore: must_be_immutable
class _Content extends StatelessWidget {
  final Products product;
  bool isOrder;

  _Content({
    required this.product,
    required this.isOrder,
  });

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);

    return WillPopScope(
      onWillPop: () async {
        orderProvider.resetValues();
        return true;
      },
      child: Scaffold(
        floatingActionButton: isOrder
            ? FloatingActionButton(
                backgroundColor: AppColors.primary,
                onPressed: () async {
                  orderProvider.product = product;
                  await orderProvider.createOrderDetail(
                    amountBox: orderProvider.amountBox,
                  );
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.add,
                  color: AppColors.white,
                ),
              )
            : null,
        appBar: AppBar(
          title: Text(product.shortname!),
        ),
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.3,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 40,
                  ),
                  child: BarcodeWidget(
                    barcode: Barcode.code39(),
                    data: product.code!,
                    width: 400,
                    height: 160,
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.6,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 30,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    'Producto: ',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    child: Text(
                                      product.shortname!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Text(
                                    'Código: ',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    child: Text(
                                      product.code!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Text(
                                    'Precio unitario: ',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    child: Text(
                                      '\$ ${product.price!.toStringAsFixed(2)}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Text(
                                    'Unidades por caja: ',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    child: Text(
                                      '${product.present!}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Text(
                                    'Stock: ',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.75,
                                    child: Text(
                                      'Cajas: ${(product.stock! / product.present!).toStringAsFixed(2)} | Unidades: ${product.stock! % product.present!}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        if (isOrder)
                          _OrderFunctions(
                            product: product,
                          ),
                        const Divider(),
                        Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.15,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    'Cantidad: ',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(orderProvider.totalAmount
                                      .toStringAsFixed(0)),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                    'Subtotal: ',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                      '\$${(orderProvider.totalAmount * product.price!).toStringAsFixed(2)}'),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                    'IVA: ',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                      '\$${((orderProvider.totalAmount * product.price!) * (IVA_VALUE / 100)).toStringAsFixed(2)}'),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                    'Total: ',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                      '\$${(((orderProvider.totalAmount * product.price!) * (IVA_VALUE / 100) + (orderProvider.totalAmount * product.price!))).toStringAsFixed(2)}'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class _OrderFunctions extends StatelessWidget {
  late Products product;

  _OrderFunctions({
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return _OrderInfo(
      product: product,
    );
  }
}

class _OrderInfo extends StatelessWidget {
  final Products product;

  const _OrderInfo({
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          orderProvider.product.present! > 1
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Unidades: ${orderProvider.amountUnits}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            orderProvider.removeUnitsToOrder();
                          },
                          icon: Icon(
                            Icons.remove_circle,
                            color: AppColors.danger,
                            size: 30,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            orderProvider.addUnitsToOrder();
                          },
                          icon: Icon(
                            Icons.add_circle,
                            color: AppColors.success,
                            size: 30,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            orderProvider.resetUnitsQuantity();
                          },
                          icon: Icon(
                            Icons.restart_alt_sharp,
                            color: AppColors.danger,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : const SizedBox(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                // 'Cajas: {$orderProvider.ordersDetail.amount}',
                'Cajas: ${orderProvider.amountBox}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      orderProvider.removeBoxToOrder();
                    },
                    icon: Icon(
                      Icons.remove_circle,
                      color: AppColors.danger,
                      size: 30,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      orderProvider.addBoxToOrder();
                    },
                    icon: Icon(
                      Icons.add_circle,
                      color: AppColors.success,
                      size: 30,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      orderProvider.resetBoxQuantity();
                    },
                    icon: Icon(
                      Icons.restart_alt_sharp,
                      color: AppColors.danger,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // orderProvider.product.present! > 1
          //     ? Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           Text(
          //             'Presentación: ${orderProvider.product.present}',
          //             style: const TextStyle(
          //               fontSize: 18,
          //               fontWeight: FontWeight.bold,
          //             ),
          //           ),
          //           Row(
          //             children: [
          //               IconButton(
          //                 onPressed: () {},
          //                 icon: Icon(
          //                   Icons.remove_circle,
          //                   color: AppColors.danger,
          //                   size: 30,
          //                 ),
          //               ),
          //               IconButton(
          //                 onPressed: () {},
          //                 icon: Icon(
          //                   Icons.add_circle,
          //                   color: AppColors.success,
          //                   size: 30,
          //                 ),
          //               ),
          //               IconButton(
          //                 onPressed: () {
          //                   print(orderProvider.product.present!);
          //                 },
          //                 icon: Icon(
          //                   Icons.restart_alt_sharp,
          //                   color: AppColors.danger,
          //                   size: 30,
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ],
          //       )
          //     : const SizedBox(),
          // Aqui esta la funcion para las unidades aun no se como aplicarla
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     const Text(
          //       'Unidades: 1',
          //       style: TextStyle(
          //         fontSize: 18,
          //         fontWeight: FontWeight.bold,
          //       ),
          //     ),
          //     Row(
          //       children: [
          //         IconButton(
          //           onPressed: () {},
          //           icon: Icon(
          //             Icons.remove_circle,
          //             color: AppColors.danger,
          //             size: 30,
          //           ),
          //         ),
          //         IconButton(
          //           onPressed: () {},
          //           icon: Icon(
          //             Icons.add_circle,
          //             color: AppColors.success,
          //             size: 30,
          //           ),
          //         ),
          //         IconButton(
          //           onPressed: () {},
          //           icon: Icon(
          //             Icons.restart_alt_sharp,
          //             color: AppColors.danger,
          //             size: 30,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
