import 'package:flutter/material.dart';

import '../../widgets/voo_bottom_nav_bar.dart';
import '../home/home_screen.dart';
import '../chats/chats_screen.dart';
import '../ranking/ranking_screen.dart';
import '../retos/retos_screen.dart';

class BannedUsersScreen extends StatefulWidget {
  const BannedUsersScreen({super.key});

  @override
  State<BannedUsersScreen> createState() => _BannedUsersScreenState();
}

class _BannedUsersScreenState extends State<BannedUsersScreen> {
  final TextEditingController searchController = TextEditingController();

  final List<Map<String, dynamic>> users = [
    {'name': 'Alex', 'color': const Color(0xFF66D63E), 'banned': false},
    {'name': 'Marta', 'color': const Color(0xFFEAB308), 'banned': false},
    {'name': 'Dani', 'color': const Color(0xFF66D63E), 'banned': false},
    {'name': 'Sergio', 'color': const Color(0xFFFF3B5C), 'banned': false},
    {'name': 'Laura', 'color': const Color(0xFF66D63E), 'banned': false},
    {'name': 'Pau', 'color': const Color(0xFFEAB308), 'banned': false},
    {'name': 'Nerea', 'color': const Color(0xFFEAB308), 'banned': false},
    {'name': 'Júlia', 'color': const Color(0xFF66D63E), 'banned': false},
    {'name': 'Marc', 'color': const Color(0xFFFF3B5C), 'banned': false},
  ];

  String searchText = '';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _toggleBan(int realIndex) {
    final bool isBanned = users[realIndex]['banned'] as bool;

    setState(() {
      users[realIndex]['banned'] = !isBanned;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isBanned
              ? '${users[realIndex]['name']} ya no está baneado'
              : '${users[realIndex]['name']} ha sido baneado',
        ),
      ),
    );
  }

  List<int> get _filteredIndexes {
    final query = searchText.trim().toLowerCase();

    final indexes = <int>[];

    for (int i = 0; i < users.length; i++) {
      final name = users[i]['name'].toString().toLowerCase();

      if (query.isEmpty || name.contains(query)) {
        indexes.add(i);
      }
    }

    return indexes;
  }

  @override
  Widget build(BuildContext context) {
    final filteredIndexes = _filteredIndexes;

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
                    _PurpleBackButton(
                      onTap: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Invitados',
                          style: TextStyle(
                            color: Color(0xFFD78BFF),
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 46),
                  ],
                ),

                const SizedBox(height: 18),

                TextField(
                  controller: searchController,
                  onChanged: (value) {
                    setState(() {
                      searchText = value;
                    });
                  },
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Buscar invitado',
                    hintStyle: const TextStyle(
                      color: Colors.white54,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    suffixIcon: const Icon(
                      Icons.search_rounded,
                      color: Colors.white70,
                    ),
                    filled: true,
                    fillColor: const Color(0xFF151525),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide(
                        color: const Color(0xFF9C4DFF).withOpacity(0.55),
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: const BorderSide(
                        color: Color(0xFF9C4DFF),
                        width: 2,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                Expanded(
                  child: filteredIndexes.isEmpty
                      ? Center(
                          child: Text(
                            'No se ha encontrado ningún invitado',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.58),
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        )
                      : ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemCount: filteredIndexes.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final realIndex = filteredIndexes[index];
                            final user = users[realIndex];

                            final bool isBanned = user['banned'] as bool;
                            final Color avatarColor = user['color'] as Color;

                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF151525),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: isBanned
                                      ? const Color(0xFFFF3B5C)
                                          .withOpacity(0.75)
                                      : Colors.white.withOpacity(0.08),
                                  width: isBanned ? 1.6 : 1,
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
                                        color: isBanned
                                            ? const Color(0xFFFF3B5C)
                                            : avatarColor,
                                        width: 2.7,
                                      ),
                                    ),
                                    child: Icon(
                                      isBanned
                                          ? Icons.person_off_rounded
                                          : Icons.person,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          user['name'].toString(),
                                          style: TextStyle(
                                            color: isBanned
                                                ? Colors.white.withOpacity(0.55)
                                                : Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800,
                                            decoration: isBanned
                                                ? TextDecoration.lineThrough
                                                : TextDecoration.none,
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          isBanned
                                              ? 'Usuario baneado'
                                              : 'Usuario activo',
                                          style: TextStyle(
                                            color: isBanned
                                                ? const Color(0xFFFF3B5C)
                                                : const Color(0xFF66D63E),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => _toggleBan(realIndex),
                                    child: Container(
                                      width: 42,
                                      height: 42,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: isBanned
                                            ? const Color(0xFFFF3B5C)
                                                .withOpacity(0.13)
                                            : const Color(0xFF151525),
                                        border: Border.all(
                                          color: isBanned
                                              ? const Color(0xFF66D63E)
                                              : const Color(0xFFFF3B5C),
                                          width: 2,
                                        ),
                                      ),
                                      child: Icon(
                                        isBanned
                                            ? Icons.lock_open_rounded
                                            : Icons.block_rounded,
                                        color: isBanned
                                            ? const Color(0xFF66D63E)
                                            : const Color(0xFFFF3B5C),
                                      ),
                                    ),
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

class _PurpleBackButton extends StatefulWidget {
  final VoidCallback onTap;

  const _PurpleBackButton({
    required this.onTap,
  });

  @override
  State<_PurpleBackButton> createState() => _PurpleBackButtonState();
}

class _PurpleBackButtonState extends State<_PurpleBackButton> {
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
        width: 46,
        height: 46,
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
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF8B3DFF).withOpacity(_pressed ? 0.5 : 0.2),
              blurRadius: 18,
              spreadRadius: 1,
            ),
          ],
        ),
        child: const Icon(
          Icons.arrow_back_ios_new,
          color: Colors.white,
          size: 19,
        ),
      ),
    );
  }
}