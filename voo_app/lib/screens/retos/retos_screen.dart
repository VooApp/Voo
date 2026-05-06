import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import '../../services/api_service.dart';
import '../../widgets/voo_bottom_nav_bar.dart';
import '../chats/chats_screen.dart';
import '../home/home_screen.dart';
import 'create_challenge_screen.dart';
import '../ranking/ranking_screen.dart';
import '../settings/settings_screen.dart';

class RetosScreen extends StatefulWidget {
  const RetosScreen({super.key});

  @override
  State<RetosScreen> createState() => _RetosScreenState();
}

class _RetosScreenState extends State<RetosScreen> {
  List<RetoModel> _retos = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _cargarRetos();
  }

  Future<void> _cargarRetos() async {
    try {
      final retos = await ApiService.getRetosActivos();
      setState(() {
        _retos = retos;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error al cargar los retos';
        _loading = false;
      });
    }
  }

  // Convierte el estadoReto en los datos visuales de la tarjeta
  _ChallengeViewModel _retoToViewModel(RetoModel reto) {
    switch (reto.estadoReto) {
      case 'activo':
        return _ChallengeViewModel(
          title: reto.concepto,
          badgeText: 'Activo',
          pointsText: '+${reto.puntos} pt',
          color: const Color(0xFF22C55E),
        );
      case 'completado':
        return _ChallengeViewModel(
          title: reto.concepto,
          badgeText: 'Completado',
          pointsText: '+${reto.puntos} pt',
          color: const Color(0xFFEF4444),
        );
      default:
        return _ChallengeViewModel(
          title: reto.concepto,
          badgeText: 'Próximo',
          pointsText: '+${reto.puntos} pt',
          color: const Color(0xFFEAB308),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final bool isHost = appState.isHost;

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
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _RetosTitle(),
                const SizedBox(height: 12),

                // BOTÓN SOLO PARA HOST
                if (isHost) ...[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: _CreateChallengeButton(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CreateChallengeScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 18),
                ],

                // LISTA DE RETOS
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
                                      _cargarRetos();
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
                          : _retos.isEmpty
                              ? const Center(
                                  child: Text(
                                    'No hay retos activos por ahora',
                                    style: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 14,
                                    ),
                                  ),
                                )
                              : RefreshIndicator(
                                  color: const Color(0xFF9C4DFF),
                                  onRefresh: _cargarRetos,
                                  child: ListView.separated(
                                    padding: const EdgeInsets.only(
                                        top: 4, bottom: 12),
                                    itemCount: _retos.length,
                                    separatorBuilder: (_, __) =>
                                        const SizedBox(height: 22),
                                    itemBuilder: (context, index) {
                                      return _WideChallengeCard(
                                        challenge:
                                            _retoToViewModel(_retos[index]),
                                      );
                                    },
                                  ),
                                ),
                ),

                const SizedBox(height: 8),

                // NAV BAR
                VooBottomNavBar(
                  currentIndex: 3,
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
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RankingScreen(),
                        ),
                      );
                    } else if (index == 3) {
                      return;
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

// Todos los widgets de abajo se quedan exactamente igual que antes
class _RetosTitle extends StatelessWidget {
  const _RetosTitle();

  @override
  Widget build(BuildContext context) {
    return const Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: 'Tus retos ',
            style: TextStyle(
              color: Color(0xFFD78BFF),
              fontSize: 30,
              fontWeight: FontWeight.w900,
            ),
          ),
          TextSpan(
            text: 'V',
            style: TextStyle(
              color: Color(0xFF22C55E),
              fontSize: 30,
              fontWeight: FontWeight.w900,
            ),
          ),
          TextSpan(
            text: 'o',
            style: TextStyle(
              color: Color(0xFFEF4444),
              fontSize: 30,
              fontWeight: FontWeight.w900,
            ),
          ),
          TextSpan(
            text: 'o',
            style: TextStyle(
              color: Color(0xFFEAB308),
              fontSize: 30,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChallengeViewModel {
  final String title;
  final String badgeText;
  final String pointsText;
  final Color color;

  const _ChallengeViewModel({
    required this.title,
    required this.badgeText,
    required this.pointsText,
    required this.color,
  });
}

class _WideChallengeCard extends StatefulWidget {
  final _ChallengeViewModel challenge;

  const _WideChallengeCard({
    required this.challenge,
  });

  @override
  State<_WideChallengeCard> createState() => _WideChallengeCardState();
}

class _WideChallengeCardState extends State<_WideChallengeCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _glowAnimation;
  late final Animation<double> _borderAnimation;
  late final Animation<double> _scaleAnimation;

  bool get isActive =>
      widget.challenge.color == const Color(0xFF22C55E);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    _glowAnimation = Tween<double>(begin: 0.18, end: 0.42).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _borderAnimation = Tween<double>(begin: 2.2, end: 3.6).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.012).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (isActive) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.challenge.color;

    if (!isActive) {
      return Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 128),
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
        decoration: BoxDecoration(
          color: const Color(0xFF081328),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: color, width: 2.2),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8, right: 88, bottom: 22),
              child: Text(
                widget.challenge.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  height: 1.25,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: Text(
                widget.challenge.badgeText,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Text(
                widget.challenge.pointsText,
                style: TextStyle(
                  color: color,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 128),
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
            decoration: BoxDecoration(
              color: const Color(0xFF081328),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: color,
                width: _borderAnimation.value,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(_glowAnimation.value),
                  blurRadius: 34,
                  spreadRadius: 4,
                ),
                BoxShadow(
                  color: color.withOpacity(_glowAnimation.value * 0.7),
                  blurRadius: 60,
                  spreadRadius: 8,
                ),
              ],
            ),
            child: Stack(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(top: 8, right: 88, bottom: 22),
                  child: Text(
                    widget.challenge.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      height: 1.25,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Text(
                    widget.challenge.badgeText,
                    style: TextStyle(
                      color: color,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Text(
                    widget.challenge.pointsText,
                    style: TextStyle(
                      color: color,
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CreateChallengeButton extends StatefulWidget {
  final VoidCallback onTap;

  const _CreateChallengeButton({required this.onTap});

  @override
  State<_CreateChallengeButton> createState() => _CreateChallengeButtonState();
}

class _CreateChallengeButtonState extends State<_CreateChallengeButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    const color = Color(0xFF9C4DFF);

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF151525),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: color, width: 2),
          boxShadow: _pressed
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.22),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ]
              : [],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add, color: Color(0xFF9C4DFF), size: 18),
            SizedBox(width: 6),
            Text(
              'Crear reto',
              style: TextStyle(
                color: Color(0xFF9C4DFF),
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}