import 'package:ekonum_app/core/models/app_model.dart';
import 'package:ekonum_app/core/models/replica_info.dart';
import 'package:flutter/foundation.dart';

import 'app_provider.dart';

// Represents an app available in the store
class StoreApp {
  final String id;
  final String name;
  final String description;
  final String category;
  final String cpuRequirement; // e.g., "Low", "Medium"
  final String ramRequirement; // e.g., "Low", "Medium"
  bool isInstalled; // Keep track locally
  bool isProcessing; // For install/uninstall button state

  StoreApp({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.cpuRequirement,
    required this.ramRequirement,
    this.isInstalled = false,
    this.isProcessing = false,
  });

  // Method to create a full Application model (used when installing)
  Application toApplicationModel() {
    // Provide default/mock values for fields not in StoreApp
    return Application(
      id: id,
      name: name,
      description: description,
      version: '1.0.0',
      // Default version
      totalCpuUsage: 0.1,
      // Placeholder usage
      totalRamUsage: 0.1,
      // Placeholder usage
      replicas: [
        // Start with one replica on a default node (adjust logic)
        ReplicaInfo(
          replicaId: 'Copy 1',
          nodeId: 'node-1',
          nodeName: 'Node 1 (Alpha)',
          cpuUsage: 0.1,
          ramUsage: 0.1,
        ),
      ],
    );
  }
}

class StoreProvider with ChangeNotifier {
  // --- Mock Data ---
  final List<StoreApp> _availableApps = [
    StoreApp(
      id: 'db',
      name: 'Database Server',
      description: 'High-performance SQL database for your applications',
      category: 'Servers',
      cpuRequirement: 'Low',
      ramRequirement: 'Medium',
      isInstalled: true,
      isProcessing: false,
    ), // Mark as installed
    StoreApp(
      id: 'web',
      name: 'Web Server',
      description: 'Fast and secure web server with SSL support',
      category: 'Servers',
      cpuRequirement: 'Low',
      ramRequirement: 'Low',
      isInstalled: true,
      isProcessing: false,
    ), // Mark as installed
    StoreApp(
      id: 'fs',
      name: 'File Storage',
      description: 'Secure cloud storage for all your files',
      category: 'Storage',
      cpuRequirement: 'Low',
      ramRequirement: 'Medium',
      isInstalled: false,
      isProcessing: false,
    ),
    StoreApp(
      id: 'mon',
      name: 'Monitoring',
      description: 'Real-time monitoring and alerts for your cluster',
      category: 'Monitoring',
      cpuRequirement: 'Very Low',
      ramRequirement: 'Low',
      isInstalled: false,
      isProcessing: false,
    ),
    StoreApp(
      id: 'auth',
      name: 'Authentication',
      description: 'Secure user authentication and authorization',
      category: 'Security',
      cpuRequirement: 'Low',
      ramRequirement: 'Low',
      isInstalled: false,
      isProcessing: false,
    ),
    StoreApp(
      id: 'git',
      name: 'Git Server',
      description: 'Host your own private Git repositories',
      category: 'Dev Tools',
      cpuRequirement: 'Low',
      ramRequirement: 'Medium',
      isInstalled: false,
      isProcessing: false,
    ),
  ];

  final List<String> _categories = [
    'All',
    'Servers',
    'Storage',
    'Security',
    'Monitoring',
    'Dev Tools',
  ];
  String _selectedCategory = 'All';
  String _searchQuery = '';

  // --- End Mock Data ---

  // --- Getters ---
  List<String> get categories => _categories;

  String get selectedCategory => _selectedCategory;

  String get searchQuery => _searchQuery;

  List<StoreApp> get filteredApps {
    return List.unmodifiable(
      _availableApps.where((app) {
        final query = _searchQuery.toLowerCase();
        final matchesCategory =
            _selectedCategory == 'All' || app.category == _selectedCategory;
        final matchesSearch =
            query.isEmpty ||
            app.name.toLowerCase().contains(query) ||
            app.description.toLowerCase().contains(query);
        return matchesCategory && matchesSearch;
      }),
    );
  }

  // --- Methods ---

  void setCategory(String category) {
    if (_categories.contains(category) && _selectedCategory != category) {
      _selectedCategory = category;
      if (kDebugMode) {
        print("Store category set to: $category");
      }
      notifyListeners();
    }
  }

  void search(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // Method called by AppProvider to update install status if needed
  void updateInstallStatus(String appId, bool installed) {
    final appIndex = _availableApps.indexWhere((app) => app.id == appId);
    if (appIndex != -1 && _availableApps[appIndex].isInstalled != installed) {
      _availableApps[appIndex].isInstalled = installed;
      _availableApps[appIndex].isProcessing =
          false; // Ensure processing state is reset
      if (kDebugMode) {
        print("Updated install status for $appId in store: $installed");
      }
      notifyListeners();
    }
  }

  // Simulate Install/Uninstall actions
  Future<void> installApp(String appId, AppProvider appProvider) async {
    final appIndex = _availableApps.indexWhere((app) => app.id == appId);
    if (appIndex != -1 && !_availableApps[appIndex].isProcessing) {
      _availableApps[appIndex].isProcessing = true;
      notifyListeners();
      if (kDebugMode) {
        print("Attempting to install $appId...");
      }

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      bool success = true; // Assume success for mock

      if (success) {
        _availableApps[appIndex].isInstalled = true;
        if (kDebugMode) {
          print("$appId installed successfully (mock).");
        }
        // Add to the AppProvider's list
        appProvider.addInstalledApp(
          _availableApps[appIndex].toApplicationModel(),
        );
      }

      _availableApps[appIndex].isProcessing = false;
      notifyListeners();
    }
  }

  Future<void> uninstallApp(String appId, AppProvider appProvider) async {
    final appIndex = _availableApps.indexWhere((app) => app.id == appId);
    if (appIndex != -1 && !_availableApps[appIndex].isProcessing) {
      _availableApps[appIndex].isProcessing = true;
      notifyListeners();
      if (kDebugMode) {
        print("Attempting to uninstall $appId...");
      }

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      bool success = true; // Assume success for mock

      if (success) {
        _availableApps[appIndex].isInstalled = false;
        if (kDebugMode) {
          print("$appId uninstalled successfully (mock).");
        }
        // Remove from AppProvider's list
        appProvider.removeInstalledApp(appId);
      } else {
        if (kDebugMode) {
          print("Failed to uninstall $appId (mock).");
        }
        // Show error message?
      }

      _availableApps[appIndex].isProcessing = false;
      notifyListeners();
    }
  }

  // Method to sync installed status with AppProvider on init or refresh
  void syncInstalledApps(List<Application> installedApps) {
    bool changed = false;
    for (var storeApp in _availableApps) {
      bool actuallyInstalled = installedApps.any(
        (installedApp) => installedApp.id == storeApp.id,
      );
      if (storeApp.isInstalled != actuallyInstalled) {
        storeApp.isInstalled = actuallyInstalled;
        storeApp.isProcessing = false; // Reset processing state
        changed = true;
      }
    }
    if (changed) {
      if (kDebugMode) {
        print("StoreProvider synced install status with AppProvider.");
      }
      notifyListeners();
    }
  }

  // Add method to fetch apps from API later
  Future<void> fetchAvailableApps(AppProvider appProvider) async {
    if (kDebugMode) {
      print("Fetching available apps from store (mock)...");
    }
    await Future.delayed(const Duration(seconds: 1));
    // Update _availableApps from API
    // After fetching, sync install status:
    syncInstalledApps(appProvider.installedApps);
    notifyListeners(); // Notify UI anyway
  }
}
