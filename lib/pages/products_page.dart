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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProductsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => SyncProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => OrderProvider(),
        ),
      ],
      child: _Content(
        isCrud: isCrud,
      ),
    );
  }
}

// ignore: must_be_immutable
class _Content extends StatelessWidget {
  bool isCrud;

  _Content({
    super.key,
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
                    backgroundColor: AppColors.successDark,
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
                color: AppColors.principal,
              ),
            )
          : ListView.builder(
              itemCount: productProvider.products.length,
              itemBuilder: (context, index) {
                return ChangeNotifierProvider(
                  child: ChangeNotifierProvider(
                    child: _ListTileProducto(
                      isCrud: isCrud,
                      productProvider: productProvider,
                      product: productProvider.products[index],
                    ),
                    create: (_) => OrderProvider(),
                  ),
                  create: (_) => OrderProvider(),
                );
              },
            ),
    );
  }
}

class _ListTileProducto extends StatelessWidget {
  const _ListTileProducto({
    super.key,
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
              orderProvider.createOrderDetail();
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
            Text('Stock: ${product.stock}'),
          ],
        ),
      ),
    );
  }
}
