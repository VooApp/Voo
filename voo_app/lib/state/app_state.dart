import 'package:flutter/material.dart';

import '../models/chat_model.dart';
import '../models/chat_preview_state.dart';
import '../models/message_model.dart';
import '../models/request_model.dart';

import '../services/api_service.dart';
import 'package:signalr_netcore/signalr_client.dart';

class AppState extends ChangeNotifier {
  bool _isHost = false;
  String? _userName;
  String? _roomCode;

  String? _userId;
  String? _salaId;
  HubConnection? _hubConnection;

  DateTime? _birthDate;
  String? _instagram;
  String? _profilePhoto;
  String? _estado;
  List<String> _respuestas = [];
  bool? _sexo;

  // ✅ Términos y condiciones
  bool _aceptaTerminos = false;

  bool get aceptaTerminos => _aceptaTerminos;
  bool get aceptaPrivacidad => _aceptaTerminos;
  bool get aceptaBiometria => _aceptaTerminos;

  final List<RequestModel> _sentRequests = [];
  final List<RequestModel> _receivedRequests = [];
  final List<ChatModel> _dynamicChats = [];
  final List<MessageModel> _messages = [];
  bool _loadingChats = false;
  String? _activeChatId;
  bool get loadingChats => _loadingChats;

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

  double? _latitudGuest;
  double? _longitudGuest;
  double? get latitudGuest => _latitudGuest;
  double? get longitudGuest => _longitudGuest;

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
    _aceptaTerminos = false;
    _latitudGuest = null;
    _longitudGuest = null;
    notifyListeners();
  }

  void setActiveChat(String? chatId) {
    _activeChatId = chatId;

    if (chatId != null) {
      marcarChatComoLeidoLocal(chatId);
    }
  }

  void marcarChatComoLeidoLocal(String chatId) {
    final index = _dynamicChats.indexWhere((chat) => chat.id == chatId);
    if (index == -1) return;

    final oldChat = _dynamicChats[index];

    _dynamicChats[index] = oldChat.copyWith(
      unreadCount: 0,
      previewState: ChatPreviewState.normal,
    );

    notifyListeners();
  }

  Future<void> sendRequest({
    required String targetUserId,
    required String targetUserName,
    required RequestType type,
    required String content,
    required Color statusColor,
  }) async {
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
          otherUserId: targetUserId,
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

    await _hubConnection?.invoke(
      'EnviarSolicitud',
      args: [
        _userId ?? '',
        _userName ?? '',
        targetUserId,
        _requestTypeToString(type),
        content,
      ],
    );
  }

  RequestType _requestTypeFromString(String value) {
    switch (value) {
      case 'truth':
        return RequestType.truth;
      case 'dare':
        return RequestType.dare;
      case 'messageRequest':
        return RequestType.messageRequest;
      default:
        return RequestType.messageRequest;
    }
  }

  String _requestTypeToString(RequestType type) {
    switch (type) {
      case RequestType.truth:
        return 'truth';
      case RequestType.dare:
        return 'dare';
      case RequestType.messageRequest:
        return 'messageRequest';
    }
  }

  void setRegisterData({
    required String userName,
    required DateTime birthDate,
    required String profilePhoto,
    required bool sexo,
    required bool aceptaTerminos,
    String? instagram,
  }) {
    _userName = userName;
    _birthDate = birthDate;
    _profilePhoto = profilePhoto;
    _sexo = sexo;
    _instagram = instagram;
    _aceptaTerminos = aceptaTerminos;
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

  Future<void> acceptIncomingRequest(String requestId) async {
    final index = _receivedRequests.indexWhere((r) => r.id == requestId);
    if (index == -1) return;

    final request = _receivedRequests[index].copyWith(
      status: RequestStatus.accepted,
    );

    _receivedRequests.removeAt(index);
    _activeAcceptedRequest = request;
    notifyListeners();

    final myId = _userId;
    if (myId == null || myId.isEmpty) return;

    await ApiService.crearOObtenerChat(
      usuarioAId: myId,
      usuarioBId: request.targetUserId,
    );

    await cargarChats();
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

  Future<void> finishAcceptedRequestResponse(String responseText) async {
    final request = _activeAcceptedRequest;
    if (request == null) return;
    final myId = _userId;
    if (myId == null || myId.isEmpty) return;

    final chatId = await ApiService.crearOObtenerChat(
      usuarioAId: myId,
      usuarioBId: request.targetUserId,
    );

    await sendChatMessage(
      chatId: chatId,
      targetUserId: request.targetUserId,
      text: responseText,
      isMine: true,
    );

    _activeAcceptedRequest = null;
    notifyListeners();
    return;

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
      otherUserId: request.targetUserId,
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
          id:
              '${request.targetUserId}_incoming_${DateTime.now().microsecondsSinceEpoch}',
          chatId: request.targetUserId,
          text: request.content,
          isMine: false,
          time: _formatNow(),
        ),
      );

      _messages.add(
        MessageModel(
          id:
              '${request.targetUserId}_mine_${DateTime.now().microsecondsSinceEpoch + 1}',
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

  Future<void> cargarMensajesChat(String chatId) async {
    final id = _userId;
    if (id == null || id.isEmpty) return;

    final mensajes = await ApiService.getMensajesChat(
      chatId: chatId,
      usuarioId: id,
    );

    _messages.removeWhere((m) => m.chatId == chatId);
    _messages.addAll(mensajes);

    notifyListeners();
  }

  Future<void> sendChatMessage({
    required String chatId,
    required String targetUserId,
    required String text,
    required bool isMine,
  }) async {
    final myId = _userId;
    if (myId == null || myId.isEmpty) return;

    final tempTime = _formatNow();

    final tempMessage = MessageModel(
      id: '${chatId}_local_${DateTime.now().microsecondsSinceEpoch}',
      chatId: chatId,
      text: text,
      isMine: true,
      time: tempTime,
    );

    _messages.add(tempMessage);

    final chatIndex = _dynamicChats.indexWhere((chat) => chat.id == chatId);
    if (chatIndex != -1) {
      final oldChat = _dynamicChats[chatIndex];

      _dynamicChats.removeAt(chatIndex);
      _dynamicChats.insert(
        0,
        oldChat.copyWith(
          lastMessage: text,
          time: tempTime,
          unreadCount: 0,
          previewState: ChatPreviewState.normal,
        ),
      );
    }

    notifyListeners();

    try {
      await ApiService.enviarMensajeChat(
        chatId: chatId,
        emisorId: myId,
        receptorId: targetUserId,
        contenido: text,
      );

      await _hubConnection?.invoke(
        'EnviarMensajeChat',
        args: [
          chatId,
          myId,
          targetUserId,
          text,
          tempTime,
        ],
      );
    } catch (e) {
      debugPrint('Error enviando mensaje: $e');
    }
  }

  List<ChatModel> buildChatsList(List<ChatModel> mockChats) {
    return List.unmodifiable(_dynamicChats);
  }

  Future<void> cargarChats() async {
    final id = _userId;
    if (id == null || id.isEmpty) return;

    _loadingChats = true;
    notifyListeners();

    try {
      final chats = await ApiService.getChatsUsuario(id);

      _dynamicChats
        ..clear()
        ..addAll(chats);
    } finally {
      _loadingChats = false;
      notifyListeners();
    }
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
          .where((u) => u.id != _userId)
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

  List<String> get premios => [];

  int get matchCount =>
      _dynamicChats.where((c) => c.previewState == ChatPreviewState.normal).length;

  int get baneadosCount => _salaUsuarios.where((u) => u.baneado).length;

  String? get nivelId => _estado != null ? calcularNivel() : null;

  String calcularNivel() {
    return 'Ninguno';
  }

  Future<void> iniciarSignalR() async {
    if (_hubConnection?.state == HubConnectionState.Connected) return;

    final currentUserId = _userId;
    final currentSalaId = _salaId;

    if (currentUserId == null || currentUserId.isEmpty) return;
    if (currentSalaId == null || currentSalaId.isEmpty) return;

    final hubUrl = '${ApiService.baseUrl}/hubs/sala';

    _hubConnection = HubConnectionBuilder()
        .withUrl(hubUrl)
        .withAutomaticReconnect()
        .build();

    _hubConnection!.on('SolicitudRecibida', (arguments) {
      if (arguments == null || arguments.isEmpty) return;

      final data = arguments.first as Map<Object?, Object?>;

      final fromUserId = data['fromUserId']?.toString() ?? '';
      final fromUserName = data['fromUserName']?.toString() ?? '';
      final typeText = data['type']?.toString() ?? '';
      final content = data['content']?.toString() ?? '';

      final type = _requestTypeFromString(typeText);

      if (fromUserId.isEmpty || fromUserName.isEmpty || content.isEmpty) return;

      addIncomingRequest(
        fromUserId: fromUserId,
        fromUserName: fromUserName,
        type: type,
        content: content,
      );
    });

    _hubConnection!.on('UsuarioEntrado', (arguments) {
      cargarUsuariosSala();
    });

    _hubConnection!.on('MensajeChatRecibido', (arguments) {
      if (arguments == null || arguments.isEmpty) return;

      final data = arguments.first as Map<Object?, Object?>;

      final chatId = data['chatId']?.toString() ?? '';
      final fromUserId = data['fromUserId']?.toString() ?? '';
      final content = data['content']?.toString() ?? '';
      final time = data['time']?.toString() ?? _formatNow();

      if (chatId.isEmpty || fromUserId.isEmpty || content.isEmpty) return;

      // Evita duplicar tus propios mensajes
      if (fromUserId == _userId) return;

      final message = MessageModel(
        id: '${chatId}_${DateTime.now().microsecondsSinceEpoch}',
        chatId: chatId,
        text: content,
        isMine: false,
        time: time,
      );

      _messages.add(message);

      final chatIndex = _dynamicChats.indexWhere((chat) => chat.id == chatId);

      if (chatIndex != -1) {
        final oldChat = _dynamicChats[chatIndex];

        _dynamicChats.removeAt(chatIndex);
        _dynamicChats.insert(
          0,
          oldChat.copyWith(
            lastMessage: content,
            time: time,
            unreadCount: _activeChatId == chatId ? 0 : oldChat.unreadCount + 1,
            previewState: ChatPreviewState.normal,
          ),
        );
      } else {
        cargarChats();
      }

      notifyListeners();
    });

    await _hubConnection!.start();

    await _hubConnection!.invoke(
      'JoinSala',
      args: [currentSalaId],
    );

    await _hubConnection!.invoke(
      'JoinUsuario',
      args: [currentUserId],
    );
  }

  void setGuestJoinData({
    required String roomCode,
    required double latitud,
    required double longitud,
    required double accuracy,
  }) {
    _roomCode = roomCode;
    _latitudGuest = latitud;
    _longitudGuest = longitud;
    notifyListeners();
  }

  Future<void> registrarInvitadoEnBackend() async {
    debugPrint('nombre: $_userName');
    debugPrint('estado: $_estado');
    
    try {
      final response = await ApiService.registrarInvitado(
        nombre: _userName ?? '',
        sexo: _sexo ?? true,
        fechaNacimiento: _birthDate ?? DateTime.now(),
        foto: _profilePhoto ?? '',
        instagram: _instagram,
        estado: _estado ?? 'verde',
        respuestas: _respuestas,
        codigoSala: _roomCode ?? '',
        latitud: _latitudGuest ?? 0.0,
        longitud: _longitudGuest ?? 0.0,
        accuracy: 0.0,

        // ✅ Enviamos al backend lo que exige el RegistroService
        aceptaTerminos: _aceptaTerminos,
        aceptaPrivacidad: _aceptaTerminos,
        aceptaBiometria: _aceptaTerminos,
      );

      _userId = response.usuarioId;
      _salaId = response.salaId;
      _userName = response.nombreUsuario;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  void setIsHost(bool value) {
    _isHost = value;
    notifyListeners();
  }
}