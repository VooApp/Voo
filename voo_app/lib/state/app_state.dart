import 'package:flutter/material.dart';

import '../models/chat_model.dart';
import '../models/message_model.dart';
import '../models/request_model.dart';

class AppState extends ChangeNotifier {
  bool _isHost = false;
  String? _userName;
  String? _roomCode;

  final List<RequestModel> _sentRequests = [];
  final List<RequestModel> _receivedRequests = [];
  final List<ChatModel> _dynamicChats = [];
  final List<MessageModel> _messages = [];

  RequestModel? _activeAcceptedRequest;

  bool get isHost => _isHost;
  String? get userName => _userName;
  String? get roomCode => _roomCode;

  List<RequestModel> get sentRequests => List.unmodifiable(_sentRequests);
  List<RequestModel> get receivedRequests => List.unmodifiable(_receivedRequests);
  List<ChatModel> get dynamicChats => List.unmodifiable(_dynamicChats);
  List<MessageModel> get messages => List.unmodifiable(_messages);

  RequestModel? get activeAcceptedRequest => _activeAcceptedRequest;

  RequestModel? get blockingIncomingRequest {
    try {
      return _receivedRequests.firstWhere(
        (request) => request.status == RequestStatus.pending,
      );
    } catch (_) {
      return null;
    }
  }

  bool get hasBlockingIncomingRequest => blockingIncomingRequest != null;
  bool get isRespondingToAcceptedRequest => _activeAcceptedRequest != null;

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
    _receivedRequests.clear();
    _dynamicChats.clear();
    _messages.clear();
    _activeAcceptedRequest = null;
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

  bool shouldHideUserFromHome(String userId) {
    final hasPendingOutgoing = _sentRequests.any(
      (request) =>
          request.targetUserId == userId &&
          request.status == RequestStatus.pending,
    );

    final hasChat = _dynamicChats.any((chat) => chat.id == userId);

    return hasPendingOutgoing || hasChat;
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

  void addIncomingRequest({
    required String fromUserId,
    required String fromUserName,
    required RequestType type,
    required String content,
  }) {
    final alreadyExists = _receivedRequests.any(
      (request) =>
          request.targetUserId == fromUserId &&
          request.status == RequestStatus.pending,
    );

    if (alreadyExists) return;

    final request = RequestModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      targetUserId: fromUserId,
      targetUserName: fromUserName,
      type: type,
      content: content,
      status: RequestStatus.pending,
      createdAt: DateTime.now(),
    );

    _receivedRequests.insert(0, request);
    notifyListeners();
  }

  void rejectIncomingRequest(String requestId) {
    final index = _receivedRequests.indexWhere((r) => r.id == requestId);
    if (index == -1) return;

    _receivedRequests.removeAt(index);
    notifyListeners();
  }

  void acceptIncomingRequest(String requestId) {
    final index = _receivedRequests.indexWhere((r) => r.id == requestId);
    if (index == -1) return;

    final request = _receivedRequests[index].copyWith(
      status: RequestStatus.accepted,
    );

    _receivedRequests.removeAt(index);
    _activeAcceptedRequest = request;
    notifyListeners();
  }

  void restoreAcceptedRequestToPending() {
    final request = _activeAcceptedRequest;
    if (request == null) return;

    _receivedRequests.insert(
      0,
      request.copyWith(status: RequestStatus.pending),
    );
    _activeAcceptedRequest = null;
    notifyListeners();
  }

