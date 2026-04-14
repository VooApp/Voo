import 'package:flutter/material.dart';
import '../register/register_screen.dart';
import '../join_room/join_room_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0B),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Bienvenido',
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFD78BFF),
                    ),
                  ),

                  const SizedBox(height: 10),

                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
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
                      ],
                    ),
                  ),

                  const SizedBox(height: 50),

                  // BOTÓN CREAR SALA
                  VooCircleButton(
                    icon: Icons.add,
                    color: const Color.fromARGB(255, 62, 162, 255),
                    label: 'Crear sala',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RegisterScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 30),

                  // BOTÓN ENTRAR SALA
                  VooCircleButton(
                    icon: Icons.mail_outline,
                    color: const Color.fromARGB(255, 41, 240, 114),
                    label: 'Entrar a la sala',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const JoinRoomScreen(),
                        ),
                      );
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

class VooCircleButton extends StatefulWidget {
  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;

  const VooCircleButton({
    super.key,
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
  });

  @override
  State<VooCircleButton> createState() => _VooCircleButtonState();
}

class _VooCircleButtonState extends State<VooCircleButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) {
            setState(() => _pressed = false);
            widget.onTap();
          },
          onTapCancel: () => setState(() => _pressed = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF151515),
              border: Border.all(
                color: widget.color,
                width: 2.5,
              ),
              boxShadow: _pressed
                  ? [
                      BoxShadow(
                        color: widget.color.withOpacity(0.6),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ]
                  : [],
            ),
            child: Icon(
              widget.icon,
              color: widget.color,
              size: 38,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 15,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}