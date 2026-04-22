import 'package:flutter/material.dart';

class ChatModel {
  final String id;
  final String userName;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final Color statusColor;

  const ChatModel({
    required this.id,
    required this.userName,
    required this.lastMessage,
    required this.time,
    required this.unreadCount,
    required this.statusColor,
  });
}