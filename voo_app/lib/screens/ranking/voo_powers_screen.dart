import 'package:flutter/material.dart';

class VooPowersScreen extends StatelessWidget {
  const VooPowersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const String userName = 'Maxi';
    const String estado = 'Soltero';
    const int puntos = 25;
    const String poderActivo = 'Ninguno';

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
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
            child: Column(
              children: [
                Row(
                  children: [
                    _CircleBackButton(
                      onTap: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Text(
                        'Poderes Voo',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFD78BFF),
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(width: 54),
                  ],
                ),

                const SizedBox(height: 18),

                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Hola ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      TextSpan(
                        text: userName,
                        style: const TextStyle(
                          color: Color(0xFFD78BFF),
                          fontSize: 38,
                          fontWeight: FontWeight.w900,
                          shadows: [
                            Shadow(
                              color: Color(0xFF9C4DFF),
                              blurRadius: 18,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                Text(
                  'Consigue puntos, sube de nivel y desbloquea ventajas dentro de la sala.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.68),
                    fontSize: 14.5,
                    height: 1.35,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 26),

                Row(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 116,
                          height: 116,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF66D63E),
                              width: 4,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF66D63E).withValues(alpha: 0.22),
                                blurRadius: 18,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 62,
                          ),
                        ),
                        Positioned(
                          right: 8,
                          bottom: 8,
                          child: Container(
                            width: 26,
                            height: 26,
                            decoration: BoxDecoration(
                              color: const Color(0xFF66D63E),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFF05051C),
                                width: 3,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(width: 24),

                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _InfoLine(label: 'Estado', value: estado),
                          SizedBox(height: 10),
                          _InfoLine(label: 'Puntos', value: '$puntos'),
                          SizedBox(height: 10),
                          _InfoLine(label: 'Poder activo', value: poderActivo),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                const _PowerCard(
                  borderColor: Color(0xFF66D63E),
                  icon: Icons.chat_bubble_outline_rounded,
                  title: 'Nivel 1 · El Chismoso',
                  points: '50 pts',
                  description:
                      'Descubre quién ha visto tu perfil y consigue una pequeña ventaja antes de empezar una conversación.',
                ),

                const SizedBox(height: 16),

                const _PowerCard(
                  borderColor: Color(0xFFEAB308),
                  icon: Icons.bolt_rounded,
                  title: 'Nivel 2 · El Cupido',
                  points: '100 pts',
                  description:
                      'Lanza un reto flash anónimo para dos personas y crea el momento perfecto para romper el hielo.',
                ),

                const SizedBox(height: 16),

                const _PowerCard(
                  borderColor: Color(0xFFFF3B5C),
                  icon: Icons.workspace_premium_rounded,
                  title: 'Nivel 3 · Rey de la pista',
                  points: '200 pts',
                  description:
                      'Desbloquea el poder de lanzar un reto personalizado a toda la sala y poner el juego patas arriba.',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  final String label;
  final String value;

  const _InfoLine({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: '$label\n',
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.58),
          fontSize: 13,
          fontWeight: FontWeight.w700,
          height: 1.25,
        ),
        children: [
          TextSpan(
            text: value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w900,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _PowerCard extends StatelessWidget {
  final Color borderColor;
  final IconData icon;
  final String title;
  final String points;
  final String description;

  const _PowerCard({
    required this.borderColor,
    required this.icon,
    required this.title,
    required this.points,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      decoration: BoxDecoration(
        color: const Color(0xFF101020),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: borderColor,
          width: 2.8,
        ),
        boxShadow: [
          BoxShadow(
            color: borderColor.withValues(alpha: 0.25),
            blurRadius: 20,
            spreadRadius: 0.7,
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: borderColor,
            size: 54,
            shadows: [
              Shadow(
                color: borderColor.withValues(alpha: 0.8),
                blurRadius: 16,
              ),
            ],
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: borderColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: borderColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: borderColor.withValues(alpha: 0.7),
                    ),
                  ),
                  child: Text(
                    points,
                    style: TextStyle(
                      color: borderColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.88),
                    fontSize: 14,
                    height: 1.35,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleBackButton extends StatefulWidget {
  final VoidCallback onTap;

  const _CircleBackButton({
    required this.onTap,
  });

  @override
  State<_CircleBackButton> createState() => _CircleBackButtonState();
}

class _CircleBackButtonState extends State<_CircleBackButton> {
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
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0xFF9C4DFF),
            width: 2.4,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF8B3DFF).withValues(alpha: _pressed ? 0.5 : 0.22),
              blurRadius: 18,
              spreadRadius: 1,
            ),
          ],
        ),
        child: const Icon(
          Icons.arrow_back_ios_new,
          color: Colors.white,
          size: 22,
        ),
      ),
    );
  }
}