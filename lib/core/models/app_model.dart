import 'package:ekonum_app/core/models/replica_info.dart';

class Application {
  final String id;
  final String name;
  final String description;
  final String version;
  final double totalCpuUsage; // Across all replicas
  final double totalRamUsage; // Across all replicas
  final List<ReplicaInfo> replicas;

  Application({
    required this.id,
    required this.name,
    required this.description,
    required this.version,
    required this.totalCpuUsage,
    required this.totalRamUsage,
    required this.replicas,
  });
}
