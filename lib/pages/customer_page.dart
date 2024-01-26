import 'package:covertosa_2/constants.dart';
import 'package:covertosa_2/design/design.dart';
import 'package:covertosa_2/models/customers.dart';
import 'package:covertosa_2/providers/customers_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomerPage extends StatelessWidget {
  const CustomerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Customers customer =
        ModalRoute.of(context)!.settings.arguments as Customers;
    return ChangeNotifierProvider(
      child: _Content(customer: customer),
      create: (_) => CustomersProvider(),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({
    super.key,
    required this.customer,
  });

  final Customers customer;

  @override
  Widget build(BuildContext context) {
    final customerProvider = Provider.of<CustomersProvider>(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: customer.id == null
            ? () async {
                await customerProvider.addCustomerLocal(
                  customer,
                );
                // ignore: use_build_context_synchronously
                await customerProvider.getCustomers();
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
                // ignore: use_build_context_synchronously
                Navigator.pushReplacementNamed(context, CUSTOMERS_ROUTE);
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Cliente creado con éxito'),
                  ),
                );
              }
            : () async {
                await customerProvider.updateCustomerLocal(
                  customer,
                );
                // ignore: use_build_context_synchronously
                await customerProvider.getCustomers();
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
                // ignore: use_build_context_synchronously
                Navigator.pushReplacementNamed(context, CUSTOMERS_ROUTE);
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Cliente actualizado con éxito'),
                  ),
                );
              },
        backgroundColor: AppColors.tertiary,
        child: customerProvider.isLoading
            ? const CircularProgressIndicator(
                color: Colors.white,
              )
            : const Icon(
                Icons.save,
                color: Colors.white,
              ),
      ),
      appBar: AppBar(
        title: customer.id == null
            ? const Text('Nuevo cliente')
            : Text(customer.name!),
        actions: [
          IconButton(
            onPressed: customer.id == null
                ? null
                : () {
                    customerProvider.deleteCustomerLocal(customer.id!);
                    Navigator.pop(context);
                    // ignore: use_build_context_synchronously
                    Navigator.pushReplacementNamed(context, CUSTOMERS_ROUTE);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Cliente eliminado con éxito'),
                      ),
                    );
                  },
            icon: const Icon(
              Icons.delete,
              // color: AppColors.danger,
              size: 30,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              width: double.infinity,
              height: 200,
              child: Icon(
                Icons.person,
                size: 100,
                color: Colors.grey,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: customer.cod,
                      enabled: customer.id == null,
                      onChanged: (value) => customer.cod = value,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Ingrese el código';
                        }
                        return null;
                      },
                      decoration: InputsDeocrations.textFormDecoration(
                          labelText: 'Código', hintText: 'Ingrese el código'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      initialValue: customer.document,
                      enabled: customer.id == null,
                      onChanged: (value) => customer.document = value,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Ingrese la cedula';
                        }
                        return null;
                      },
                      decoration: InputsDeocrations.textFormDecoration(
                          labelText: 'Cédula / Pasaporte',
                          hintText: 'Ingrese la cédula / pasaporte'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      initialValue: customer.name,
                      onChanged: (value) => customer.name = value,
                      decoration: InputsDeocrations.textFormDecoration(
                          labelText: 'Nombre', hintText: 'Ingrese el nombre'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      initialValue: customer.lastname,
                      onChanged: (value) => customer.lastname = value,
                      decoration: InputsDeocrations.textFormDecoration(
                          labelText: 'Apellido',
                          hintText: 'Ingrese el apellido'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      initialValue: customer.phone,
                      onChanged: (value) => customer.phone = value,
                      decoration: InputsDeocrations.textFormDecoration(
                          labelText: 'Teléfono',
                          hintText: 'Ingrese el teléfono'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      initialValue: customer.address,
                      onChanged: (value) => customer.address = value,
                      decoration: InputsDeocrations.textFormDecoration(
                          labelText: 'Dirección',
                          hintText: 'Ingrese la dirección'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      initialValue: customer.email,
                      onChanged: (value) => customer.email = value,
                      decoration: InputsDeocrations.textFormDecoration(
                          labelText: 'Email', hintText: 'Ingrese el email'),
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
