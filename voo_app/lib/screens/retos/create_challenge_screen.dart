import 'package:flutter/material.dart';

class CreateChallengeScreen extends StatefulWidget {
  const CreateChallengeScreen({super.key});

  @override
  State<CreateChallengeScreen> createState() => _CreateChallengeScreenState();
}

class _CreateChallengeScreenState extends State<CreateChallengeScreen> {
  final TextEditingController retoController = TextEditingController();
  final TextEditingController horaDuracionController = TextEditingController();
  final TextEditingController premioController = TextEditingController();

  final List<String> durationOptions = ['30 min', '1 h', '2 h'];
  String selectedDuration = '30 min';
  Color selectedColor = const Color(0xFF9C4DFF);

  @override
  void dispose() {
    retoController.dispose();
    horaDuracionController.dispose();
    premioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canCreate =
        retoController.text.trim().isNotEmpty &&
        horaDuracionController.text.trim().isNotEmpty;

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
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Tus retos ',
                        style: TextStyle(
                          color: Color(0xFFD78BFF),
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      TextSpan(
                        text: 'V',
                        style: TextStyle(
                          color: Color(0xFF22C55E),
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      TextSpan(
                        text: 'o',
                        style: TextStyle(
                          color: Color(0xFFEF4444),
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      TextSpan(
                        text: 'o',
                        style: TextStyle(
                          color: Color(0xFFEAB308),
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Reto',
                  style: TextStyle(
                    color: Color(0xFFD78BFF),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                _StyledInput(
                  controller: retoController,
                  maxLines: 4,
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 18),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _ColorSelector(
                        selectedColor: selectedColor,
                        onColorSelected: (color) {
                          setState(() {
                            selectedColor = color;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _RewardSelector(
                        controller: premioController,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Hora de duración',
                            style: TextStyle(
                              color: Color(0xFFD78BFF),
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _StyledInput(
                            controller: horaDuracionController,
                            onChanged: (_) => setState(() {}),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
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
}

class _StyledInput extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final int maxLines;

  const _StyledInput({
    required this.controller,
    this.onChanged,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      maxLines: maxLines,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 15,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFF151525),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: const Color(0xFF9C4DFF).withOpacity(0.6),
            width: 1.6,
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
    );
  }
}

class _ColorSelector extends StatelessWidget {
  final Color selectedColor;
  final ValueChanged<Color> onColorSelected;

  const _ColorSelector({
    required this.selectedColor,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    const colors = [
      Color(0xFF22C55E),
      Color(0xFFEAB308),
      Color(0xFFEF4444),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Color',
          style: TextStyle(
            color: Color(0xFFD78BFF),
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          children: colors.map((color) {
            final selected = selectedColor == color;
            return GestureDetector(
              onTap: () => onColorSelected(color),
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: selected ? Colors.white : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _RewardSelector extends StatelessWidget {
  final TextEditingController controller;

  const _RewardSelector({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Añadir premio',
          style: TextStyle(
            color: Color(0xFFD78BFF),
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        _StyledInput(controller: controller),
      ],
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
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: const Color(0xFF151525),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xFF9C4DFF).withOpacity(0.6),
              width: 1.6,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedDuration,
              dropdownColor: const Color(0xFF151525),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
              iconEnabledColor: const Color(0xFFD78BFF),
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
          boxShadow: _pressed
              ? [
                  BoxShadow(
                    color: widget.color.withOpacity(0.28),
                    blurRadius: 16,
                    spreadRadius: 1,
                  ),
                ]
              : [],
        ),
        child: Icon(
          widget.icon,
          color: widget.color,
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
    final color = widget.enabled ? const Color(0xFF22C55E) : Colors.grey;

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
          color: const Color(0xFF151525),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: color,
            width: 2,
          ),
          boxShadow: _pressed && widget.enabled
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.35),
                    blurRadius: 16,
                    spreadRadius: 1,
                  ),
                ]
              : [],
        ),
        child: Text(
          'Crear',
          style: TextStyle(
            color: color,
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}