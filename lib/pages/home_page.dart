import 'package:covertosa_2/constants.dart';
import 'package:covertosa_2/design/cards_decoration.dart';
import 'package:covertosa_2/design/design.dart';
import 'package:covertosa_2/models/trade_routes.dart';
import 'package:covertosa_2/providers/providers.dart';
import 'package:covertosa_2/utils/snackbar_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<OrderProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: 25,
                ),
                ChangeNotifierProvider(
                  create: (_) => AuthProvider(),
                  child: const _Header(),
                ),
                const SizedBox(
                  height: 25,
                ),
                SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          await ordersProvider.getTradeRoutes();
                          // ignore: use_build_context_synchronously
                          showDialog(
                            context: context,
                            builder: (_) => const _RouteDialog(),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.2,
                          decoration: CardsDecoration.homeCardDecoration(),
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.start,
                                size: 50,
                                color: AppColors.secondary,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              const Text(
                                'Inicio del día',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          await ordersProvider.sendLocalOrders();
                          // ignore: use_build_context_synchronously
                          SnackbarMessage.show(
                            context: context,
                            message: 'Ordenes enviadas',
                            isError: false,
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.2,
                          decoration: CardsDecoration.homeCardDecoration(),
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ordersProvider.isLoading
                                  ? CircularProgressIndicator(
                                      color: AppColors.primary,
                                    )
                                  : Icon(
                                      Icons.local_shipping,
                                      size: 50,
                                      color: AppColors.secondary,
                                    ),
                              const SizedBox(
                                width: 20,
                              ),
                              const Text(
                                'Fin del día',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ChangeNotifierProvider(
                        child: const _SyncCard(),
                        create: (_) => SyncProvider(),
                      ),
                    ],
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

class _RouteDialog extends StatelessWidget {
  const _RouteDialog();

  @override
  Widget build(BuildContext context) {
    final customersProvider = Provider.of<CustomersProvider>(context);
    final ordersProvider = Provider.of<OrderProvider>(context);

    return AlertDialog(
      title: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Seleccionar las rutas"),
          // Fecha de ahora
          Text(
            'Fecha: ${ordersProvider.todayDate}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'Cancelar',
            style: TextStyle(
              color: AppColors.danger,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            // jobRoutesProvider.accept();
            customersProvider.stayInOrder = true;
            Navigator.pushReplacementNamed(context, CUSTOMERS_ROUTE_NC);
          },
          child: Text(
            'Aceptar',
            style: TextStyle(
              color: AppColors.secondary,
            ),
          ),
        ),
      ],
      content: Container(
        alignment: Alignment.center,
        width: 400,
        height: 125,
        child: const _RoutesList(),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Row(
      children: [
        Text(
          'Bienvenido, ${authProvider.name}',
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w400,
          ),
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            authProvider.logout();
            Navigator.pushReplacementNamed(context, LOGIN_ROUTE);
          },
        ),
      ],
    );
  }
}

class _SyncCard extends StatelessWidget {
  const _SyncCard();

  @override
  Widget build(BuildContext context) {
    final syncProvider = Provider.of<SyncProvider>(context);

    return GestureDetector(
      onTap: () async {
        if (await syncProvider.sync()) {
          // ignore: use_build_context_synchronously
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Sincronización exitosa'),
              content: const Text('La sincronización se realizó con éxito'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Aceptar',
                    style: TextStyle(
                      color: AppColors.success,
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          // ignore: use_build_context_synchronously
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Sincronización fallida'),
              content: const Text('La sincronización falló'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Aceptar',
                    style: TextStyle(
                      color: AppColors.success,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
      child: syncProvider.isLoading
          ? Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.2,
              decoration: CardsDecoration.homeCardDecoration(),
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  const Text(
                    'Sincronizando...',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const Spacer(),
                  CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                ],
              ),
            )
          : Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.2,
              decoration: CardsDecoration.homeCardDecoration(),
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.sync,
                    size: 50,
                    color: AppColors.secondary,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  const Text(
                    'Sincronizar',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

// ignore: must_be_immutable
class _RoutesList extends StatelessWidget {
  const _RoutesList();

  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<OrderProvider>(context);
    return ListView.builder(
      itemCount: ordersProvider.tradeRoutes.length,
      itemBuilder: (_, i) {
        final tradeRoute = ordersProvider.tradeRoutes[i];
        return RadioListTile(
          value: tradeRoute,
          title: Text(tradeRoute.code!),
          activeColor: AppColors.primary,
          groupValue: ordersProvider.tradeRoute,
          onChanged: (value) {
            ordersProvider.tradeRoute = value as TradeRoutes;
          },
        );
      },
    );
  }
}
