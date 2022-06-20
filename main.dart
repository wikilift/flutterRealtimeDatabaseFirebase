import 'package:app_firebase_example/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/screens.dart';

void main() => runApp(const Appstate());

//dependecy injection
class Appstate extends StatelessWidget {
  const Appstate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ProductDataSource(),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthService(),
        )
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: NotificationService.messengerKey,
      debugShowCheckedModeBanner: false,
      title: 'Products App',
      initialRoute: 'splash',
      routes: {
        'login': (_) => const LoginScreen(),
        'home': (_) => const HomeScreen(),
        'product': (context) => const ProductEditScreen(),
        'register': (context) => const RegisterScreen(),
        'splash': (context) => const SplashScreen(),
      },
      theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: Colors.grey[300],
          appBarTheme: const AppBarTheme(color: Colors.amberAccent),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.amberAccent,
          )),
    );
  }
}
