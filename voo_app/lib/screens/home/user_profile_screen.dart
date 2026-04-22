import 'package:flutter/material.dart';

class UserProfileScreen extends StatefulWidget {
  final String name;
  final int age;
  final Color statusColor;
  final bool isHostViewer;

  const UserProfileScreen({
    super.key,
    required this.name,
    required this.age,
    required this.statusColor,
    required this.isHostViewer,
  });

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool requestSent = false;

  void _sendRequest() {
    if (requestSent) return;

    setState(() {
      requestSent = true;
    });

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => const _RequestSentDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: Column(
                  children: [
                    Row(
                      children: [
                        _BackButton(
                          onTap: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    Container(
                      width: 124,
                      height: 124,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF18183A),
                            Color(0xFF101028),
                          ],
                        ),
                        border: Border.all(
                          color: widget.statusColor,
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: widget.statusColor.withOpacity(0.30),
                            blurRadius: 18,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 58,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      '${widget.name}, ${widget.age}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: widget.statusColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: widget.statusColor,
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        _statusText(),
                        style: TextStyle(
                          color: widget.statusColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 26),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 18,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF151525),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: const Color(0xFF9C4DFF).withOpacity(0.40),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Sobre este perfil',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Perfil detectado dentro de la sala. Aquí luego podrás mostrar datos reales, afinidad, solicitudes y acciones relacionadas con retos.',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.68),
                              fontSize: 14,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    _MainActionButton(
                      enabled: !requestSent,
                      label: requestSent
                          ? 'Solicitud enviada'
                          : 'Enviar solicitud',
                      onTap: _sendRequest,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _statusText() {
    if (widget.statusColor == const Color(0xFF22C55E)) {
      return 'Soltero';
    }
    if (widget.statusColor == const Color(0xFFEAB308)) {
      return 'Haciendo amigos';
    }
    return 'En pareja';
  }
}

class _RequestSentDialog extends StatelessWidget {
  const _RequestSentDialog();

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 1100), () {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    });

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 36),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 22),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0B3D1E),
              Color(0xFF22C55E),
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF22C55E).withOpacity(0.40),
              blurRadius: 24,
              spreadRadius: 1,
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_rounded,
              color: Colors.white,
              size: 24,
            ),
            SizedBox(width: 10),
            Text(
              'Solicitud enviada',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BackButton extends StatefulWidget {
  final VoidCallback onTap;

  const _BackButton({required this.onTap});

  @override
  State<_BackButton> createState() => _BackButtonState();
}

class _BackButtonState extends State<_BackButton> {
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
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF3B1452),
              Color(0xFF24103A),
            ],
          ),
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0xFF7E2BE8),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF8B3DFF).withOpacity(_pressed ? 0.5 : 0.2),
              blurRadius: 18,
              spreadRadius: 1,
            ),
          ],
        ),
        child: const Icon(
          Icons.arrow_back_ios_new,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}

class _MainActionButton extends StatefulWidget {
  final bool enabled;
  final String label;
  final VoidCallback onTap;

  const _MainActionButton({
    required this.enabled,
    required this.label,
    required this.onTap,
  });

  @override
  State<_MainActionButton> createState() => _MainActionButtonState();
}

class _MainActionButtonState extends State<_MainActionButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.enabled ? const Color(0xFF22C55E) : Colors.grey;

    return GestureDetector(
      onTapDown: (_) {
        if (widget.enabled) {
          setState(() => _pressed = true);
        }
      },
      onTapUp: (_) {
        if (widget.enabled) {
          setState(() => _pressed = false);
          widget.onTap();
        }
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF151515),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: color,
            width: 2,
          ),
          boxShadow: widget.enabled && _pressed
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.45),
                    blurRadius: 18,
                    spreadRadius: 1.5,
                  ),
                ]
              : [],
        ),
        child: Text(
          widget.label,
          style: TextStyle(
            color: color,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}