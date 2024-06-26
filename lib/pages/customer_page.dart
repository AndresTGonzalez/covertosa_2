import 'package:covertosa_2/constants.dart';
import 'package:covertosa_2/design/design.dart';
import 'package:covertosa_2/models/customers.dart';
import 'package:covertosa_2/providers/customers_provider.dart';
import 'package:covertosa_2/utils/snackbar_message.dart';
import 'package:covertosa_2/validators/validators.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomerPage extends StatelessWidget {
  const CustomerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Customers customer =
        ModalRoute.of(context)!.settings.arguments as Customers;
    return _Content(customer: customer);
  }
}

class _Content extends StatelessWidget {
  const _Content({
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
                await customerProvider.addCustomer(
                  customer,
                );
                // ignore: use_build_context_synchronously
                await customerProvider.getCustomers();
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
                // ignore: use_build_context_synchronously
                if (customerProvider.stayInOrder) {
                  // ignore: use_build_context_synchronously
                  Navigator.pushReplacementNamed(context, CUSTOMERS_ROUTE_NC);
                } else {
                  // ignore: use_build_context_synchronously
                  Navigator.pushReplacementNamed(context, CUSTOMERS_ROUTE);
                }
                // ignore: use_build_context_synchronously
                SnackbarMessage.show(
                  context: context,
                  message: 'Cliente creado con éxito',
                  isError: false,
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
                SnackbarMessage.show(
                  context: context,
                  message: 'Cliente actualizado con éxito',
                  isError: false,
                );
              },
        backgroundColor: AppColors.primary,
        child: customerProvider.isLoading
            ? CircularProgressIndicator(
                color: AppColors.white,
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
          customer.id == null
              ? Container()
              : IconButton(
                  onPressed: () {
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
                      initialValue: customer.document,
                      enabled: customer.id == null,
                      onChanged: (value) => customer.document = value,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Ingrese la cedula';
                        }
                        if (!DocumentValidator.identificationCardValidator(
                            value)) {
                          return 'Cédula incorrecta';
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
                      keyboardType: TextInputType.phone,
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
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Ingrese el email';
                        }
                        if (!FormValidator.emailValidator(value)) {
                          return 'Email incorrecto';
                        }
                        return null;
                      },
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
