import 'package:ekonum_app/app.dart';
import 'package:ekonum_app/core/providers/app_provider.dart';
import 'package:ekonum_app/core/providers/dashboard_provider.dart';
import 'package:ekonum_app/core/providers/devices_provider.dart';
import 'package:ekonum_app/core/providers/storage_provider.dart';
import 'package:ekonum_app/core/providers/store_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    // Wrap the entire app with MultiProvider
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => DevicesProvider()),
        ChangeNotifierProvider(create: (_) => StorageProvider()),
        ChangeNotifierProvider(create: (_) => StoreProvider()),
      ],
      child: const EkonumApp(),
    ),
  );
}
