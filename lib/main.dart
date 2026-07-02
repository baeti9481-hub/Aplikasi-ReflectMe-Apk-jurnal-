import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const ReflectMeApp());
}

class ReflectMeApp extends StatelessWidget {
  const ReflectMeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ReflectMe',
      theme: ThemeData(
        fontFamily: 'Poppins',
      ),
      home: const SplashScreen(),
    );
  }
}