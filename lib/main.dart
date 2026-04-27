import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color(0xFF1A2D6B),
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const EgyptAirApp());
}

class EgyptAirApp extends StatelessWidget {
  const EgyptAirApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EgyptAir Flight Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A2D6B),
          primary: const Color(0xFF1A2D6B),
        ),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
