import 'package:covertosa_2/pages/home_route.dart';
import 'package:covertosa_2/pages/login_page.dart';
import 'package:covertosa_2/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckAuthPage extends StatelessWidget {
  const CheckAuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      body: FutureBuilder(
        future: authProvider.isLogged(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            // Espere
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data == '') {
            Future.microtask(() {
              Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const LoginPage(),
                      transitionDuration: const Duration(seconds: 0)));
            });
          } else {
            Future.microtask(() {
              Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const HomeRoute(),
                      transitionDuration: const Duration(seconds: 0)));
            });
          }

          return const SizedBox();
        },
      ),
    );
  }
}
