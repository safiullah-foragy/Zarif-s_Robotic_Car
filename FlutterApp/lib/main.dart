import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'providers/car_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CarController(),
      child: MaterialApp(
        title: "Zarif's Car",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.cyan,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF0a0e27),
          useMaterial3: true,
          colorScheme: ColorScheme.dark(
            primary: const Color(0xFF00e5ff),
            secondary: const Color(0xFFff4081),
            surface: const Color(0xFF1a1f3a),
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
