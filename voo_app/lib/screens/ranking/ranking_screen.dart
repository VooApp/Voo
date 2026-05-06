import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import '../../services/api_service.dart';
import '../../widgets/voo_bottom_nav_bar.dart';
import '../home/home_screen.dart';
import '../chats/chats_screen.dart';
import '../retos/retos_screen.dart';
import 'voo_powers_screen.dart';
import '../settings/settings_screen.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  List<Map<String, dynamic>> _ranking = [];
  bool _loading = true;
  String? _error;

  static const List<Color> _positionColors = [
    Color(0xFFFFD84D),
    Color(0xFFC9D6FF),
    Color(0xFFFF9B45),
    Color(0xFF52A9FF),
    Color(0xFF52A9FF),
    Color(0xFF52A9FF),
  ];

  @override
  void initState() {
    super.initState();
    _cargarRanking();
  }

  Future<void> _cargarRanking() async {
    final salaId = context.read<AppState>().salaId;

    if (salaId == null) {
      setState(() {
        _error = 'No se encontró la sala';
        _loading = false;
      });
      return;
    }

    try {
      final usuarios = await ApiService.getUsuariosSala(salaId);
      usuarios.sort((a, b) => b.puntos.compareTo(a.puntos));

      setState(() {
        _ranking = usuarios
            .map((u) => {
                  'name': u.nombre,
                  'points': u.puntos,
                  'foto': u.foto,
                })
            .toList();
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error al cargar el ranking';
        _loading = false;
      });
    }
  }

  Color _colorForPosition(int index) {
    if (index < _positionColors.length) return _positionColors[index];
    return const Color(0xFF52A9FF);
  }

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
                _RankingTitle(),
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
                  child: _loading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF9C4DFF),
                          ),
                        )
                      : _error != null
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _error!,
                                    style: const TextStyle(
                                      color: Colors.white54,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _loading = true;
                                        _error = null;
                                      });
                                      _cargarRanking();
                                    },
                                    child: const Text(
                                      'Reintentar',
                                      style: TextStyle(
                                        color: Color(0xFF9C4DFF),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : _ranking.isEmpty
                              ? const Center(
                                  child: Text(
                                    'Aún no hay puntuaciones',
                                    style: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 14,
                                    ),
                                  ),
                                )
                              : RefreshIndicator(
                                  color: const Color(0xFF9C4DFF),
                                  onRefresh: _cargarRanking,
                                  child: ListView.separated(
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: _ranking.length,
                                    separatorBuilder: (_, __) =>
                                        const SizedBox(height: 12),
                                    itemBuilder: (context, index) {
                                      final user = _ranking[index];
                                      return _RankingCard(
                                        position: index + 1,
                                        name: user['name'] as String,
                                        points: user['points'] as int,
                                        foto: user['foto'] as String?,
                                        color: _colorForPosition(index),
                                      );
                                    },
                                  ),
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
                    } else if (index == 4) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SettingsScreen(),
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

// ─── WIDGETS ─────────────────────────────────────────────────────────

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
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
          const TextSpan(
            text: 'V',
            style: TextStyle(
              color: Color(0xFF22C55E),
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
          const TextSpan(
            text: 'o',
            style: TextStyle(
              color: Color(0xFFEF4444),
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
          const TextSpan(
            text: 'o',
            style: TextStyle(
              color: Color(0xFFEAB308),
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
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
            text: '✦ ',
            style: TextStyle(
              color: Color(0xFF9C4DFF),
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
          const TextSpan(
            text: 'Desbloquea poderes ',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const TextSpan(
            text: 'Voo',
            style: TextStyle(
              color: Color(0xFF9C4DFF),
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}

class _RankingCard extends StatelessWidget {
  final int position;
  final String name;
  final int points;
  final String? foto;
  final Color color;

  const _RankingCard({
    required this.position,
    required this.name,
    required this.points,
    required this.color,
    this.foto,
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
                child: foto != null && foto!.isNotEmpty
                    ? ClipOval(
                        child: Image.network(
                          foto!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 34,
                          ),
                        ),
                      )
                    : const Icon(
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