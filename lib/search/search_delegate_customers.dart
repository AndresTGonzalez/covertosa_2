import 'package:covertosa_2/models/customers.dart';
import 'package:covertosa_2/providers/customers_provider.dart';
import 'package:flutter/material.dart';

class SearchDelegateCustomers extends SearchDelegate {
  final CustomersProvider customersProvider = CustomersProvider();
  List<Customers> _filter = [];

  @override
  String? get searchFieldLabel => ' Buscar cliente';

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
    _filter = customersProvider.customers
        .where((customer) =>
            customer.name!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: _filter.length,
      itemBuilder: (context, index) {
        return _listTileCustomer(customer: _filter[index]);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return const Center(
        child: Center(
          child: Icon(
            Icons.people,
            size: 200,
            color: Colors.black12,
          ),
        ),
      );
    }

    _filter = customersProvider.customers
        .where((customer) =>
            customer.name!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: _filter.length,
      itemBuilder: (context, index) {
        return _listTileCustomer(customer: _filter[index]);
      },
    );
  }

  ListTile _listTileCustomer({required Customers customer}) {
    return ListTile(
      minVerticalPadding: 10,
      leading: const Icon(Icons.person),
      title: Text(customer.name!),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(customer.cod!),
          Text(customer.address!),
        ],
      ),
    );
  }
}
