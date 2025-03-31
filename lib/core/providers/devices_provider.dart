import 'package:ekonum_app/core/models/app_model.dart';
import 'package:ekonum_app/core/models/node_model.dart';
import 'package:ekonum_app/core/providers/app_provider.dart';
import 'package:ekonum_app/core/providers/dashboard_provider.dart';
import 'package:flutter/foundation.dart';

// This provider combines node info with the apps running on them
class DevicesProvider with ChangeNotifier {
  List<Node> _nodes = [];
  List<Application> _apps = [];

  bool _isLoading = false;
  String? _error;

  // Getters
  List<Node> get nodes => List.unmodifiable(_nodes);

  bool get isLoading => _isLoading;

  String? get error => _error;

  // Get apps running on a specific node
  List<AppBasicInfo> getAppsRunningOnNode(String nodeId) {
    List<AppBasicInfo> nodeApps = [];
    for (var app in _apps) {
      for (var replica in app.replicas) {
        if (replica.nodeId == nodeId) {
          nodeApps.add(
            AppBasicInfo(
              id: app.id,
              name: app.name,
              replicaId: replica.replicaId,
              cpuUsage: replica.cpuUsage,
              ramUsage: replica.ramUsage,
            ),
          );
        }
      }
    }
    return nodeApps;
  }

  // Method to update data (call this from other providers or on init)
  void updateData({
    required List<Node> nodes,
    required List<Application> apps,
  }) {
    _nodes = nodes;
    _apps = apps;
    if (kDebugMode) {
      print("DevicesProvider data updated.");
    }
    notifyListeners();
  }

  // Example method to fetch combined data (in real app)
  Future<void> fetchDeviceAndAppData(
    DashboardProvider dashboardProvider,
    AppProvider appProvider,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 100)); // Simulate delay
      _nodes = dashboardProvider.nodes;
      _apps = appProvider.installedApps;
    } catch (e) {
      _error = "Failed to load device data: $e";
      if (kDebugMode) {
        print(_error);
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

// Simplified App info for the device list
class AppBasicInfo {
  final String id;
  final String name;
  final String replicaId;
  final double cpuUsage;
  final double ramUsage;

  AppBasicInfo({
    required this.id,
    required this.name,
    required this.replicaId,
    required this.cpuUsage,
    required this.ramUsage,
  });
}
