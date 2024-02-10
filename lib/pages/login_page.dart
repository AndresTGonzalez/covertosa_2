import 'package:covertosa_2/constants.dart';
import 'package:covertosa_2/design/design.dart';
import 'package:covertosa_2/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/providers.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: width,
          height: height,
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                SizedBox(
                  width: width,
                  height: height * 0.25,
                  child: Image.asset(
                    'assets/img/logo_covertosa.png',
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 50),
                const Text(
                  'Bienvenido',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                ChangeNotifierProvider(
                  child: _NetworkStatus(width: width),
                  create: (_) => NetworkStatusProvider(),
                ),
                const SizedBox(height: 30),
                MultiProvider(
                  providers: [
                    ChangeNotifierProvider(
                      create: (_) => AuthProvider(),
                    ),
                    ChangeNotifierProvider(
                      create: (_) => NetworkStatusProvider(),
                    ),
                  ],
                  child: const _LoginForm(),
                ),
                const SizedBox(height: 30),
                const SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Design by: Triton Media Studio, L.A.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                const SizedBox(height: 75),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NetworkStatus extends StatelessWidget {
  const _NetworkStatus({
    required this.width,
  });

  final double width;

  @override
  Widget build(BuildContext context) {
    final networkStatusProvider = Provider.of<NetworkStatusProvider>(context);

    return Row(
      children: [
        const Text('Estado:'),
        const SizedBox(width: 10),
        Container(
          width: width * 0.3,
          height: 30,
          decoration: BoxDecoration(
            // color: AppColors.success,
            color: networkStatusProvider.isOnline
                ? AppColors.success
                : AppColors.gray,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Center(
            child: Text(
              networkStatusProvider.isOnline ? 'En linea' : 'Desconectado',
              style: TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final networkStatusProvider = Provider.of<NetworkStatusProvider>(context);

    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: authProvider.formKey,
      child: Column(
        children: [
          TextFormField(
            cursorColor: Colors.grey,
            keyboardType: TextInputType.emailAddress,
            initialValue: authProvider.user,
            onChanged: (value) => authProvider.user = value,
            decoration: InputsDeocrations.textFormDecoration(
              labelText: 'Usuario',
              hintText: 'Ingrese su usuario',
              prefixIcon: Icons.person,
            ),
            validator: (value) {
              String pattern =
                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
              RegExp regExp = RegExp(pattern);
              return regExp.hasMatch(value ?? '')
                  ? null
                  : 'Por favor ingrese un correo válido';
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            cursorColor: Colors.grey,
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            initialValue: authProvider.password,
            onChanged: (value) => authProvider.password = value,
            decoration: InputsDeocrations.textFormDecoration(
              labelText: 'Contraseña',
              hintText: 'Ingrese su contraseña',
              prefixIcon: Icons.lock,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingrese su contraseña';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () async {
              User? user = await authProvider.login(
                context: context,
              );
              if (user != null) {
                // ignore: use_build_context_synchronously
                Navigator.pushReplacementNamed(context, HOME_ROUTE);
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
            child: Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: authProvider.isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: AppColors.white,
                      ),
                    )
                  : Text(
                      'Iniciar sesión',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
