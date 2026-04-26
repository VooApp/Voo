import 'package:flutter/material.dart';
import '../models/chat_model.dart';
import '../models/chat_preview_state.dart';

const List<ChatModel> mockChats = [
  ChatModel(
    id: '1',
    userName: 'Maria',
    lastMessage: 'Luego hacemos otro reto 👀',
    time: '20:45',
    unreadCount: 2,
    statusColor: Color(0xFF22C55E),
    previewState: ChatPreviewState.normal,
  ),
  ChatModel(
    id: '2',
    userName: 'Juan',
    lastMessage: 'JAJAJA brutal 😂',
    time: '19:12',
    unreadCount: 0,
    statusColor: Color(0xFFEAB308),
    previewState: ChatPreviewState.normal,
  ),
  ChatModel(
    id: '3',
    userName: 'Anna',
    lastMessage: 'Te toca verdad 😏',
    time: '18:30',
    unreadCount: 1,
    statusColor: Color(0xFFEF4444),
    previewState: ChatPreviewState.normal,
  ),
];