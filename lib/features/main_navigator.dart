import 'package:ekonum_app/core/providers/app_provider.dart';
import 'package:ekonum_app/core/providers/dashboard_provider.dart';
import 'package:ekonum_app/core/providers/devices_provider.dart';
import 'package:ekonum_app/core/providers/storage_provider.dart';
import 'package:ekonum_app/core/providers/store_provider.dart';
import 'package:ekonum_app/features/dashboard/screens/dashboard_screen.dart';
import 'package:ekonum_app/features/devices/screens/devices_screen.dart';
import 'package:ekonum_app/features/my_apps/screens/my_apps_screen.dart';
import 'package:ekonum_app/features/storage/screens/storage_screen.dart';
import 'package:ekonum_app/features/store/screens/app_store_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainNavigator extends StatefulWidget {
  const MainNavigator({super.key});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int _selectedIndex = 0; // Default to Dashboard

  // Use final instead of const because screen constructors are not constants
  static final List<Widget> _widgetOptions = <Widget>[
    const DashboardScreen(),
    const MyAppsScreen(),
    const DevicesScreen(),
    // Represents the combined "Nodes & Applications" view
    const StorageScreen(),
    const AppStoreScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Load initial data for providers when the main navigator loads
    // Use addPostFrameCallback to ensure providers are available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Fetch initial data - no need to await if background loading is okay
      final dashboardProvider = context.read<DashboardProvider>();
      final appProvider = context.read<AppProvider>();
      final storageProvider = context.read<StorageProvider>();
      final storeProvider = context.read<StoreProvider>();
      final devicesProvider = context.read<DevicesProvider>();

      dashboardProvider.fetchDashboardData(); // Mock fetch
      appProvider.fetchInstalledApps(); // Mock fetch
      storageProvider.fetchStorageData(); // Mock fetch
      storeProvider.fetchAvailableApps(
        appProvider,
      ); // Mock fetch & sync install status

      // Initial update for DevicesProvider based on already loaded mock data
      devicesProvider.updateData(
        nodes: dashboardProvider.nodes,
        apps: appProvider.installedApps,
      );

      // Listen for changes in app/dashboard providers to update devices provider
      dashboardProvider.addListener(() {
        devicesProvider.updateData(
          nodes: dashboardProvider.nodes,
          apps: appProvider.installedApps,
        );
      });
      appProvider.addListener(() {
        devicesProvider.updateData(
          nodes: dashboardProvider.nodes,
          apps: appProvider.installedApps,
        );
        // Also notify store provider about install status changes
        storeProvider.syncInstalledApps(appProvider.installedApps);
      });

      // Initial sync for store provider as well
      storeProvider.syncInstalledApps(appProvider.installedApps);

      if (kDebugMode) {
        print("Initial data fetch triggered for all providers.");
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        // Use IndexedStack to keep state of inactive screens
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      // Alternative: Simple body change - resets state on tab switch
      // body: Center(
      //   child: _widgetOptions.elementAt(_selectedIndex),
      // ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.apps_outlined),
            activeIcon: Icon(Icons.apps),
            label: 'My Apps',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dns_outlined), // Icon representing Nodes/Devices
            activeIcon: Icon(Icons.dns),
            label: 'Devices',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.storage_outlined),
            activeIcon: Icon(Icons.storage),
            label: 'Storage',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store_outlined),
            activeIcon: Icon(Icons.store),
            label: 'Store',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        // Theme settings are applied via bottomNavigationBarTheme in AppTheme
      ),
    );
  }
}
