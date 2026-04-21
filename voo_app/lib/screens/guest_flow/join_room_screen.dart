import 'package:flutter/material.dart';
import 'guest_status_screen.dart';

class JoinRoomScreen extends StatefulWidget {
  const JoinRoomScreen({super.key});

  @override
  State<JoinRoomScreen> createState() => _JoinRoomScreenState();
}

class _JoinRoomScreenState extends State<JoinRoomScreen> {
  final TextEditingController _codeController = TextEditingController();

  bool get _isValid => _codeController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _codeController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _goNext() {
    if (!_isValid) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const _LocationPermissionDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0B),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Tu sala',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 50,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.w800,
                      ),
                      children: [
                        TextSpan(
                          text: 'V',
                          style: TextStyle(color: Color(0xFF22C55E)),
                        ),
                        TextSpan(
                          text: 'o',
                          style: TextStyle(color: Color(0xFFEAB308)),
                        ),
                        TextSpan(
                          text: 'o',
                          style: TextStyle(color: Color(0xFFEF4444)),
                        ),
                        TextSpan(
                          text: '!',
                          style: TextStyle(color: Color(0xFFD78BFF)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _VooInput(
                    controller: _codeController,
                    hintText: 'Código de Sala',
                  ),
                  const SizedBox(height: 12),
                  if (!_isValid)
                    const Text(
                      'Escribe el código para continuar.',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 13,
                      ),
                    ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _RoundBackButton(
                        onTap: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 20),
                      _NextButton(
                        enabled: _isValid,
                        onTap: _goNext,
                      ),
                    ],
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

class _VooInput extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;

  const _VooInput({
    required this.hintText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.white54,
        ),
        filled: true,
        fillColor: const Color(0xFF151515),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: Color(0xFFD78BFF),
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: Color(0xFFD78BFF),
            width: 2,
          ),
        ),
      ),
    );
  }
}

class _RoundBackButton extends StatelessWidget {
  final VoidCallback onTap;

  const _RoundBackButton({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF151515),
          border: Border.all(
            color: const Color.fromARGB(255, 62, 162, 255),
            width: 2,
          ),
        ),
        child: const Icon(
          Icons.arrow_back,
          color: Color.fromARGB(255, 62, 162, 255),
          size: 24,
        ),
      ),
    );
  }
}

class _NextButton extends StatefulWidget {
  final VoidCallback onTap;
  final bool enabled;

  const _NextButton({
    required this.onTap,
    required this.enabled,
  });

  @override
  State<_NextButton> createState() => _NextButtonState();
}

class _NextButtonState extends State<_NextButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.enabled
        ? const Color.fromARGB(255, 44, 245, 117)
        : Colors.grey;

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
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF151515),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: color,
            width: 2,
          ),
          boxShadow: (_pressed && widget.enabled)
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.55),
                    blurRadius: 18,
                    spreadRadius: 2,
                  ),
                ]
              : [],
        ),
        child: Text(
          'Siguiente',
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

class _LocationPermissionDialog extends StatelessWidget {
  const _LocationPermissionDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
        decoration: BoxDecoration(
          color: const Color(0xFF151515),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: const Color(0xFFD78BFF),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.location_on_outlined,
              size: 42,
              color: Colors.white,
            ),
            const SizedBox(height: 18),
            const Text(
              'Necesitamos tu ubicación para poder entrar a la sala.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                height: 1.4,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _DialogButton(
                  label: 'Denegar',
                  color: const Color(0xFFEF4444),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(width: 14),
                _DialogButton(
                  label: 'Permitir',
                  color: const Color.fromARGB(255, 44, 245, 117),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const GuestStatusScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DialogButton extends StatefulWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _DialogButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  State<_DialogButton> createState() => _DialogButtonState();
}

class _DialogButtonState extends State<_DialogButton> {
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
        decoration: BoxDecoration(
          color: const Color(0xFF101010),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: widget.color,
            width: 2,
          ),
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
        child: Text(
          widget.label,
          style: TextStyle(
            color: widget.color,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}