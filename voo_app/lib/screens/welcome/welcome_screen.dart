import 'package:flutter/material.dart';
import '../host_flow/register_host_screen.dart';
import '../guest_flow/join_room_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0B),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 28),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) {
                      return const LinearGradient(
                        colors: [
                          Color(0xFFF0D7FF),
                          Color(0xFFD78BFF),
                          Color(0xFFB85BFF),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ).createShader(bounds);
                    },
                    child: const Text(
                      'Bienvenido',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 0.6,
                        shadows: [
                          Shadow(
                            color: Color(0x55D78BFF),
                            blurRadius: 14,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  const _GlowingVooTitle(),

                  const SizedBox(height: 44),

                  _WelcomeBubbleButton(
                    title: 'Crear sala',
                    subtitle: 'Organiza tu propia experiencia',
                    icon: Icons.add_circle_outline,
                    color: const Color.fromARGB(255, 62, 162, 255),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RegisterHostScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 18),

                  _WelcomeBubbleButton(
                    title: 'Entrar a la sala',
                    subtitle: 'Únete con tu código',
                    icon: Icons.qr_code_2_outlined,
                    color: const Color.fromARGB(255, 44, 245, 117),
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

class _GlowingVooTitle extends StatelessWidget {
  const _GlowingVooTitle();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        _GlowingLetter(
          letter: 'V',
          color: Color.fromARGB(255, 44, 245, 117),
        ),
        SizedBox(width: 6),
        _GlowingLetter(
          letter: 'O',
          color: Color(0xFFEAB308),
        ),
        SizedBox(width: 6),
        _GlowingLetter(
          letter: 'O',
          color: Color(0xFFEF4444),
        ),
      ],
    );
  }
}

class _GlowingLetter extends StatelessWidget {
  final String letter;
  final Color color;

  const _GlowingLetter({
    required this.letter,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      letter,
      style: TextStyle(
        fontSize: 72,
        fontWeight: FontWeight.w900,
        color: color,
        letterSpacing: 1,
        shadows: [
          Shadow(
            color: color.withOpacity(0.95),
            blurRadius: 12,
          ),
          Shadow(
            color: color.withOpacity(0.7),
            blurRadius: 26,
          ),
          Shadow(
            color: color.withOpacity(0.35),
            blurRadius: 42,
          ),
        ],
      ),
    );
  }
}

class _WelcomeBubbleButton extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _WelcomeBubbleButton({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  State<_WelcomeBubbleButton> createState() => _WelcomeBubbleButtonState();
}

class _WelcomeBubbleButtonState extends State<_WelcomeBubbleButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final darkLeft = Color.lerp(Colors.black, widget.color, 0.28)!;
    final darkMid = Color.lerp(Colors.black, widget.color, 0.48)!;
    final brightRight = Color.lerp(Colors.white, widget.color, 0.88)!;
    final borderColor = Color.lerp(Colors.black, widget.color, 0.62)!;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: [
              darkLeft,
              darkMid,
              widget.color,
              brightRight,
            ],
            stops: const [0.0, 0.28, 0.72, 1.0],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          border: Border.all(
            color: borderColor,
            width: 2.4,
          ),
          boxShadow: [
            if (_pressed)
              BoxShadow(
                color: widget.color.withOpacity(0.85),
                blurRadius: 30,
                spreadRadius: 2,
              )
            else
              BoxShadow(
                color: widget.color.withOpacity(0.22),
                blurRadius: 14,
                spreadRadius: 1,
              ),
            BoxShadow(
              color: Colors.black.withOpacity(0.35),
              blurRadius: 10,
              spreadRadius: 1,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withOpacity(0.18),
                border: Border.all(
                  color: Colors.black.withOpacity(0.35),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withOpacity(0.25),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Icon(
                widget.icon,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.subtitle,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Colors.white,
              size: 28,
            ),
          ],
        ),
      ),
    );
  }
}