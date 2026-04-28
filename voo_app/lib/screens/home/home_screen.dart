import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../mock/mock_users.dart';
import '../../models/request_model.dart';
import '../../models/user_model.dart';
import '../../state/app_state.dart';
import '../../widgets/sent_request_dialog.dart';
import '../../widgets/user_interaction_dialog.dart';
import '../../widgets/voo_bottom_nav_bar.dart';
import '../chats/chats_screen.dart';
import 'profile_qr_screen.dart';
import '../retos/retos_screen.dart';
import '../ranking/ranking_screen.dart';
import '../settings/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _seededDemo = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<AppState>().cargarUsuariosSala();
      }
    });
  }

  String _requestTypeLabel(RequestType type) {
    switch (type) {
      case RequestType.truth:
        return 'Verdad';
      case RequestType.dare:
        return 'Reto';
      case RequestType.messageRequest:
        return 'Mensaje';
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    if (!_seededDemo) {
      _seededDemo = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        context.read<AppState>().seedDemoIncomingRequestIfNeeded();
      });
    }

    final bool isHost = appState.isHost;
    final String nombrePerfil = appState.userName ?? 'Usuario';
    final String codigoSala = appState.roomCode ?? '---';
    final String tituloLista =
        isHost ? 'Tus invitados' : 'Invitados de la sala';

    final visibleUsers = appState.salaUsuarios
        .where((user) => !appState.shouldHideUserFromHome(user.id))
        .toList();

    final RequestModel? blockingIncoming = appState.blockingIncomingRequest;
    final RequestModel? activeAccepted = appState.activeAcceptedRequest;

    final bool lockHome =
        blockingIncoming != null || activeAccepted != null;

    void openPlaceholder(String text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(text)),
      );
    }

    Future<void> openInteractionPopup(UserModel user) async {
      if (lockHome) return;

      final existingPending = appState.getPendingRequestForUser(user.id);
      if (existingPending != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Ya tienes una solicitud pendiente con ${user.name}',
            ),
          ),
        );
        return;
      }

      final DialogRequestResult? result =
          await showDialog<DialogRequestResult>(
        context: context,
        barrierDismissible: true,
        builder: (_) => UserInteractionDialog(
          targetUserId: user.id,
          targetUserName: user.name,
          targetUserAge: user.age,
          statusColor: user.statusColor,
        ),
      );

      if (result == null || !context.mounted) return;

      appState.sendRequest(
        targetUserId: result.targetUserId,
        targetUserName: result.targetUserName,
        type: result.type,
        content: result.content,
        statusColor: user.statusColor,
      );

      final dialogData = switch (result.type) {
        RequestType.truth => (
            'Verdad enviada',
            'Tu solicitud de verdad se ha enviado a ${result.targetUserName}',
          ),
        RequestType.dare => (
            'Reto enviado',
            'Tu solicitud de reto se ha enviado a ${result.targetUserName}',
          ),
        RequestType.messageRequest => (
            'Mensaje enviado',
            'Tu solicitud de mensaje se ha enviado a ${result.targetUserName}',
          ),
      };

      await showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (_) => SentRequestDialog(
          title: dialogData.$1,
          subtitle: dialogData.$2,
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF05051C),
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.25,
            colors: [
              Color(0xFF171128),
              Color(0xFF0C0A18),
              Color(0xFF05051C),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              IgnorePointer(
                ignoring: lockHome,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _TopHeader(
                        saludo: 'Hola $nombrePerfil!',
                        codigoSala: codigoSala,
                        onQrTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProfileQrScreen(
                                isHost: isHost,
                                userName: nombrePerfil,
                                roomCode: codigoSala,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'Tus chats',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Expanded(
                        child: visibleUsers.isEmpty
                            ? Center(
                                child: Text(
                                  'No hay más invitados disponibles ahora mismo',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.60),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              )
                            : ListView.separated(
                                physics: lockHome
                                    ? const NeverScrollableScrollPhysics()
                                    : const BouncingScrollPhysics(),
                                itemCount: visibleUsers.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 12),
                                itemBuilder: (context, index) {
                                  final user = visibleUsers[index];
                                  final pendingRequest =
                                      appState.getPendingRequestForUser(user.id);

                                  return _GuestCard(
                                    name: user.nombre,
                                    age: user.edad,
                                    statusColor: user.statusColor,
                                    pendingLabel: pendingRequest == null
                                        ? null
                                        : '${_requestTypeLabel(pendingRequest.type)} pendiente',
                                    onTap: () => openInteractionPopup(
                                      UserModel(
                                        id: user.id,
                                        name: user.nombre,
                                        age: user.edad,
                                        statusColor: user.statusColor,
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                      const SizedBox(height: 10),
                      VooBottomNavBar(
                        currentIndex: 0,
                        onTap: (index) {
                          if (lockHome) return;

                          if (index == 0) {
                            return;
                          } else if (index == 1) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ChatsScreen(),
                              ),
                            );
                          } else if (index == 2) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const RankingScreen(),
                              ),
                            );
                          } else if (index == 3) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const RetosScreen(),
                              ),
                            );
                          } else if (index == 4) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SettingsScreen(
                                  isHost: isHost,
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              if (lockHome)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.45),
                  ),
                ),
              if (blockingIncoming != null)
                Center(
                  child: _IncomingRequestPopup(
                    request: blockingIncoming,
                    onReject: () {
                      context
                          .read<AppState>()
                          .rejectIncomingRequest(blockingIncoming.id);
                    },
                    onAccept: () {
                      context
                          .read<AppState>()
                          .acceptIncomingRequest(blockingIncoming.id);
                    },
                  ),
                ),
              if (activeAccepted != null)
                Center(
                  child: _AcceptedRequestResponsePopup(
                    request: activeAccepted,
                    onBack: () {
                      context.read<AppState>().restoreAcceptedRequestToPending();
                    },
                    onSendResponse: (responseText) async {
                      context
                          .read<AppState>()
                          .finishAcceptedRequestResponse(responseText);

                      if (!mounted) return;

                      await showDialog<void>(
                        context: context,
                        barrierDismissible: true,
                        builder: (_) => const SentRequestDialog(
                          title: 'Respuesta enviada',
                          subtitle:
                              'La conversación ya está en el apartado de chats.',
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IncomingRequestPopup extends StatelessWidget {
  final RequestModel request;
  final VoidCallback onReject;
  final VoidCallback onAccept;

  const _IncomingRequestPopup({
    required this.request,
    required this.onReject,
    required this.onAccept,
  });

  String _title() {
    switch (request.type) {
      case RequestType.truth:
        return '${request.targetUserName} te ha invitado a jugar verdad o reto';
      case RequestType.dare:
        return '${request.targetUserName} te ha invitado a jugar verdad o reto';
      case RequestType.messageRequest:
        return '${request.targetUserName} quiere hablar contigo';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 300,
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF171727),
              Color(0xFF10101A),
            ],
          ),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: const Color(0xFF9C4DFF),
            width: 2.4,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF8B3DFF).withOpacity(0.22),
              blurRadius: 24,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _title(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                height: 1.25,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF18183A),
                    Color(0xFF101028),
                  ],
                ),
                border: Border.all(
                  color: const Color(0xFF22C55E),
                  width: 4,
                ),
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 72,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Acepta o rechaza antes de seguir viendo los invitados.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.72),
                fontSize: 13,
                height: 1.35,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _DecisionButton(
                  color: const Color(0xFFFF3B5C),
                  icon: Icons.close_rounded,
                  onTap: onReject,
                ),
                _DecisionButton(
                  color: const Color(0xFF66D63E),
                  icon: Icons.check_rounded,
                  onTap: onAccept,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AcceptedRequestResponsePopup extends StatefulWidget {
  final RequestModel request;
  final VoidCallback onBack;
  final ValueChanged<String> onSendResponse;

  const _AcceptedRequestResponsePopup({
    required this.request,
    required this.onBack,
    required this.onSendResponse,
  });

  @override
  State<_AcceptedRequestResponsePopup> createState() =>
      _AcceptedRequestResponsePopupState();
}

class _AcceptedRequestResponsePopupState
    extends State<_AcceptedRequestResponsePopup> {
  final TextEditingController _responseController = TextEditingController();

  @override
  void dispose() {
    _responseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool canSend = _responseController.text.trim().isNotEmpty;

    return Material(
      color: Colors.transparent,
      child: Container(
        width: 300,
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF171727),
              Color(0xFF10101A),
            ],
          ),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: const Color(0xFF9C4DFF),
            width: 2.4,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF8B3DFF).withOpacity(0.22),
              blurRadius: 24,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: widget.onBack,
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF1B2C4B),
                    border: Border.all(
                      color: const Color(0xFF52A9FF),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.arrow_back_rounded,
                    color: Color(0xFF52A9FF),
                    size: 22,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${widget.request.targetUserName}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF22C55E),
                  width: 3,
                ),
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF181818),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: const Color(0xFFEAB308),
                  width: 2,
                ),
              ),
              child: Text(
                widget.request.content,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFFEAB308),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  height: 1.25,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF101018),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.18),
                  width: 1.3,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _responseController,
                      onChanged: (_) => setState(() {}),
                      onSubmitted: (_) {
                        if (canSend) {
                          widget.onSendResponse(
                            _responseController.text.trim(),
                          );
                        }
                      },
                      textInputAction: TextInputAction.send,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Responde a ${widget.request.targetUserName}',
                        hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.35),
                        ),
                        isDense: true,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: canSend
                        ? () => widget.onSendResponse(
                              _responseController.text.trim(),
                            )
                        : null,
                    child: Icon(
                      Icons.send_rounded,
                      color: canSend
                          ? const Color(0xFF52A9FF)
                          : const Color(0xFF52A9FF).withOpacity(0.35),
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DecisionButton extends StatefulWidget {
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  const _DecisionButton({
    required this.color,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_DecisionButton> createState() => _DecisionButtonState();
}

class _DecisionButtonState extends State<_DecisionButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 76,
        height: 76,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.color,
          boxShadow: [
            BoxShadow(
              color: widget.color.withOpacity(_pressed ? 0.45 : 0.25),
              blurRadius: _pressed ? 18 : 12,
              spreadRadius: _pressed ? 1.5 : 0.5,
            ),
          ],
        ),
        child: Icon(
          widget.icon,
          color: Colors.white,
          size: 40,
        ),
      ),
    );
  }
}

