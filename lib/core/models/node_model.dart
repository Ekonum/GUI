class Node {
  final String id;
  final String name;
  final double cpuUsage; // 0.0 to 1.0
  final double ramUsage; // 0.0 to 1.0
  final int appsRunningCount;

  Node({
    required this.id,
    required this.name,
    required this.cpuUsage,
    required this.ramUsage,
    required this.appsRunningCount,
  });
}
