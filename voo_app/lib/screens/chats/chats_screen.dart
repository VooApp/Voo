import 'package:flutter/material.dart';

import '../../widgets/voo_bottom_nav_bar.dart';
import '../home/home_screen.dart';
import 'chat_conversation_screen.dart';

class ChatsScreen extends StatefulWidget {
  final bool isHost;

  const ChatsScreen({
    super.key,
    required this.isHost,
  });

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<_ChatItemData> _allChats = const [
    _ChatItemData(
      name: 'Maria',
      lastMessage: 'Te he visto en el reto de antes 👀',
      time: '21:14',
      unreadCount: 2,
      statusColor: Color(0xFFEF4444),
    ),
    _ChatItemData(
      name: 'Juan',
      lastMessage: 'Luego hablamos dentro',
      time: '20:58',
      unreadCount: 0,
      statusColor: Color(0xFF22C55E),
    ),
    _ChatItemData(
      name: 'Anna',
      lastMessage: 'Jajaj sí, ha sido buenísimo',
      time: '20:41',
      unreadCount: 1,
      statusColor: Color(0xFFEAB308),
    ),
    _ChatItemData(
      name: 'Lucas',
      lastMessage: '¿Has escaneado ya mi QR?',
      time: '20:10',
      unreadCount: 0,
      statusColor: Color(0xFF22C55E),
    ),
    _ChatItemData(
      name: 'Paula',
      lastMessage: 'Estoy cerca de la barra',
      time: '19:53',
      unreadCount: 4,
      statusColor: Color(0xFFEAB308),
    ),
    _ChatItemData(
      name: 'Luna',
      lastMessage: 'Luego hacemos el reto si quieres',
      time: '19:20',
      unreadCount: 0,
      statusColor: Color(0xFFEF4444),
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_ChatItemData> get _filteredChats {
    final query = _searchController.text.trim().toLowerCase();

    if (query.isEmpty) return _allChats;

    return _allChats.where((chat) {
      return chat.name.toLowerCase().contains(query) ||
          chat.lastMessage.toLowerCase().contains(query);
    }).toList();
  }

  void _openPlaceholder(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chats = _filteredChats;

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Chats',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    _SquareHeaderButton(
                      icon: Icons.edit_outlined,
                      onTap: () => _openPlaceholder('Aquí irá crear chat'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  widget.isHost
                      ? 'Habla con tus invitados y sigue la actividad de la sala.'
                      : 'Habla con la gente de la sala y coordina retos.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.68),
                    fontSize: 14,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 20),
                _SearchInput(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 18),
                Expanded(
                  child: chats.isEmpty
                      ? const _EmptyChatsState()
                      : ListView.separated(
                          itemCount: chats.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final chat = chats[index];

                            return _ChatCard(
                              data: chat,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ChatConversationScreen(
                                      isHost: widget.isHost,
                                      chatName: chat.name,
                                      statusColor: chat.statusColor,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                ),
                const SizedBox(height: 10),
                VooBottomNavBar(
                  currentIndex: 1,
                  onTap: (index) {
                    if (index == 0) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => HomeScreen(isHost: widget.isHost),
                        ),
                      );
                    } else if (index == 1) {
                      return;
                    } else if (index == 2) {
                      _openPlaceholder('Aquí irá Ranking');
                    } else if (index == 3) {
                      _openPlaceholder('Aquí irá Retos');
                    } else if (index == 4) {
                      _openPlaceholder('Aquí irá Ajustes');
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

class _ChatItemData {
  final String name;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final Color statusColor;

  const _ChatItemData({
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.unreadCount,
    required this.statusColor,
  });
}

class _SquareHeaderButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _SquareHeaderButton({
    required this.icon,
    required this.onTap,
  });

  @override
  State<_SquareHeaderButton> createState() => _SquareHeaderButtonState();
}

class _SquareHeaderButtonState extends State<_SquareHeaderButton> {
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
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: const Color(0xFF151515),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: color,
            width: 2,
          ),
          boxShadow: _pressed
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.4),
                    blurRadius: 16,
                    spreadRadius: 1.4,
                  ),
                ]
              : [],
        ),
        child: Icon(
          widget.icon,
          color: color,
          size: 24,
        ),
      ),
    );
  }
}

class _SearchInput extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _SearchInput({
    required this.controller,
    required this.onChanged,
  });

  @override
  State<_SearchInput> createState() => _SearchInputState();
}

class _SearchInputState extends State<_SearchInput> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (value) {
        setState(() {
          _focused = value;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          boxShadow: _focused
              ? [
                  BoxShadow(
                    color: const Color(0xFF9C4DFF).withOpacity(0.22),
                    blurRadius: 18,
                    spreadRadius: 1,
                  ),
                ]
              : [],
        ),
        child: TextField(
          controller: widget.controller,
          onChanged: widget.onChanged,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
          decoration: InputDecoration(
            hintText: 'Buscar chat',
            hintStyle: TextStyle(
              color: Colors.white.withOpacity(0.42),
            ),
            prefixIcon: const Icon(
              Icons.search_rounded,
              color: Color(0xFF9C4DFF),
            ),
            filled: true,
            fillColor: const Color(0xFF151525),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 16,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(22),
              borderSide: BorderSide(
                color: const Color(0xFF9C4DFF).withOpacity(0.38),
                width: 1.6,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(22),
              borderSide: const BorderSide(
                color: Color(0xFF9C4DFF),
                width: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ChatCard extends StatefulWidget {
  final _ChatItemData data;
  final VoidCallback onTap;

  const _ChatCard({
    required this.data,
    required this.onTap,
  });

  @override
  State<_ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<_ChatCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final data = widget.data;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF151525),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: const Color(0xFFD78BFF).withOpacity(_pressed ? 0.9 : 0.45),
            width: _pressed ? 1.8 : 1.4,
          ),
          boxShadow: _pressed
              ? [
                  BoxShadow(
                    color: const Color(0xFF9C4DFF).withOpacity(0.22),
                    blurRadius: 18,
                    spreadRadius: 1,
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: data.statusColor,
                      width: 2.5,
                    ),
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                ),
                if (data.unreadCount > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      constraints: const BoxConstraints(
                        minWidth: 20,
                        minHeight: 20,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 2,
                      ),
                      decoration: const BoxDecoration(
                        color: Color(0xFF22C55E),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${data.unreadCount}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    data.lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.62),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  data.time,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.55),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.white38,
                  size: 22,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyChatsState extends StatelessWidget {
  const _EmptyChatsState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 22,
          vertical: 24,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF151525),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: const Color(0xFF9C4DFF).withOpacity(0.35),
            width: 1.4,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.chat_bubble_outline_rounded,
              color: Color(0xFF9C4DFF),
              size: 38,
            ),
            const SizedBox(height: 12),
            const Text(
              'No hay chats',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Cuando empieces a hablar con gente de la sala, aparecerá aquí.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.62),
                fontSize: 13,
                height: 1.35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}