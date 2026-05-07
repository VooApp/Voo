import 'package:flutter/material.dart';

class TermsWebView extends StatelessWidget {
  final String htmlBase64;

  const TermsWebView({
    super.key,
    required this.htmlBase64,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Vista web no disponible en Android.',
        style: TextStyle(
          color: Colors.white70,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}