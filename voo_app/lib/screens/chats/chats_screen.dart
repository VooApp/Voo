import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../mock/mock_chats.dart';
import '../../models/chat_model.dart';
import '../../state/app_state.dart';
import '../../widgets/voo_bottom_nav_bar.dart';
import '../home/home_screen.dart';
import 'chat_conversation_screen.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final isHost = appState.isHost;

    final List<ChatModel> chats = appState.buildChatsList(mockChats);

    void openPlaceholder(String text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(text)),
      );
    }

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
                const Text(
                  'Chats',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 18),
                Expanded(
                  child: chats.isEmpty
                      ? Center(
                          child: Text(
                            'Todavía no tienes conversaciones',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.62),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      : ListView.separated(
                          itemCount: chats.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final ChatModel chat = chats[index];
                            final bool isPendingBlocked =
                                appState.isPendingOutgoingChat(chat.id);

                            return _ChatCard(
                              chat: chat,
                              isHost: isHost,
                              isPendingBlocked: isPendingBlocked,
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
                          builder: (_) => const HomeScreen(),
                        ),
                      );
                    } else if (index == 1) {
                      return;
                    } else if (index == 2) {
                      openPlaceholder('Aquí irá Ranking');
                    } else if (index == 3) {
                      openPlaceholder('Aquí irá Retos');
                    } else if (index == 4) {
                      openPlaceholder('Aquí irá Ajustes');
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

class _ChatCard extends StatelessWidget {
  final ChatModel chat;
  final bool isHost;
  final bool isPendingBlocked;

  const _ChatCard({
    required this.chat,
    required this.isHost,
    required this.isPendingBlocked,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isPendingBlocked) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${chat.userName} está en una misión ahora mismo ¡intenta con otro!',
              ),
            ),
          );
          return;
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChatConversationScreen(
              isHost: isHost,
              chatId: chat.id,
              chatName: chat.userName,
              statusColor: chat.statusColor,
            ),
          ),
        );
      },
      child: Opacity(
        opacity: isPendingBlocked ? 0.85 : 1,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFF151525),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFFD78BFF).withOpacity(0.5),
              width: 1.4,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: chat.statusColor,
                    width: 2.4,
                  ),
                ),
                child: const Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chat.userName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      chat.lastMessage,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: isPendingBlocked
                            ? const Color(0xFFEAB308)
                            : Colors.white.withOpacity(0.62),
                        fontSize: 13,
                        fontWeight:
                            isPendingBlocked ? FontWeight.w700 : FontWeight.w400,
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
                    chat.time,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.55),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (chat.unreadCount > 0) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 3,
                      ),
                      decoration: const BoxDecoration(
                        color: Color(0xFF22C55E),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${chat.unreadCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}