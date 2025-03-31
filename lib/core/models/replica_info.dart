class ReplicaInfo {
  final String replicaId; // e.g., "Copy 1"
  final String nodeId;
  final String nodeName;
  final double cpuUsage; // Usage on this node
  final double ramUsage; // Usage on this node

  ReplicaInfo({
    required this.replicaId,
    required this.nodeId,
    required this.nodeName,
    required this.cpuUsage,
    required this.ramUsage,
  });
}
