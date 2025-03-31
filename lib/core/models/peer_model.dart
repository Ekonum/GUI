class Peer {
  final String id;
  final String name;
  final String lastSync;
  final double storageUsedPercent;
  bool isSelected; // Mutable state for UI

  Peer({
    required this.id,
    required this.name,
    required this.lastSync,
    required this.storageUsedPercent,
    this.isSelected = false,
  });
}
