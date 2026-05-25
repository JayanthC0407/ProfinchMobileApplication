import 'package:flutter/material.dart';
import 'package:profinch_mobile_application/features/auth/screens/login_screen.dart';
import 'package:profinch_mobile_application/features/dashboard/provider/dashboard_provider.dart';
import 'package:profinch_mobile_application/features/dashboard/screens/dashboard_screen.dart';
import 'package:provider/provider.dart';
void main() {
  runApp(
     MultiProvider(
      providers: [

        ChangeNotifierProvider(
          create: (_) => DashboardProvider(),
        ),
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
      home: const LoginScreen(),
    );
  }
}