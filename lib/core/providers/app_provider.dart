import 'package:ekonum_app/core/models/app_model.dart';
import 'package:ekonum_app/core/models/replica_info.dart';
import 'package:flutter/foundation.dart';

class AppProvider with ChangeNotifier {
  // --- Mock Data ---
  final List<Application> _installedApps = [
    Application(
      id: 'db',
      name: 'Database Server',
      description: 'High-performance SQL database',
      version: '3.2.1',
      totalCpuUsage: 0.28,
      totalRamUsage: 0.22,
      replicas: [
        ReplicaInfo(
          replicaId: 'Copy 1',
          nodeId: 'node-1',
          nodeName: 'Node 1 (Alpha)',
          cpuUsage: 0.28,
          ramUsage: 0.22,
        ),
      ],
    ),
    Application(
      id: 'web',
      name: 'Web Server',
      description: 'Fast and secure web server with SSL support',
      version: '1.19.0',
      totalCpuUsage: 0.15 + 0.16,
      // Sum of replicas
      totalRamUsage: 0.12 + 0.10,
      // Sum of replicas
      replicas: [
        ReplicaInfo(
          replicaId: 'Copy 1',
          nodeId: 'node-2',
          nodeName: 'Node 2 (Beta)',
          cpuUsage: 0.15,
          ramUsage: 0.12,
        ),
        ReplicaInfo(
          replicaId: 'Copy 2',
          nodeId: 'node-3',
          nodeName: 'Node 3 (Gamma)',
          cpuUsage: 0.16,
          ramUsage: 0.10,
        ),
      ],
    ),
    // Add more installed apps if needed
  ];

  // --- End Mock Data ---

  // --- Getters ---
  List<Application> get installedApps => List.unmodifiable(_installedApps);

  Application? getAppById(String id) {
    try {
      return _installedApps.firstWhere((app) => app.id == id);
    } catch (e) {
      return null; // App not found
    }
  }

  // --- Methods ---

  // Called from StoreProvider when an app is installed
  void addInstalledApp(Application app) {
    if (!_installedApps.any((a) => a.id == app.id)) {
      _installedApps.add(app);
      if (kDebugMode) {
        print("App added to installed list: ${app.name}");
      }
      notifyListeners();
    }
  }

  // Called from StoreProvider when an app is uninstalled
  void removeInstalledApp(String appId) {
    final initialLength = _installedApps.length;
    _installedApps.removeWhere((app) => app.id == appId);
    if (_installedApps.length < initialLength) {
      if (kDebugMode) {
        print("App removed from installed list: $appId");
      }
      notifyListeners();
    }
  }

  Future<void> addReplica(String appId) async {
    // Simulate API call to add a replica
    if (kDebugMode) {
      print("Adding replica for $appId (mock)");
    }
    await Future.delayed(const Duration(milliseconds: 500));

    final appIndex = _installedApps.findIndex((app) => app.id == appId);
    if (appIndex != -1) {
      // Find a node to add the replica (simple logic for mock)
      // In real app, API would decide or provide options
      final newNodeId =
          'node-${(_installedApps[appIndex].replicas.length % 3) + 1}'; // Cycle through nodes 1, 2, 3
      final newNodeName =
          'Node ${(_installedApps[appIndex].replicas.length % 3) + 1}'; // Mock name

      final newReplica = ReplicaInfo(
        replicaId: 'Copy ${_installedApps[appIndex].replicas.length + 1}',
        nodeId: newNodeId,
        nodeName: newNodeName,
        // Fetch actual name in real app
        cpuUsage: 0.10,
        // Mock usage
        ramUsage: 0.08, // Mock usage
      );
      _installedApps[appIndex].replicas.add(newReplica);
      // Recalculate total usage (simplistic sum)
      _installedApps[appIndex] = _installedApps[appIndex].copyWith(
        totalCpuUsage: _installedApps[appIndex].replicas.fold(
          0.0,
          (sum, r) => sum! + r.cpuUsage,
        ),
        totalRamUsage: _installedApps[appIndex].replicas.fold(
          0.0,
          (sum, r) => sum! + r.ramUsage,
        ),
      );

      notifyListeners();
    }
  }

  Future<void> removeReplica(String appId, String replicaId) async {
    // Simulate API call to remove a replica
    if (kDebugMode) {
      print("Removing replica $replicaId for $appId (mock)");
    }
    await Future.delayed(const Duration(milliseconds: 500));

    final appIndex = _installedApps.findIndex((app) => app.id == appId);
    if (appIndex != -1) {
      final replicaIndex = _installedApps[appIndex].replicas.findIndex(
        (r) => r.replicaId == replicaId,
      );
      if (replicaIndex != -1 && _installedApps[appIndex].replicas.length > 1) {
        // Don't remove last replica easily
        _installedApps[appIndex].replicas.removeAt(replicaIndex);
        // Recalculate total usage
        _installedApps[appIndex] = _installedApps[appIndex].copyWith(
          totalCpuUsage: _installedApps[appIndex].replicas.fold(
            0.0,
            (sum, r) => sum! + r.cpuUsage,
          ),
          totalRamUsage: _installedApps[appIndex].replicas.fold(
            0.0,
            (sum, r) => sum! + r.ramUsage,
          ),
        );
        notifyListeners();
      } else if (replicaIndex != -1) {
        if (kDebugMode) {
          print("Cannot remove the last replica.");
        }
      }
    }
  }

  // Add methods to fetch/refresh data
  Future<void> fetchInstalledApps() async {
    await Future.delayed(const Duration(seconds: 1));
    if (kDebugMode) {
      print("Installed apps refreshed (mock)");
    }
    // Update _installedApps from API
    notifyListeners();
  }
}

// Helper extension for finding index
extension FindIndex<T> on List<T> {
  int findIndex(bool Function(T element) test) {
    for (int i = 0; i < length; i++) {
      if (test(this[i])) {
        return i;
      }
    }
    return -1;
  }
}

// Add copyWith to Application model for easier updates
extension ApplicationCopyWith on Application {
  Application copyWith({
    String? id,
    String? name,
    String? description,
    String? version,
    double? totalCpuUsage,
    double? totalRamUsage,
    List<ReplicaInfo>? replicas,
  }) {
    return Application(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      version: version ?? this.version,
      totalCpuUsage: totalCpuUsage ?? this.totalCpuUsage,
      totalRamUsage: totalRamUsage ?? this.totalRamUsage,
      replicas: replicas ?? this.replicas,
    );
  }
}
