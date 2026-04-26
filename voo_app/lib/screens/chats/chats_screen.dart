import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../mock/mock_chats.dart';
import '../../models/chat_model.dart';
import '../../models/chat_preview_state.dart';
import '../../state/app_state.dart';
import '../../widgets/voo_bottom_nav_bar.dart';
import '../home/home_screen.dart';
import 'chat_conversation_screen.dart';
import '../retos/retos_screen.dart';
import '../ranking/ranking_screen.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  Color _previewColor(ChatPreviewState state) {
    switch (state) {
      case ChatPreviewState.normal:
        return Colors.white54;
      case ChatPreviewState.missionBusy:
        return const Color(0xFFFF8FB1);
      case ChatPreviewState.answeredRequest:
        return const Color(0xFF52A9FF);
    }
  }

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
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Es ahora o Nunca!',
                  style: TextStyle(
                    color: Color(0xFFD78BFF),
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  appState.roomCode ?? '---',
                  style: const TextStyle(
                    color: Color(0xFF52A9FF),
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Tus chats',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
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
                          separatorBuilder: (_, __) => Container(
                            height: 1,
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            color: Colors.white.withOpacity(0.08),
                          ),
                          itemBuilder: (context, index) {
                            final ChatModel chat = chats[index];

                            return _ChatCard(
                              chat: chat,
                              isHost: isHost,
                              previewColor: _previewColor(chat.previewState),
                              showBlueDot:
                                  chat.previewState == ChatPreviewState.answeredRequest,
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
  final Color previewColor;
  final bool showBlueDot;

  const _ChatCard({
    required this.chat,
    required this.isHost,
    required this.previewColor,
    required this.showBlueDot,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (chat.previewState == ChatPreviewState.missionBusy) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${chat.userName} está en una misión ahora mismo ¡intenta con otro!',
              ),
            ),
          );
          return;
        }

        if (chat.previewState == ChatPreviewState.answeredRequest) {
          context.read<AppState>().markAnsweredRequestAsSeen(chat.id);
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
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
        color: Colors.transparent,
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
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
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chat.userName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    chat.lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: previewColor,
                      fontSize: 13,
                      fontWeight: chat.previewState == ChatPreviewState.normal
                          ? FontWeight.w500
                          : FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            if (showBlueDot)
              const CircleAvatar(
                radius: 4,
                backgroundColor: Color(0xFF52A9FF),
              ),
          ],
        ),
      ),
    );
  }
}