import 'package:flutter/material.dart';
import 'package:profinch_mobile_application/features/cards/provider/card_provider.dart';
import 'package:profinch_mobile_application/features/cards/screens/card_screen.dart';
import 'package:provider/provider.dart';
import 'core/routes/app_routes.dart';

import 'features/auth/provider/auth_provider.dart';
import 'features/dashboard/provider/dashboard_provider.dart';
import 'features/auth/screens/splash_screen.dart';     
import 'features/auth/screens/login_screen.dart';
import 'features/dashboard/screens/dashboard_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => CardProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profinch Bank',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 165, 24, 64),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'SF Pro Display',
      ),
      initialRoute: AppRoutes.splash,            
      routes: {
        AppRoutes.splash: (context) => const SplashScreen(),   
        AppRoutes.login: (context) => const LoginScreen(),
        AppRoutes.dashboard: (context) => const DashboardScreen(),
        AppRoutes.cards: (context) => const CardsScreen(),

      },
    );
  }
}