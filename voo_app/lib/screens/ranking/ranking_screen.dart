import 'package:flutter/material.dart';

import '../../widgets/voo_bottom_nav_bar.dart';
import '../home/home_screen.dart';
import '../chats/chats_screen.dart';
import '../retos/retos_screen.dart';
import 'voo_powers_screen.dart';

class RankingScreen extends StatelessWidget {
  const RankingScreen({super.key});

  final List<Map<String, dynamic>> ranking = const [
    {'name': 'Maximo', 'points': 469, 'color': Color(0xFFFFD84D)},
    {'name': 'Ana', 'points': 375, 'color': Color(0xFFC9D6FF)},
    {'name': 'Julia', 'points': 280, 'color': Color(0xFFFF9B45)},
    {'name': 'Maxi', 'points': 278, 'color': Color(0xFF52A9FF)},
    {'name': 'Paula', 'points': 160, 'color': Color(0xFF52A9FF)},
    {'name': 'Pablo', 'points': 143, 'color': Color(0xFF52A9FF)},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF05051C),
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.2,
            colors: [
              Color(0xFF171128),
              Color(0xFF0C0A18),
              Color(0xFF05051C),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
            child: Column(
              children: [
                const _RankingTitle(),

                const SizedBox(height: 22),

                Container(
                  width: 116,
                  height: 116,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const RadialGradient(
                      colors: [
                        Color(0xFF143B66),
                        Color(0xFF071124),
                      ],
                    ),
                    border: Border.all(
                      color: const Color(0xFF52A9FF),
                      width: 3,
                    ),
                  ),
                  child: const Icon(
                    Icons.emoji_events_rounded,
                    color: Color(0xFF52A9FF),
                    size: 70,
                  ),
                ),

                const SizedBox(height: 28),

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const VooPowersScreen(),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 17),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: const Color(0xFF9C4DFF),
                        width: 2.4,
                      ),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF211033),
                          Color(0xFF11111F),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF9C4DFF).withOpacity(0.28),
                          blurRadius: 18,
                          spreadRadius: 0.5,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: _UnlockText(),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                Expanded(
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemCount: ranking.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final user = ranking[index];
                      final Color color = user['color'];

                      return _RankingCard(
                        position: index + 1,
                        name: user['name'],
                        points: user['points'],
                        color: color,
                      );
                    },
                  ),
                ),

                VooBottomNavBar(
                  currentIndex: 2,
                  onTap: (index) {
                    if (index == 0) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const HomeScreen(),
                        ),
                      );
                    } else if (index == 1) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ChatsScreen(),
                        ),
                      );
                    } else if (index == 2) {
                      return;
                    } else if (index == 3) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RetosScreen(),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RankingTitle extends StatelessWidget {
  const _RankingTitle();

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          const TextSpan(
            text: 'Ranking de ',
            style: TextStyle(
              color: Color(0xFFD78BFF),
              fontSize: 30,
              fontWeight: FontWeight.w900,
            ),
          ),
          TextSpan(
            text: 'V',
            style: TextStyle(
              color: const Color(0xFF66D63E),
              fontSize: 32,
              fontWeight: FontWeight.w900,
              shadows: [
                Shadow(
                  color: const Color(0xFF66D63E).withOpacity(0.9),
                  blurRadius: 18,
                ),
              ],
            ),
          ),
          TextSpan(
            text: 'o',
            style: TextStyle(
              color: const Color(0xFFEAB308),
              fontSize: 32,
              fontWeight: FontWeight.w900,
              shadows: [
                Shadow(
                  color: const Color(0xFFEAB308).withOpacity(0.9),
                  blurRadius: 18,
                ),
              ],
            ),
          ),
          TextSpan(
            text: 'o',
            style: TextStyle(
              color: const Color(0xFFFF3B5C),
              fontSize: 32,
              fontWeight: FontWeight.w900,
              shadows: [
                Shadow(
                  color: const Color(0xFFFF3B5C).withOpacity(0.9),
                  blurRadius: 18,
                ),
              ],
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}

class _UnlockText extends StatelessWidget {
  const _UnlockText();

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          const TextSpan(
            text: 'Desbloquear poderes ',
            style: TextStyle(
              color: Color(0xFFD78BFF),
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          TextSpan(
            text: 'V',
            style: TextStyle(
              color: const Color(0xFF66D63E),
              fontSize: 19,
              fontWeight: FontWeight.w900,
              shadows: [
                Shadow(
                  color: const Color(0xFF66D63E).withOpacity(0.85),
                  blurRadius: 14,
                ),
              ],
            ),
          ),
          TextSpan(
            text: 'o',
            style: TextStyle(
              color: const Color(0xFFEAB308),
              fontSize: 19,
              fontWeight: FontWeight.w900,
              shadows: [
                Shadow(
                  color: const Color(0xFFEAB308).withOpacity(0.85),
                  blurRadius: 14,
                ),
              ],
            ),
          ),
          TextSpan(
            text: 'o',
            style: TextStyle(
              color: const Color(0xFFFF3B5C),
              fontSize: 19,
              fontWeight: FontWeight.w900,
              shadows: [
                Shadow(
                  color: const Color(0xFFFF3B5C).withOpacity(0.85),
                  blurRadius: 14,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RankingCard extends StatelessWidget {
  final int position;
  final String name;
  final int points;
  final Color color;

  const _RankingCard({
    required this.position,
    required this.name,
    required this.points,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final bool isTopOne = position == 1;
    final bool isTopThree = position <= 3;

    return Container(
      height: 82,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF111124),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: color.withOpacity(isTopThree ? 0.95 : 0.55),
          width: isTopThree ? 2.2 : 1.4,
        ),
        boxShadow: isTopOne
            ? [
                BoxShadow(
                  color: color.withOpacity(0.28),
                  blurRadius: 20,
                  spreadRadius: 0.8,
                ),
              ]
            : [],
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.12),
              border: Border.all(color: color, width: 2.3),
              boxShadow: isTopOne
                  ? [
                      BoxShadow(
                        color: color.withOpacity(0.35),
                        blurRadius: 12,
                      ),
                    ]
                  : [],
            ),
            child: Center(
              child: Text(
                '$position',
                style: TextStyle(
                  color: color,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          Stack(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: color, width: 2.2),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF1E1E35),
                      Color(0xFF10101E),
                    ],
                  ),
                ),
                child: const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 34,
                ),
              ),
              Positioned(
                right: 1,
                bottom: 1,
                child: Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                    color: const Color(0xFF66D63E),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF05051C),
                      width: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),

          Text(
            '$points',
            style: TextStyle(
              color: color,
              fontSize: 21,
              fontWeight: FontWeight.w900,
              shadows: isTopOne
                  ? [
                      Shadow(
                        color: color.withOpacity(0.7),
                        blurRadius: 12,
                      ),
                    ]
                  : [],
            ),
          ),
        ],
      ),
    );
  }
}