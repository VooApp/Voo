import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RoomCodeScreen extends StatefulWidget {
  const RoomCodeScreen({super.key});

  @override
  State<RoomCodeScreen> createState() => _RoomCodeScreenState();
}

class _RoomCodeScreenState extends State<RoomCodeScreen> {
  static const String roomCode = 'CV 7624X5';

  bool _copied = false;

  Future<void> _copyCode() async {
    await Clipboard.setData(const ClipboardData(text: roomCode));

    if (!mounted) return;

    setState(() {
      _copied = true;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Código copiado')));

    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    setState(() {
      _copied = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color accentColor = _copied
        ? const Color.fromARGB(255, 44, 245, 117)
        : const Color(0xFFD78BFF);

    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0B),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Código de Sala',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFD78BFF),
                    ),
                  ),
                  const SizedBox(height: 24),

                  GestureDetector(
                    onTap: _copyCode,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 28,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF151515),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: accentColor, width: 2),
                        boxShadow: _copied
                            ? [
                                BoxShadow(
                                  color: const Color.fromARGB(
                                    255,
                                    44,
                                    245,
                                    117,
                                  ).withOpacity(0.45),
                                  blurRadius: 18,
                                  spreadRadius: 2,
                                ),
                              ]
                            : [],
                      ),
                      child: Column(
                        children: [
                          Icon(
                            _copied
                                ? Icons.check_circle_outline
                                : Icons.qr_code_2,
                            size: 72,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 18),
                          Text(
                            _copied ? 'Copiado ✔' : 'Tu código de sala',
                            style: TextStyle(
                              color: _copied
                                  ? const Color.fromARGB(255, 44, 245, 117)
                                  : Colors.white70,
                              fontSize: 15,
                              fontWeight: _copied
                                  ? FontWeight.w700
                                  : FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            roomCode,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color.fromARGB(255, 44, 245, 117),
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 2,
                              decoration: TextDecoration.underline,
                              decorationColor: _copied
                                  ? const Color.fromARGB(255, 44, 245, 117)
                                  : Colors.white54,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _copied
                                ? 'El código se ha copiado al portapapeles'
                                : 'Toca el QR o el código para copiarlo',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: _copied ? Colors.white : Colors.white54,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 26),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _ActionButton(
                        icon: Icons.download_outlined,
                        label: 'Descargar',
                        color: const Color.fromARGB(255, 62, 162, 255),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Descarga simulada')),
                          );
                        },
                      ),
                      const SizedBox(width: 16),
                      _ActionButton(
                        icon: Icons.share_outlined,
                        label: 'Compartir',
                        color: const Color.fromARGB(255, 44, 245, 117),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Compartir simulado')),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  _ActionButton(
                    icon: Icons.copy_all_outlined,
                    label: _copied ? 'Copiado' : 'Copiar código',
                    color: const Color.fromARGB(255, 44, 245, 117),
                    onTap: _copyCode,
                  ),

                  const SizedBox(height: 28),

                  _MainButton(
                    label: 'Ir al inicio',
                    onTap: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
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
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF151515),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: widget.color, width: 2),
          boxShadow: _pressed
              ? [
                  BoxShadow(
                    color: widget.color.withOpacity(0.55),
                    blurRadius: 16,
                    spreadRadius: 2,
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(widget.icon, color: widget.color, size: 20),
            const SizedBox(width: 8),
            Text(
              widget.label,
              style: TextStyle(
                color: widget.color,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MainButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const _MainButton({required this.label, required this.onTap});

  @override
  State<_MainButton> createState() => _MainButtonState();
}

class _MainButtonState extends State<_MainButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    const color = Color.fromARGB(255, 44, 245, 117);

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF151515),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: color, width: 2),
          boxShadow: _pressed
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.55),
                    blurRadius: 18,
                    spreadRadius: 2,
                  ),
                ]
              : [],
        ),
        child: const Text(
          'Ir al inicio',
          style: TextStyle(
            color: color,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
