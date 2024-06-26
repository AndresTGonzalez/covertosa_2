// ignore_for_file: must_be_immutable

import 'package:covertosa_2/constants.dart';
import 'package:covertosa_2/design/app_colors.dart';
import 'package:covertosa_2/models/customers.dart';
import 'package:covertosa_2/providers/providers.dart';
import 'package:covertosa_2/search/search_delegate_customers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomersPage extends StatelessWidget {
  bool isCrud;

  CustomersPage({
    super.key,
    required this.isCrud,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SyncProvider(),
        ),
      ],
      child: _Content(isCrud: isCrud),
    );
  }
}

class _Content extends StatelessWidget {
  bool isCrud;

  _Content({
    required this.isCrud,
  });

  @override
  Widget build(BuildContext context) {
    final customersProvider = Provider.of<CustomersProvider>(context);
    final syncProvider = Provider.of<SyncProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {
          Navigator.pushNamed(
            context,
            CUSTOMER_PAGE_ROUTE,
            arguments: Customers(),
          );
        },
        child: Icon(
          Icons.add,
          color: AppColors.white,
        ),
      ),
      appBar: AppBar(
        title: const Text('Clientes'),
        actions: [
          IconButton(
            onPressed: () async {
              customersProvider.isLoading = true;
              await syncProvider.syncCustomers();
              await customersProvider.getCustomers();
              customersProvider.isLoading = false;
            },
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: SearchDelegateCustomers(
                  isOrder: isCrud,
                ),
              );
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: customersProvider.isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            )
          : ListView.builder(
              itemCount: customersProvider.customers.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: !isCrud
                      ? () async {
                          orderProvider.customer =
                              customersProvider.customers[index];
                          await orderProvider.createOrder();
                          // ignore: use_build_context_synchronously
                          Navigator.pushNamed(context, PRODUCTS_ROUTE_NC);
                        }
                      : () {
                          Navigator.pushNamed(
                            context,
                            CUSTOMER_PAGE_ROUTE,
                            arguments: customersProvider.customers[index],
                          );
                        },
                  child: _listTileCustomer(
                    customer: customersProvider.customers[index],
                  ),
                );
              },
            ),
    );
  }

  ListTile _listTileCustomer({required Customers customer}) {
    return ListTile(
      minVerticalPadding: 10,
      leading: const Icon(Icons.person),
      title: Text('${customer.name!} ${customer.lastname ?? ""}'),
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
