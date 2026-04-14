import 'package:flutter/material.dart';
import '../room_setup/room_setup_screen.dart';

class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen({super.key});

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  final TextEditingController question1Controller = TextEditingController();
  final TextEditingController question2Controller = TextEditingController();
  final TextEditingController question3Controller = TextEditingController();

  @override
  void dispose() {
    question1Controller.dispose();
    question2Controller.dispose();
    question3Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool canContinue =
        question1Controller.text.trim().isNotEmpty &&
        question2Controller.text.trim().isNotEmpty &&
        question3Controller.text.trim().isNotEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0B),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Preguntas rápidas',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFD78BFF),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Responde estas 3 preguntas para ver tu afinidad con otros invitados.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 26),

                  const _QuestionLabel(text: 'Pregunta rápida 1'),
                  const SizedBox(height: 10),
                  _QuestionInput(
                    controller: question1Controller,
                    hintText: 'Escribe tu respuesta',
                    onChanged: (_) => setState(() {}),
                  ),

                  const SizedBox(height: 20),

                  const _QuestionLabel(text: 'Pregunta rápida 2'),
                  const SizedBox(height: 10),
                  _QuestionInput(
                    controller: question2Controller,
                    hintText: 'Escribe tu respuesta',
                    onChanged: (_) => setState(() {}),
                  ),

                  const SizedBox(height: 20),

                  const _QuestionLabel(text: 'Pregunta rápida 3'),
                  const SizedBox(height: 10),
                  _QuestionInput(
                    controller: question3Controller,
                    hintText: 'Escribe tu respuesta',
                    onChanged: (_) => setState(() {}),
                  ),

                  const SizedBox(height: 30),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _RoundBackButton(
                        onTap: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 20),
                      _NextButton(
                        enabled: canContinue,
                        onTap: () {
                          if (!canContinue) return;

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RoomSetupScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _QuestionLabel extends StatelessWidget {
  final String text;

  const _QuestionLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _QuestionInput extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String> onChanged;

  const _QuestionInput({
    required this.controller,
    required this.hintText,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.white54,
        ),
        filled: true,
        fillColor: const Color(0xFF151515),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: Color(0xFFD78BFF),
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: Color(0xFFD78BFF),
            width: 2,
          ),
        ),
      ),
    );
  }
}

class _RoundBackButton extends StatelessWidget {
  final VoidCallback onTap;

  const _RoundBackButton({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF151515),
          border: Border.all(
            color: const Color.fromARGB(255, 62, 162, 255),
            width: 2,
          ),
        ),
        child: const Icon(
          Icons.arrow_back,
          color: Color.fromARGB(255, 62, 162, 255),
          size: 24,
        ),
      ),
    );
  }
}

class _NextButton extends StatefulWidget {
  final bool enabled;
  final VoidCallback onTap;

  const _NextButton({
    required this.enabled,
    required this.onTap,
  });

  @override
  State<_NextButton> createState() => _NextButtonState();
}

class _NextButtonState extends State<_NextButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final buttonColor = widget.enabled
        ? const Color.fromARGB(255, 44, 245, 117)
        : Colors.grey;

    return GestureDetector(
      onTapDown: (_) {
        if (widget.enabled) {
          setState(() => _pressed = true);
        }
      },
      onTapUp: (_) {
        if (widget.enabled) {
          setState(() => _pressed = false);
          widget.onTap();
        }
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF151515),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: buttonColor,
            width: 2,
          ),
          boxShadow: _pressed && widget.enabled
              ? [
                  BoxShadow(
                    color: buttonColor.withOpacity(0.55),
                    blurRadius: 18,
                    spreadRadius: 2,
                  ),
                ]
              : [],
        ),
        child: Text(
          'Siguiente',
          style: TextStyle(
            color: buttonColor,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}