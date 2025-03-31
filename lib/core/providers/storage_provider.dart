import 'package:ekonum_app/core/models/peer_model.dart';
import 'package:ekonum_app/core/models/storage_plan.dart';
import 'package:flutter/foundation.dart';

class StorageProvider with ChangeNotifier {
  // --- Mock Data ---
  final StoragePlan _storagePlan = StoragePlan(
    backupCopies: 1,
    totalStorageGB: 500,
    allocationPercent: 0.5, // 50% for 1 copy
  );

  final List<Peer> _availablePeers = [
    Peer(
      id: 'peer-alice',
      name: "Alice's Cloud",
      lastSync: '2 minutes ago',
      storageUsedPercent: 0.42,
      isSelected: false,
    ),
    Peer(
      id: 'peer-bob',
      name: "Bob's Network",
      lastSync: '5 minutes ago',
      storageUsedPercent: 0.28,
      isSelected: false,
    ),
    Peer(
      id: 'peer-charlie',
      name: "Charlie's Hub",
      lastSync: '1 minute ago',
      storageUsedPercent: 0.15,
      isSelected: true,
    ), // Example selected
    Peer(
      id: 'peer-diana',
      name: "Diana's Cloud",
      lastSync: '3 hours ago',
      storageUsedPercent: 0.35,
      isSelected: false,
    ),
    Peer(
      id: 'peer-eve',
      name: "Eve's Storage",
      lastSync: '1 day ago',
      storageUsedPercent: 0.70,
      isSelected: false,
    ),
  ];

  PeerSelectionMode _peerSelectionMode = PeerSelectionMode.specific; // Default
  String _peerSearchQuery = '';
  DateTime? _lastBackupTime; // Example: Null initially
  double _backupCompletion = 0.87; // 87%
  bool _isSyncing = false;

  // --- End Mock Data ---

  // --- Getters ---
  StoragePlan get storagePlan => _storagePlan;

  List<Peer> get availablePeers {
    // Filter based on search query
    if (_peerSearchQuery.isEmpty) {
      return List.unmodifiable(_availablePeers);
    }
    final query = _peerSearchQuery.toLowerCase();
    return List.unmodifiable(
      _availablePeers.where(
        (peer) =>
            peer.name.toLowerCase().contains(query) ||
            peer.id.toLowerCase().contains(query),
      ),
    );
  }

  List<Peer> get selectedPeers =>
      List.unmodifiable(_availablePeers.where((p) => p.isSelected));

  PeerSelectionMode get peerSelectionMode => _peerSelectionMode;

  String get peerSearchQuery => _peerSearchQuery;

  DateTime? get lastBackupTime => _lastBackupTime;

  double get backupCompletion => _backupCompletion;

  bool get isSyncing => _isSyncing;

  // --- Methods ---

  void updateSelectedCopies(int newCopies) {
    if (newCopies >= 0 && newCopies <= 3) {
      // Example max copies = 3
      _storagePlan.backupCopies = newCopies;
      // Update allocation based on copies (example logic)
      if (newCopies == 0) {
        _storagePlan.allocationPercent = 0.0;
      } else if (newCopies == 1) {
        _storagePlan.allocationPercent = 0.5; // 50% shared for 1 copy
      } else if (newCopies == 2) {
        _storagePlan.allocationPercent = 2 / 3; // ~66.7% shared for 2 copies
      } else {
        _storagePlan.allocationPercent = 0.75; // 75% shared for 3 copies
      }
      if (kDebugMode) {
        print(
          "Updated backup copies to: $newCopies, Allocation: ${_storagePlan.allocationPercent}",
        );
      }
      // TODO: Call API to save changes
      notifyListeners();
    }
  }

  void setPeerSelectionMode(PeerSelectionMode mode) {
    if (_peerSelectionMode != mode) {
      _peerSelectionMode = mode;
      if (kDebugMode) {
        print("Peer selection mode set to: $mode");
      }
      // Reset search when switching modes? Maybe not necessary.
      notifyListeners();
    }
  }

  void searchPeers(String query) {
    _peerSearchQuery = query;
    notifyListeners(); // Trigger list filtering
  }

  void togglePeerSelection(String peerId) {
    final peerIndex = _availablePeers.indexWhere((p) => p.id == peerId);
    if (peerIndex != -1) {
      _availablePeers[peerIndex].isSelected =
          !_availablePeers[peerIndex].isSelected;
      if (kDebugMode) {
        print(
          "Toggled selection for $peerId: ${_availablePeers[peerIndex].isSelected}",
        );
      }
      // TODO: Call API to update selected peers if needed, especially if not using smart selection
      notifyListeners();
    }
  }

  Future<void> syncNow() async {
    if (_isSyncing) return; // Prevent multiple syncs

    _isSyncing = true;
    notifyListeners();
    if (kDebugMode) {
      print("Starting manual sync...");
    }

    // Simulate sync process
    await Future.delayed(const Duration(seconds: 3));
    _lastBackupTime = DateTime.now();
    _backupCompletion = 1.0; // Assume sync completes fully for mock
    _isSyncing = false;
    if (kDebugMode) {
      print("Manual sync complete.");
    }

    notifyListeners();

    // Reset completion after a delay? Or wait for next auto-sync update
    await Future.delayed(const Duration(seconds: 10));
    if (!_isSyncing) {
      // Check if another sync hasn't started
      _backupCompletion = 0.87; // Reset to mock value
      notifyListeners();
    }
  }

  // Add methods to fetch/refresh data
  Future<void> fetchStorageData() async {
    await Future.delayed(const Duration(seconds: 1));
    if (kDebugMode) {
      print("Storage data refreshed (mock)");
    }
    // Update _storagePlan, _availablePeers, _lastBackupTime etc. from API
    _lastBackupTime ??= DateTime.now().subtract(
      const Duration(minutes: 5),
    ); // Set initial mock backup time if null
    notifyListeners();
  }
}

// Enum defined here or in a dedicated enums file
enum PeerSelectionMode { specific, smart }
