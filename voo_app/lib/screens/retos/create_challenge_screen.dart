import 'package:flutter/material.dart';

class CreateChallengeScreen extends StatefulWidget {
  const CreateChallengeScreen({super.key});

  @override
  State<CreateChallengeScreen> createState() => _CreateChallengeScreenState();
}

class _CreateChallengeScreenState extends State<CreateChallengeScreen> {
  final TextEditingController retoController = TextEditingController();
  final TextEditingController puntosController = TextEditingController();
  final TextEditingController premioController = TextEditingController();

  final List<String> durationOptions = ['30 min', '1 h', '2 h'];
  String selectedDuration = '30 min';

  @override
  void dispose() {
    retoController.dispose();
    puntosController.dispose();
    premioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canCreate =
        retoController.text.trim().isNotEmpty &&
        puntosController.text.trim().isNotEmpty;

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
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: _ChallengeTitle(),
                ),

                const SizedBox(height: 26),

                const Text(
                  'Reto',
                  style: TextStyle(
                    color: Color(0xFFD78BFF),
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                _StyledInput(
                  controller: retoController,
                  maxLines: 5,
                  onChanged: (_) => setState(() {}),
                ),

                const SizedBox(height: 24),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 120,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Puntos',
                            style: TextStyle(
                              color: Color(0xFFD78BFF),
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _StyledInput(
                            controller: puntosController,
                            keyboardType: TextInputType.number,
                            onChanged: (_) => setState(() {}),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Añade un premio',
                          style: TextStyle(
                            color: Color(0xFFD78BFF),
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _AddPrizeButton(
                          onTap: () {
                            _showPrizeDialog(context);
                          },
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _StyledInput(
                        controller: premioController,
                        hintText: 'Premio',
                      ),
                    ),

                    const SizedBox(width: 18),

                    SizedBox(
                      width: 130,
                      child: _DurationDropdown(
                        selectedDuration: selectedDuration,
                        options: durationOptions,
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() {
                            selectedDuration = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _CircleIconButton(
                      color: const Color(0xFF52A9FF),
                      icon: Icons.arrow_back_rounded,
                      onTap: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 18),
                    _CreateButton(
                      enabled: canCreate,
                      onTap: () {
                        if (!canCreate) return;

                        Navigator.pop(context);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Reto creado'),
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
    );
  }

  void _showPrizeDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: const Color(0xFF151525),
          title: const Text(
            'Añadir premio',
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            controller: premioController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Ej: 1 copa, elegir reto, premio especial...',
              hintStyle: TextStyle(color: Colors.white54),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {});
              },
              child: const Text(
                'Guardar',
                style: TextStyle(color: Color(0xFF66D63E)),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ChallengeTitle extends StatelessWidget {
  const _ChallengeTitle();

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          const TextSpan(
            text: 'Tus retos ',
            style: TextStyle(
              color: Color(0xFFD78BFF),
              fontSize: 32,
              fontWeight: FontWeight.w900,
            ),
          ),
          TextSpan(
            text: 'V',
            style: TextStyle(
              color: const Color(0xFF66D63E),
              fontSize: 34,
              fontWeight: FontWeight.w900,
              shadows: [
                Shadow(
                  color: const Color(0xFF66D63E).withOpacity(0.85),
                  blurRadius: 14,
                ),
              ],
            ),
          ),
          TextSpan(
            text: 'o',
            style: TextStyle(
              color: const Color(0xFFEAB308),
              fontSize: 34,
              fontWeight: FontWeight.w900,
              shadows: [
                Shadow(
                  color: const Color(0xFFEAB308).withOpacity(0.85),
                  blurRadius: 14,
                ),
              ],
            ),
          ),
          TextSpan(
            text: 'o',
            style: TextStyle(
              color: const Color(0xFFFF3B5C),
              fontSize: 34,
              fontWeight: FontWeight.w900,
              shadows: [
                Shadow(
                  color: const Color(0xFFFF3B5C).withOpacity(0.85),
                  blurRadius: 14,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StyledInput extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final int maxLines;
  final TextInputType? keyboardType;
  final String? hintText;

  const _StyledInput({
    required this.controller,
    this.onChanged,
    this.maxLines = 1,
    this.keyboardType,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 15,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.white.withOpacity(0.35),
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
            color: const Color(0xFF9C4DFF).withOpacity(0.65),
            width: 1.8,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: Color(0xFF9C4DFF),
            width: 2.2,
          ),
        ),
      ),
    );
  }
}

class _AddPrizeButton extends StatelessWidget {
  final VoidCallback onTap;

  const _AddPrizeButton({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF151525),
          border: Border.all(
            color: const Color(0xFF9C4DFF),
            width: 2.4,
          ),
        ),
        child: const Icon(
          Icons.add_rounded,
          color: Color(0xFF9C4DFF),
          size: 30,
        ),
      ),
    );
  }
}

class _DurationDropdown extends StatelessWidget {
  final String selectedDuration;
  final List<String> options;
  final ValueChanged<String?> onChanged;

  const _DurationDropdown({
    required this.selectedDuration,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Duración',
          style: TextStyle(
            color: Color(0xFFD78BFF),
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF151525),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xFF9C4DFF).withOpacity(0.65),
              width: 1.8,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedDuration,
              dropdownColor: const Color(0xFF151525),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
              iconEnabledColor: const Color(0xFFD78BFF),
              isExpanded: true,
              items: options.map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}

class _CircleIconButton extends StatefulWidget {
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIconButton({
    required this.color,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_CircleIconButton> createState() => _CircleIconButtonState();
}

class _CircleIconButtonState extends State<_CircleIconButton> {
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
        width: 54,
        height: 54,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF151525),
          border: Border.all(
            color: widget.color,
            width: 2,
          ),
        ),
        child: Icon(
          widget.icon,
          color: widget.color,
          size: 30,
        ),
      ),
    );
  }
}

class _CreateButton extends StatefulWidget {
  final bool enabled;
  final VoidCallback onTap;

  const _CreateButton({
    required this.enabled,
    required this.onTap,
  });

  @override
  State<_CreateButton> createState() => _CreateButtonState();
}

class _CreateButtonState extends State<_CreateButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.enabled ? const Color(0xFF66D63E) : Colors.grey;

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
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 13),
        decoration: BoxDecoration(
          color: const Color(0xFF151525),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: color,
            width: 2.2,
          ),
        ),
        child: Text(
          'Crear',
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}