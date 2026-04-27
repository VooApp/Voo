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
                Align(
                  alignment: Alignment.centerLeft,
                  child: _CircleBackButton(
                    onTap: () => Navigator.pop(context),
                  ),
                ),

                Text(
                  'Hola $userName',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFFD78BFF),
                    fontSize: 42,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 28),

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
                          _InfoLine(label: 'Estado:', value: estado),
                          SizedBox(height: 10),
                          _InfoLine(label: 'Puntos:', value: '$puntos'),
                          SizedBox(height: 10),
                          _InfoLine(label: 'Poder:', value: poderActivo),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                const _PowerCard(
                  borderColor: Color(0xFF66D63E),
                  icon: Icons.chat_bubble_outline_rounded,
                  title: 'Nivel 1: EL CHISMOSO',
                  points: '+50 pts',
                  description:
                      'Puedes ver quién ha visto tu perfil o ver las respuestas de qué le gusta antes de hablarle.',
                ),

                const SizedBox(height: 16),

                const _PowerCard(
                  borderColor: Color(0xFFEAB308),
                  icon: Icons.bolt_rounded,
                  title: 'Nivel 2: EL CUPIDO',
                  points: '+100 pts',
                  description:
                      'Puedes lanzar un reto Flash anónimo sólo para 2 personas. Usuario y usuario se toman una foto.',
                ),

                const SizedBox(height: 16),

                const _PowerCard(
                  borderColor: Color(0xFFFF3B5C),
                  icon: Icons.workspace_premium_rounded,
                  title: 'Nivel 3: REY DE LA PISTA',
                  points: '+200 pts',
                  description:
                      'Ganas el derecho a lanzar un reto personalizado a toda la sala.',
                ),

                const Spacer(),

                _CircleBackButton(
                  onTap: () => Navigator.pop(context),
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
        text: '$label ',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w800,
        ),
        children: [
          TextSpan(
            text: value,
            style: const TextStyle(
              color: Color(0xFF66D63E),
              fontSize: 18,
              fontWeight: FontWeight.w900,
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
            color: borderColor.withOpacity(0.25),
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
            size: 58,
            shadows: [
              Shadow(
                color: borderColor.withOpacity(0.8),
                blurRadius: 16,
              ),
            ],
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: title,
                        style: TextStyle(
                          color: borderColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      TextSpan(
                        text: '   $points',
                        style: TextStyle(
                          color: borderColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14.5,
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

class _CircleBackButton extends StatelessWidget {
  final VoidCallback onTap;

  const _CircleBackButton({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 54,
        height: 54,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF101A33),
          border: Border.all(
            color: const Color(0xFF52A9FF),
            width: 2.4,
          ),
        ),
        child: const Icon(
          Icons.arrow_back_rounded,
          color: Color(0xFF52A9FF),
          size: 30,
        ),
      ),
    );
  }
}