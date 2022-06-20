import 'package:app_firebase_example/screens/screens.dart';
import 'package:app_firebase_example/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    return Scaffold(
      body: Center(
          child: FutureBuilder(
        future: authService.readToken(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator.adaptive();
          }

          if (snapshot.data == '') {
            Future.microtask(() {
              // Navigator.of(context).pushReplacementNamed('home');
              Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                      transitionDuration: const Duration(seconds: 0),
                      pageBuilder: (_, __, ___) => const LoginScreen()));
            });
          } else {
            Future.microtask(() {
              // Navigator.of(context).pushReplacementNamed('home');
              Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                      transitionDuration: const Duration(seconds: 0), pageBuilder: (_, __, ___) => const HomeScreen()));
            });
          }

          return Container();
        },
      )),
    );
  }
}
