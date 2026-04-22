import 'package:flutter/material.dart';

import '../models/request_model.dart';

class AppState extends ChangeNotifier {
  bool _isHost = false;
  String? _userName;
  String? _roomCode;

  final List<RequestModel> _sentRequests = [];

  bool get isHost => _isHost;
  String? get userName => _userName;
  String? get roomCode => _roomCode;
  List<RequestModel> get sentRequests => List.unmodifiable(_sentRequests);

  void setUser({
    required bool isHost,
    required String userName,
    required String roomCode,
  }) {
    _isHost = isHost;
    _userName = userName;
    _roomCode = roomCode;
    notifyListeners();
  }

  void clear() {
    _isHost = false;
    _userName = null;
    _roomCode = null;
    _sentRequests.clear();
    notifyListeners();
  }

  void sendRequest({
    required String targetUserId,
    required String targetUserName,
    required RequestType type,
    required String content,
  }) {
    final hasPending = _sentRequests.any(
      (request) =>
          request.targetUserId == targetUserId &&
          request.status == RequestStatus.pending,
    );

    if (hasPending) return;

    final request = RequestModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      targetUserId: targetUserId,
      targetUserName: targetUserName,
      type: type,
      content: content,
      status: RequestStatus.pending,
      createdAt: DateTime.now(),
    );

    _sentRequests.insert(0, request);
    notifyListeners();
  }

  RequestModel? getPendingRequestForUser(String userId) {
    try {
      return _sentRequests.firstWhere(
        (request) =>
            request.targetUserId == userId &&
            request.status == RequestStatus.pending,
      );
    } catch (_) {
      return null;
    }
  }

  bool hasPendingRequestForUser(String userId) {
    return getPendingRequestForUser(userId) != null;
  }

  void updateRequestStatus({
    required String requestId,
    required RequestStatus status,
  }) {
    final index = _sentRequests.indexWhere((request) => request.id == requestId);
    if (index == -1) return;

    _sentRequests[index] = _sentRequests[index].copyWith(status: status);
    notifyListeners();
  }
}