class _TopHeader extends StatelessWidget {
  final String saludo;
  final String codigoSala;
  final VoidCallback onQrTap;

  const _TopHeader({
    required this.saludo,
    required this.codigoSala,
    required this.onQrTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                saludo,
                style: const TextStyle(
                  color: Color(0xFFD78BFF),
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                codigoSala,
                style: const TextStyle(
                  color: Color(0xFF52A9FF),
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        _QrButton(onTap: onQrTap),
      ],
    );
  }
}

class _QrButton extends StatefulWidget {
  final VoidCallback onTap;

  const _QrButton({required this.onTap});

  @override
  State<_QrButton> createState() => _QrButtonState();
}

class _QrButtonState extends State<_QrButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 54,
        height: 54,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF3B1452),
              Color(0xFF24103A),
            ],
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0xFF7E2BE8),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF8B3DFF).withOpacity(_pressed ? 0.45 : 0.18),
              blurRadius: _pressed ? 20 : 12,
              spreadRadius: _pressed ? 1.2 : 0.4,
            ),
          ],
        ),
        child: const Icon(
          Icons.qr_code_2_rounded,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}

class _GuestCard extends StatelessWidget {
  final String name;
  final int age;
  final Color statusColor;
  final String? pendingLabel;
  final VoidCallback onTap;

  const _GuestCard({
    required this.name,
    required this.age,
    required this.statusColor,
    required this.onTap,
    this.pendingLabel,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF151525),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFFD78BFF).withOpacity(0.5),
            width: 1.4,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: statusColor,
                  width: 2.4,
                ),
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$name, $age',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (pendingLabel != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      pendingLabel!,
                      style: const TextStyle(
                        color: Color(0xFFEAB308),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Colors.white54,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}