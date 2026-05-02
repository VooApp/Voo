import 'package:flutter/material.dart';

import '../models/chat_model.dart';
import '../models/chat_preview_state.dart';
import '../models/message_model.dart';
import '../models/request_model.dart';

import '../services/api_service.dart';

class AppState extends ChangeNotifier {
  bool _isHost = false;
  String? _userName;
  String? _roomCode;

  String? _userId;
  String? _salaId;

  DateTime? _birthDate;
  String? _instagram;
  String? _profilePhoto;
  String? _estado;
  List<String> _respuestas = [];
  bool? _sexo;

  final List<RequestModel> _sentRequests = [];
  final List<RequestModel> _receivedRequests = [];
  final List<ChatModel> _dynamicChats = [];
  final List<MessageModel> _messages = [];

  List<SalaUsuarioModel> _salaUsuarios = [];
  bool _loadingUsuarios = false;
  String? _loadingError;

  List<SalaUsuarioModel> get salaUsuarios => List.unmodifiable(_salaUsuarios);
  bool get loadingUsuarios => _loadingUsuarios;
  String? get loadingError => _loadingError;

  RequestModel? _activeAcceptedRequest;

  bool get isHost => _isHost;
  String? get userName => _userName;
  bool? get sexo => _sexo;
  String? get roomCode => _roomCode;
  String? get userId => _userId;
  String? get salaId => _salaId;

