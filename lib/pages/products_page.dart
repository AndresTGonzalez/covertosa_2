// ignore_for_file: deprecated_member_use

import 'package:covertosa_2/constants.dart';
import 'package:covertosa_2/design/app_colors.dart';
import 'package:covertosa_2/models/products.dart';
import 'package:covertosa_2/providers/order_provider.dart';
import 'package:covertosa_2/providers/products_provider.dart';
import 'package:covertosa_2/providers/sync_provider.dart';
import 'package:covertosa_2/search/search_delegate_products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ProductsPage extends StatelessWidget {
  bool isCrud;

  ProductsPage({
    super.key,
    required this.isCrud,
  });

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProductsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => SyncProvider(),
        ),
      ],
      child: WillPopScope(
        onWillPop: () async {
          if (isCrud) {
            return true;
          } else {
            if (!(orderProvider.hasProductsInOrder())) {
              return true;
            } else {
              // ignore: use_build_context_synchronously
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Órdenes pendientes'),
                  content: const Text(
                      'Tienes órdenes pendientes. No puedes retroceder.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Aceptar'),
                    ),
                  ],
                ),
              );
              // Impedir el regreso
              return false;
            }
          }
        },
        child: _Content(
          isCrud: isCrud,
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class _Content extends StatelessWidget {
  bool isCrud;

  _Content({
    required this.isCrud,
  });

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductsProvider>(context);
    final syncProvider = Provider.of<SyncProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
        actions: [
          IconButton(
            onPressed: () async {
              productProvider.isLoading = true;
              await syncProvider.syncProducts();
              await productProvider.getProducts();
              productProvider.isLoading = false;
            },
            icon: const Icon(Icons.refresh),
          ),
          isCrud
              ? Container()
              : IconButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      ORDER_PAGE_ROUTE,
                    );
                  },
                  icon: Badge(
                    label: Text(
                      orderProvider.ordersDetails.length.toString(),
                    ),
                    backgroundColor: AppColors.primary,
                    child: const Icon(Icons.shopping_cart),
                  ),
                ),
          IconButton(
            onPressed: isCrud
                ? () {
                    showSearch(
                      context: context,
                      delegate: SearchDelegateProducts(
                        isOrder: false,
                      ),
                    );
                  }
                : () {
                    showSearch(
                      context: context,
                      delegate: SearchDelegateProducts(
                        isOrder: true,
                      ),
                    );
                  },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: productProvider.isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            )
          : Column(
              children: [
                // _CustomerInfo(orderProvider: orderProvider),
                isCrud
                    ? Container()
                    : _CustomerInfo(orderProvider: orderProvider),
                SizedBox(
                  height: isCrud
                      ? MediaQuery.of(context).size.height * 0.888
                      : MediaQuery.of(context).size.height * 0.765,
                  width: double.infinity,
                  child: ListView.builder(
                    itemCount: productProvider.products.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return _ListTileProducto(
                        isCrud: isCrud,
                        productProvider: productProvider,
                        product: productProvider.products[index],
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

class _CustomerInfo extends StatelessWidget {
  const _CustomerInfo({
    super.key,
    required this.orderProvider,
  });

  final OrderProvider orderProvider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              const Text(
                'Cliente: ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Text(
                  '${orderProvider.customer.name}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              const Text(
                'Identificación: ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Text(
                  '${orderProvider.customer.document}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              const Text(
                'Dirección: ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Text(
                  '${orderProvider.customer.address}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              IconButton(
                onPressed: () async {
                  await orderProvider.launchGoogleMaps();
                },
                icon: const Icon(
                  Icons.location_on,
                ),
              ),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }
}

class _ListTileProducto extends StatelessWidget {
  const _ListTileProducto({
    required this.isCrud,
    required this.productProvider,
    required this.product,
  });

  final bool isCrud;
  final ProductsProvider productProvider;
  final Products product;

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    return GestureDetector(
      onTap: isCrud
          ? () {
              Navigator.pushNamed(
                context,
                SELECT_PRODUCT_ROUTE_NO,
                arguments: product,
              );
            }
          : () {
              orderProvider.product = product;
              orderProvider.inicializateOrderDetail(amount: 1);
              Navigator.pushNamed(
                context,
                SELECT_PRODUCT_ROUTE,
                arguments: product,
              );
            },
      child: ListTile(
        minVerticalPadding: 10,
        leading: const Icon(Icons.inventory),
        title: Text(product.shortname!),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Codigo: ${product.code}'),
            // Text('Stock: ${product.stock}'),
            // Salga con cajas y unidades
            Text(
                'Stock: ${(product.stock! / product.present!).toStringAsFixed(2)} cajas | ${product.stock! % product.present!} unidades'),
          ],
        ),
      ),
    );
  }
}
