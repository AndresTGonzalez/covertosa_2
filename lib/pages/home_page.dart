import 'package:covertosa_2/constants.dart';
import 'package:covertosa_2/design/cards_decoration.dart';
import 'package:covertosa_2/design/design.dart';
import 'package:covertosa_2/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
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
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) => ChangeNotifierProvider(
                              child: const _RouteDialog(),
                              create: (_) => JobRoutesProvider(),
                            ),
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
                                color: AppColors.tertiary,
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
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.2,
                        decoration: CardsDecoration.homeCardDecoration(),
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.local_shipping,
                              size: 50,
                              color: AppColors.tertiary,
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
    final jobRoutesProvider = Provider.of<JobRoutesProvider>(context);
    final customersProvider = Provider.of<CustomersProvider>(context);

    return AlertDialog(
      title: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Seleccionar las rutas"),
          // Fecha de ahora
          Text(
            'Fecha: ${jobRoutesProvider.todayDate}',
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
            jobRoutesProvider.accept();
            customersProvider.stayInOrder = true;
            Navigator.pushReplacementNamed(context, CUSTOMERS_ROUTE_NC);
          },
          child: Text(
            'Aceptar',
            style: TextStyle(
              color: AppColors.success,
            ),
          ),
        ),
      ],
      content: Container(
        alignment: Alignment.center,
        width: 400,
        height: 125,
        child: _RoutesList(
          jobRoutesProvider: jobRoutesProvider,
        ),
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
                    color: AppColors.tertiary,
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
                    color: AppColors.tertiary,
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
  JobRoutesProvider jobRoutesProvider;

  _RoutesList({
    required this.jobRoutesProvider,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: jobRoutesProvider.tradeRoutes.length,
      itemBuilder: (_, i) {
        final tradeRoute = jobRoutesProvider.tradeRoutes[i];
        return ListTile(
          title: Text(tradeRoute.code!),
          trailing: Checkbox(
            activeColor: AppColors.tertiary,
            value: tradeRoute.selected,
            onChanged: (bool? value) {
              if (value!) {
                jobRoutesProvider.addTradeRoute(tradeRoute);
              } else {
                jobRoutesProvider.removeTradeRoute(tradeRoute.id!);
              }
            },
          ),
        );
      },
    );
  }
}