  void finishAcceptedRequestResponse(String responseText) {
    final request = _activeAcceptedRequest;
    if (request == null) return;

    final existingIndex = _dynamicChats.indexWhere(
      (chat) => chat.id == request.targetUserId,
    );

    final chat = ChatModel(
      id: request.targetUserId,
      userName: request.targetUserName,
      lastMessage: responseText,
      time: _formatNow(),
      unreadCount: 0,
      statusColor: _statusColorFromType(request.type),
    );

    if (existingIndex == -1) {
      _dynamicChats.insert(0, chat);
    } else {
      _dynamicChats.removeAt(existingIndex);
      _dynamicChats.insert(0, chat);
    }

    final initialIncomingMessage = MessageModel(
      id: '${request.targetUserId}_incoming_${DateTime.now().microsecondsSinceEpoch}',
      chatId: request.targetUserId,
      text: request.content,
      isMine: false,
      time: _formatNow(),
    );

    final initialResponseMessage = MessageModel(
      id: '${request.targetUserId}_mine_${DateTime.now().microsecondsSinceEpoch + 1}',
      chatId: request.targetUserId,
      text: responseText,
      isMine: true,
      time: _formatNow(),
    );

    final alreadyHasMessages =
        _messages.any((message) => message.chatId == request.targetUserId);

    if (!alreadyHasMessages) {
      _messages.add(initialIncomingMessage);
      _messages.add(initialResponseMessage);
    }

    _activeAcceptedRequest = null;
    notifyListeners();
  }

  List<MessageModel> getMessagesForChat(String chatId) {
    return _messages.where((message) => message.chatId == chatId).toList();
  }

  void sendChatMessage({
    required String chatId,
    required String text,
    required bool isMine,
  }) {
    final message = MessageModel(
      id: '${chatId}_${DateTime.now().microsecondsSinceEpoch}',
      chatId: chatId,
      text: text,
      isMine: isMine,
      time: _formatNow(),
    );

    _messages.add(message);

    final chatIndex = _dynamicChats.indexWhere((chat) => chat.id == chatId);
    if (chatIndex != -1) {
      final oldChat = _dynamicChats[chatIndex];
      final updatedChat = ChatModel(
        id: oldChat.id,
        userName: oldChat.userName,
        lastMessage: text,
        time: message.time,
        unreadCount: isMine ? 0 : oldChat.unreadCount + 1,
        statusColor: oldChat.statusColor,
      );

      _dynamicChats.removeAt(chatIndex);
      _dynamicChats.insert(0, updatedChat);
    }

    notifyListeners();
  }

  List<ChatModel> buildChatsList(List<ChatModel> mockChats) {
    final pendingOutgoingIds = _sentRequests
        .where((request) => request.status == RequestStatus.pending)
        .map((request) => request.targetUserId)
        .toSet();

    final pendingChatPlaceholders = _sentRequests
        .where((request) =>
            request.status == RequestStatus.pending &&
            !_dynamicChats.any((chat) => chat.id == request.targetUserId))
        .map(
          (request) => ChatModel(
            id: request.targetUserId,
            userName: request.targetUserName,
            lastMessage:
                '${request.targetUserName} está en una misión ahora mismo ¡intenta con otro!',
            time: _formatNow(),
            unreadCount: 0,
            statusColor: _statusColorFromType(request.type),
          ),
        )
        .toList();

    return [
      ..._dynamicChats,
      ...pendingChatPlaceholders,
      ...mockChats.where(
        (mock) =>
            !_dynamicChats.any((c) => c.id == mock.id) &&
            !pendingOutgoingIds.contains(mock.id),
      ),
    ];
  }

  bool isPendingOutgoingChat(String chatId) {
    return _sentRequests.any(
      (request) =>
          request.targetUserId == chatId &&
          request.status == RequestStatus.pending,
    );
  }

  void seedDemoIncomingRequestIfNeeded() {
    if (_receivedRequests.isNotEmpty || _activeAcceptedRequest != null) return;

    addIncomingRequest(
      fromUserId: 'demo_maria',
      fromUserName: 'Maria',
      type: RequestType.truth,
      content: '¿Qué pensaste al ver mi foto?',
    );
  }

  Color _statusColorFromType(RequestType type) {
    switch (type) {
      case RequestType.truth:
        return const Color(0xFF22C55E);
      case RequestType.dare:
        return const Color(0xFFEF4444);
      case RequestType.messageRequest:
        return const Color(0xFF52A9FF);
    }
  }

  String _formatNow() {
    final now = DateTime.now();
    final h = now.hour.toString().padLeft(2, '0');
    final m = now.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}