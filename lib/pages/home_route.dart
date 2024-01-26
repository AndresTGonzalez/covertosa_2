import 'package:covertosa_2/design/design.dart';
import 'package:covertosa_2/pages/pages.dart';
import 'package:flutter/material.dart';

class HomeRoute extends StatefulWidget {
  const HomeRoute({super.key});

  @override
  State<HomeRoute> createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: AppColors.tertiary,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Inicio',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.point_of_sale),
            icon: Icon(Icons.point_of_sale_outlined),
            label: 'Transacciones',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.print),
            icon: Icon(Icons.print_outlined),
            label: 'Consultas',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.sell),
            icon: Icon(Icons.sell_outlined),
            label: 'Ventas',
          ),
        ],
      ),
      body: <Widget>[
        const HomePage(),
        const Center(child: Text('Transacciones')),
        QueriesPage(),
        const Center(child: Text('Ventas')),
      ][currentPageIndex],
    );
  }
}
