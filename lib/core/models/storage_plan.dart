class StoragePlan {
  int backupCopies;
  double totalStorageGB;
  double allocationPercent; // 0.0 to 1.0 shared

  StoragePlan({
    required this.backupCopies,
    required this.totalStorageGB,
    required this.allocationPercent,
  });

  double get dedicatedToPeersGB => totalStorageGB * allocationPercent;

  double get usableStorageGB => totalStorageGB - dedicatedToPeersGB;
}
