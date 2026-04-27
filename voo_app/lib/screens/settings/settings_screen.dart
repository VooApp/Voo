import 'package:flutter/material.dart';

import '../../widgets/voo_bottom_nav_bar.dart';
import '../home/home_screen.dart';
import '../chats/chats_screen.dart';
import '../ranking/ranking_screen.dart';
import '../retos/retos_screen.dart';

class SettingsScreen extends StatelessWidget {
  final bool isHost;

  const SettingsScreen({
    super.key,
    this.isHost = true,
  });

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
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
            child: Column(
              children: [
                const Text(
                  'Ajustes',
                  style: TextStyle(
                    color: Color(0xFFD78BFF),
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 24),

                _ProfileCard(isHost: isHost),

                const SizedBox(height: 20),

                _SectionCard(
                  title: 'Ayuda',
                  children: [
                    _SettingsRow(
                      title: 'Manual de uso',
                      icon: Icons.menu_book_rounded,
                      onTap: () {},
                    ),
                    _SettingsRow(
                      title: 'Reportar incidencia',
                      icon: Icons.report_problem_outlined,
                      onTap: () {},
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                _RoomCard(isHost: isHost),

                const Spacer(),

                if (isHost)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _ActionButton(
                        text: 'Banear usuario',
                        color: const Color(0xFF52A9FF),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const BannedUsersScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 14),
                      _ActionButton(
                        text: 'Cerrar sala',
                        color: const Color(0xFFFF3B5C),
                        onTap: () {},
                      ),
                    ],
                  )
                else
                  _ActionButton(
                    text: 'Salir de la sala',
                    color: const Color(0xFFFF3B5C),
                    onTap: () {},
                  ),

                const SizedBox(height: 16),

                VooBottomNavBar(
                  currentIndex: 4,
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
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RetosScreen(),
                        ),
                      );
                    } else if (index == 4) {
                      return;
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

class _ProfileCard extends StatelessWidget {
  final bool isHost;

  const _ProfileCard({
    required this.isHost,
  });

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Perfil',
            style: TextStyle(
              color: Color(0xFFD78BFF),
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: 68,
                    height: 68,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF66D63E),
                        width: 3.5,
                      ),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 38,
                    ),
                  ),
                  Positioned(
                    right: 2,
                    bottom: 2,
                    child: Container(
                      width: 17,
                      height: 17,
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
              const SizedBox(width: 18),
              const Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _ProfileInfo(title: 'Maxi', subtitle: '27 años'),
                    _ProfileInfo(title: 'Chismoso', subtitle: 'Nivel'),
                    _ProfileInfo(title: '0', subtitle: 'Premios'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProfileInfo extends StatelessWidget {
  final String title;
  final String subtitle;

  const _ProfileInfo({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white.withOpacity(0.58),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _RoomCard extends StatelessWidget {
  final bool isHost;

  const _RoomCard({
    required this.isHost,
  });

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sala',
            style: TextStyle(
              color: Color(0xFFD78BFF),
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const _RoomInfo(title: 'XY200K', subtitle: 'Código'),
              const _RoomInfo(title: '29', subtitle: 'Invitados'),
              _RoomInfo(
                title: '3',
                subtitle: isHost ? 'Baneados' : 'Match',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RoomInfo extends StatelessWidget {
  final String title;
  final String subtitle;

  const _RoomInfo({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white.withOpacity(0.58),
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SectionCard({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFFD78BFF),
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _SettingsRow({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.white.withOpacity(0.08),
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: const Color(0xFFD78BFF),
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Colors.white54,
            ),
          ],
        ),
      ),
    );
  }
}

class _GlassCard extends StatelessWidget {
  final Widget child;

  const _GlassCard({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      decoration: BoxDecoration(
        color: const Color(0xFF151525),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF9C4DFF).withOpacity(0.55),
          width: 1.5,
        ),
      ),
      child: child,
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.text,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 11,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF151525),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: color,
            width: 2,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class BannedUsersScreen extends StatelessWidget {
  const BannedUsersScreen({super.key});

  final List<Map<String, dynamic>> bannedUsers = const [
    {'name': 'Alex', 'color': Color(0xFF66D63E)},
    {'name': 'Marta', 'color': Color(0xFFEAB308)},
    {'name': 'Dani', 'color': Color(0xFF66D63E)},
    {'name': 'Sergio', 'color': Color(0xFFFF3B5C)},
    {'name': 'Laura', 'color': Color(0xFF66D63E)},
    {'name': 'Pau', 'color': Color(0xFFEAB308)},
    {'name': 'Nerea', 'color': Color(0xFFEAB308)},
    {'name': 'Júlia', 'color': Color(0xFF66D63E)},
    {'name': 'Marc', 'color': Color(0xFFFF3B5C)},
  ];

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
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: const Color(0xFFFF3B5C),
                              width: 2,
                            ),
                          ),
                          child: const Text(
                            'Banear invitado',
                            style: TextStyle(
                              color: Color(0xFFFF3B5C),
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                    ),
                    _SmallBackButton(
                      onTap: () => Navigator.pop(context),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF151525),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: const Color(0xFF9C4DFF).withOpacity(0.55),
                      width: 1.5,
                    ),
                  ),
                  child: const Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Buscar invitado',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.search_rounded,
                        color: Colors.white70,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                Expanded(
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemCount: bannedUsers.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final user = bannedUsers[index];

                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF151525),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.08),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 46,
                              height: 46,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: user['color'],
                                  width: 2.7,
                                ),
                              ),
                              child: const Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                user['name'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.block_rounded,
                              color: Color(0xFFFF3B5C),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                VooBottomNavBar(
                  currentIndex: 4,
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

class _SmallBackButton extends StatelessWidget {
  final VoidCallback onTap;

  const _SmallBackButton({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF151525),
          border: Border.all(
            color: const Color(0xFF52A9FF),
            width: 2,
          ),
        ),
        child: const Icon(
          Icons.arrow_back_rounded,
          color: Color(0xFF52A9FF),
        ),
      ),
    );
  }
}