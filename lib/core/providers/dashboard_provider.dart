import 'package:ekonum_app/core/models/node_model.dart';
import 'package:flutter/foundation.dart';

class DashboardProvider with ChangeNotifier {
  // --- Mock Data ---
  final double _clusterCpuUsage = 0.42;
  final double _clusterRamUsage = 0.38;
  final int _totalAppsRunning = 12;
  final List<Node> _nodes = [
    Node(
      id: 'node-1',
      name: 'Node 1 (Alpha)',
      cpuUsage: 0.65,
      ramUsage: 0.48,
      appsRunningCount: 5,
    ),
    Node(
      id: 'node-2',
      name: 'Node 2 (Beta)',
      cpuUsage: 0.32,
      ramUsage: 0.27,
      appsRunningCount: 4,
    ),
    Node(
      id: 'node-3',
      name: 'Node 3 (Gamma)',
      cpuUsage: 0.18,
      ramUsage: 0.42,
      appsRunningCount: 3,
    ),
  ];

  // --- End Mock Data ---

  // --- Getters ---
  double get clusterCpuUsage => _clusterCpuUsage;

  double get clusterRamUsage => _clusterRamUsage;

  int get totalAppsRunning => _totalAppsRunning;

  List<Node> get nodes => List.unmodifiable(_nodes); // Return unmodifiable list

  // --- Methods ---
  Node? getNodeById(String id) {
    try {
      return _nodes.firstWhere((node) => node.id == id);
    } catch (e) {
      return null; // Node not found
    }
  }

  // Add methods to refresh data from API later
  Future<void> fetchDashboardData() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    // In a real app, update _clusterCpuUsage, _clusterRamUsage, _totalAppsRunning, _nodes
    // _clusterCpuUsage = ...
    // _nodes = ...
    if (kDebugMode) {
      print("Dashboard data refreshed (mock)");
    }
    notifyListeners(); // Notify UI to rebuild
  }
}
