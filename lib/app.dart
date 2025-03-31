import 'package:ekonum_app/config/theme.dart';
import 'package:ekonum_app/features/auth/screens/login_screen.dart'; // Assuming you have a login screen eventually
import 'package:ekonum_app/features/main_navigator.dart';
import 'package:flutter/material.dart';

bool _isUserLoggedIn = true; // Mock login state

class EkonumApp extends StatelessWidget {
  const EkonumApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Basic Navigator 1.0 setup for now
    return MaterialApp(
      title: 'Ekonum',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      // Optional
      themeMode: ThemeMode.light,
      // Or system
      debugShowCheckedModeBanner: false,
      home: _isUserLoggedIn ? const MainNavigator() : const LoginScreen(),
    );
  }
}
