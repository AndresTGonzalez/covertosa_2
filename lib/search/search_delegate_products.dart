import 'package:covertosa_2/constants.dart';
import 'package:covertosa_2/models/products.dart';
import 'package:covertosa_2/providers/products_provider.dart';
import 'package:flutter/material.dart';

class SearchDelegateProducts extends SearchDelegate {
  final ProductsProvider productsProvider = ProductsProvider();
  List<Products> _filter = [];

  bool isOrder;

  SearchDelegateProducts({required this.isOrder});

  @override
  String? get searchFieldLabel => ' Buscar producto';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    _filter = productsProvider.products
        .where((product) =>
            product.shortname!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: _filter.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: isOrder
              ? () {
                  close(context, _filter[index]);
                  Navigator.pushNamed(context, SELECT_PRODUCT_ROUTE,
                      arguments: _filter[index]);
                }
              : () {
                  close(context, _filter[index]);
                  Navigator.pushNamed(context, SELECT_PRODUCT_ROUTE_NO,
                      arguments: _filter[index]);
                },
          child: _listTileProduct(
            product: _filter[index],
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return const Center(
        child: Center(
          child: Icon(
            Icons.inventory,
            size: 200,
            color: Colors.black12,
          ),
        ),
      );
    }

    _filter = productsProvider.products
        .where((product) =>
            product.shortname!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: _filter.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: isOrder
              ? () {
                  close(context, _filter[index]);
                  Navigator.pushNamed(context, SELECT_PRODUCT_ROUTE,
                      arguments: _filter[index]);
                }
              : () {
                  close(context, _filter[index]);
                  Navigator.pushNamed(context, SELECT_PRODUCT_ROUTE_NO,
                      arguments: _filter[index]);
                },
          child: _listTileProduct(
            product: _filter[index],
          ),
        );
      },
    );
  }

  ListTile _listTileProduct({required Products product}) {
    return ListTile(
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
    );
  }
}