  DateTime? get birthDate => _birthDate;
  String? get instagram => _instagram;
  String? get profilePhoto => _profilePhoto;
  String? get estado => _estado;
  List<String> get respuestas => List.unmodifiable(_respuestas);

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
    String? userId,
    String? salaId,
  }) {
    _isHost = isHost;
    _userName = userName;
    _roomCode = roomCode;
    _userId = userId ?? _userId;
    _salaId = salaId ?? _salaId;
    notifyListeners();
  }

  void clear() {
    _isHost = false;
    _userName = null;
    _sexo = null;
    _roomCode = null;
    _sentRequests.clear();
    _receivedRequests.clear();
    _dynamicChats.clear();
    _messages.clear();
    _activeAcceptedRequest = null;
    _userId = null;
    _salaId = null;
    _birthDate = null;
    _instagram = null;
    _profilePhoto = null;
    _estado = null;
    _respuestas = [];
    notifyListeners();
  }

  void sendRequest({
    required String targetUserId,
    required String targetUserName,
    required RequestType type,
    required String content,
    required Color statusColor,
  }) {
    final hasBlockingState = _sentRequests.any(
      (request) =>
          request.targetUserId == targetUserId &&
          (request.status == RequestStatus.pending ||
              request.status == RequestStatus.answered ||
              request.status == RequestStatus.rejected),
    );

    if (hasBlockingState) return;

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

    final alreadyInChats = _dynamicChats.any((chat) => chat.id == targetUserId);
    if (!alreadyInChats) {
      _dynamicChats.insert(
        0,
        ChatModel(
          id: targetUserId,
          userName: targetUserName,
          lastMessage:
              '$targetUserName está en una misión ahora mismo ¡intenta con otro!',
          time: _formatNow(),
          unreadCount: 0,
          statusColor: statusColor,
          previewState: ChatPreviewState.missionBusy,
        ),
      );
    }

    notifyListeners();
  }

  void setRegisterData({
    required String userName,
    required DateTime birthDate,
    required String profilePhoto,
    required bool sexo,
    String? instagram,
  }) {
    _userName = userName;
    _birthDate = birthDate;
    _profilePhoto = profilePhoto;
    _sexo = sexo;
    _instagram = instagram;
    notifyListeners();
  }

  void setStatusData(String estado) {
    _estado = estado;
    notifyListeners();
  }

  void setQuestionsData(List<String> respuestas) {
    _respuestas = respuestas;
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

  bool shouldHideUserFromHome(String userId) {
    final hasOutgoingState = _sentRequests.any(
      (request) =>
          request.targetUserId == userId &&
          (request.status == RequestStatus.pending ||
              request.status == RequestStatus.answered ||
              request.status == RequestStatus.rejected),
    );

    final hasChat = _dynamicChats.any((chat) => chat.id == userId);

    return hasOutgoingState || hasChat;
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

    final sentIndex = _sentRequests.indexWhere(
      (r) => r.targetUserId == request.targetUserId,
    );

    if (sentIndex != -1) {
      _sentRequests[sentIndex] = _sentRequests[sentIndex].copyWith(
        status: RequestStatus.accepted,
      );
    }

    final existingChatIndex = _dynamicChats.indexWhere(
      (chat) => chat.id == request.targetUserId,
    );

    final previousColor = existingChatIndex != -1
        ? _dynamicChats[existingChatIndex].statusColor
        : _statusColorFromType(request.type);

    final chat = ChatModel(
      id: request.targetUserId,
      userName: request.targetUserName,
      lastMessage: responseText,
      time: _formatNow(),
      unreadCount: 0,
      statusColor: previousColor,
      previewState: ChatPreviewState.normal,
    );

    if (existingChatIndex == -1) {
      _dynamicChats.insert(0, chat);
    } else {
      _dynamicChats.removeAt(existingChatIndex);
      _dynamicChats.insert(0, chat);
    }

    final alreadyHasMessages =
        _messages.any((message) => message.chatId == request.targetUserId);

    if (!alreadyHasMessages) {
      _messages.add(
        MessageModel(
          id: '${request.targetUserId}_incoming_${DateTime.now().microsecondsSinceEpoch}',
          chatId: request.targetUserId,
          text: request.content,
          isMine: false,
          time: _formatNow(),
        ),
      );

      _messages.add(
        MessageModel(
          id: '${request.targetUserId}_mine_${DateTime.now().microsecondsSinceEpoch + 1}',
          chatId: request.targetUserId,
          text: responseText,
          isMine: true,
          time: _formatNow(),
        ),
      );
    }

    _activeAcceptedRequest = null;
    notifyListeners();
  }

  void registerIncomingAnswer({
    required String chatId,
    required String answerText,
  }) {
    final chatIndex = _dynamicChats.indexWhere((chat) => chat.id == chatId);
    if (chatIndex == -1) return;

    final oldChat = _dynamicChats[chatIndex];

    _messages.add(
      MessageModel(
        id: '${chatId}_incoming_answer_${DateTime.now().microsecondsSinceEpoch}',
        chatId: chatId,
        text: answerText,
        isMine: false,
        time: _formatNow(),
      ),
    );

    _dynamicChats.removeAt(chatIndex);
    _dynamicChats.insert(
      0,
      oldChat.copyWith(
        lastMessage: answerText,
        time: _formatNow(),
        unreadCount: oldChat.unreadCount + 1,
        previewState: ChatPreviewState.answeredRequest,
      ),
    );

    notifyListeners();
  }

  void markAnsweredRequestAsSeen(String chatId) {
    final chatIndex = _dynamicChats.indexWhere((chat) => chat.id == chatId);
    if (chatIndex != -1) {
      final oldChat = _dynamicChats[chatIndex];
      _dynamicChats[chatIndex] = oldChat.copyWith(
        previewState: ChatPreviewState.normal,
        unreadCount: 0,
      );
    }

    notifyListeners();
  }

  void rejectOutgoingRequestSilently(String targetUserId) {
    final sentIndex = _sentRequests.indexWhere(
      (request) =>
          request.targetUserId == targetUserId &&
          (request.status == RequestStatus.pending ||
              request.status == RequestStatus.answered),
    );

    if (sentIndex != -1) {
      _sentRequests[sentIndex] = _sentRequests[sentIndex].copyWith(
        status: RequestStatus.rejected,
      );
    }

    final chatIndex = _dynamicChats.indexWhere((chat) => chat.id == targetUserId);
    if (chatIndex != -1) {
      final oldChat = _dynamicChats[chatIndex];
      _dynamicChats[chatIndex] = oldChat.copyWith(
        lastMessage:
            '${oldChat.userName} está en una misión ahora mismo ¡intenta con otro!',
        previewState: ChatPreviewState.missionBusy,
        unreadCount: 0,
      );
    }

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
      final updatedChat = oldChat.copyWith(
        lastMessage: text,
        time: message.time,
        unreadCount: isMine ? 0 : oldChat.unreadCount + 1,
        previewState: isMine ? ChatPreviewState.normal : oldChat.previewState,
      );

      _dynamicChats.removeAt(chatIndex);
      _dynamicChats.insert(0, updatedChat);
    }

    notifyListeners();
  }

  List<ChatModel> buildChatsList(List<ChatModel> mockChats) {
    return [
      ..._dynamicChats,
      ...mockChats.where(
        (mock) => !_dynamicChats.any((c) => c.id == mock.id),
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

  Future<void> cargarUsuariosSala() async {
    final id = _salaId;
    if (id == null) return;

    _loadingUsuarios = true;
    _loadingError = null;
    notifyListeners();

    try {
      final usuarios = await ApiService.getUsuariosSala(id);
      _salaUsuarios = usuarios
          .where((u) => u.id != _userId) //  "&& !u.baneado" en caso de que no se quieran ver los baneados
          .toList();
    } catch (e) {
      _loadingError = e.toString();
    } finally {
      _loadingUsuarios = false;
      notifyListeners();
    }
  }

  Future<void> banearUsuario(String usuarioId) async {
    await ApiService.banearUsuario(usuarioId);
    await cargarUsuariosSala();
  }

  Future<void> salirDeSala() async {
    final id = _userId;
    if (id != null) await ApiService.salirDeSala(id);
    clear();
  }

  Future<void> cerrarSala() async {
    final id = _salaId;
    if (id != null) await ApiService.cerrarSala(id);
    clear();
  }

  List<String> get premios => []; // ampliar cuando el backend devuelva premios
  int get matchCount => _dynamicChats.where((c) => c.previewState == ChatPreviewState.normal).length;
  int get baneadosCount => _salaUsuarios.where((u) => u.baneado).length;
  String? get nivelId => _estado != null ? _calcularNivel() : null;

  String _calcularNivel() {
    return 'Ninguno';
  }
}