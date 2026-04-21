import 'package:flutter/material.dart';
import 'room_code_screen.dart';

class RoomSetupScreen extends StatefulWidget {
  const RoomSetupScreen({super.key});

  @override
  State<RoomSetupScreen> createState() => _RoomSetupScreenState();
}

class _RoomSetupScreenState extends State<RoomSetupScreen> {
  final TextEditingController roomNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cpController = TextEditingController();
  final TextEditingController grandPrizeController = TextEditingController();

  final List<TextEditingController> flashPrizeControllers = [
    TextEditingController(),
  ];

  String? selectedContext;
  String? selectedCapacity;

  @override
  void dispose() {
    roomNameController.dispose();
    addressController.dispose();
    cpController.dispose();
    grandPrizeController.dispose();

    for (final controller in flashPrizeControllers) {
      controller.dispose();
    }

    super.dispose();
  }

  void _addFlashPrizeField() {
    if (flashPrizeControllers.length >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Solo puedes añadir hasta 5 premios flash'),
        ),
      );
      return;
    }

    setState(() {
      flashPrizeControllers.add(TextEditingController());
    });
  }

  void _removeFlashPrizeField(int index) {
    if (index <= 0 || index >= flashPrizeControllers.length) return;

    setState(() {
      final controller = flashPrizeControllers.removeAt(index);
      controller.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool canContinue =
        roomNameController.text.trim().isNotEmpty &&
        selectedContext != null &&
        selectedCapacity != null &&
        addressController.text.trim().isNotEmpty &&
        cpController.text.trim().isNotEmpty &&
        grandPrizeController.text.trim().isNotEmpty;

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
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        _RoundBackButton(
                          onTap: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Creemos la sala',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Configura tu sala y añade los datos principales del evento.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.68),
                        fontSize: 14,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 28),

                    const _SectionTitle(text: 'Nombre de la sala'),
                    const SizedBox(height: 10),
                    _VooInput(
                      controller: roomNameController,
                      hintText: 'Escribe el nombre de la sala',
                      onChanged: (_) => setState(() {}),
                    ),

                    const SizedBox(height: 24),

                    const _SectionTitle(text: 'Contexto'),
                    const SizedBox(height: 12),
                    Wrap(
                      alignment: WrapAlignment.start,
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _OptionChip(
                          label: 'Pool Party',
                          isSelected: selectedContext == 'pool_party',
                          color: const Color(0xFF9C4DFF),
                          onTap: () {
                            setState(() {
                              selectedContext = 'pool_party';
                            });
                          },
                        ),
                        _OptionChip(
                          label: 'Cena formal',
                          isSelected: selectedContext == 'cena_formal',
                          color: const Color(0xFF9C4DFF),
                          onTap: () {
                            setState(() {
                              selectedContext = 'cena_formal';
                            });
                          },
                        ),
                        _OptionChip(
                          label: 'Reunión informal',
                          isSelected: selectedContext == 'reunion_informal',
                          color: const Color(0xFF9C4DFF),
                          onTap: () {
                            setState(() {
                              selectedContext = 'reunion_informal';
                            });
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    const _SectionTitle(text: 'Aforo'),
                    const SizedBox(height: 12),
                    Wrap(
                      alignment: WrapAlignment.start,
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _OptionChip(
                          label: '15-30',
                          isSelected: selectedCapacity == '15_30',
                          color: const Color(0xFF22C55E),
                          onTap: () {
                            setState(() {
                              selectedCapacity = '15_30';
                            });
                          },
                        ),
                        _OptionChip(
                          label: '30-50',
                          isSelected: selectedCapacity == '30_50',
                          color: const Color(0xFF22C55E),
                          onTap: () {
                            setState(() {
                              selectedCapacity = '30_50';
                            });
                          },
                        ),
                        _OptionChip(
                          label: '+50',
                          isSelected: selectedCapacity == '50_plus',
                          color: const Color(0xFF22C55E),
                          onTap: () {
                            setState(() {
                              selectedCapacity = '50_plus';
                            });
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    const _SectionTitle(text: 'Dirección'),
                    const SizedBox(height: 10),
                    _VooInput(
                      controller: addressController,
                      hintText: 'Escribe la dirección',
                      onChanged: (_) => setState(() {}),
                    ),

                    const SizedBox(height: 20),

                    const _SectionTitle(text: 'CP'),
                    const SizedBox(height: 10),
                    _VooInput(
                      controller: cpController,
                      hintText: 'Código postal',
                      keyboardType: TextInputType.number,
                      onChanged: (_) => setState(() {}),
                    ),

                    const SizedBox(height: 24),

                    const _SectionTitle(
                      text: 'Premio mayor para el invitado ganador',
                    ),
                    const SizedBox(height: 10),
                    _VooInput(
                      controller: grandPrizeController,
                      hintText: 'Ej: Sorpresa',
                      onChanged: (_) => setState(() {}),
                    ),

                    const SizedBox(height: 24),

                    const _SectionTitle(text: 'Premios para retos flash'),
                    const SizedBox(height: 10),

                    ...List.generate(flashPrizeControllers.length, (index) {
                      final isRemovable = index > 0;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: _VooInput(
                                controller: flashPrizeControllers[index],
                                hintText: 'Premio flash ${index + 1}',
                                onChanged: (_) => setState(() {}),
                              ),
                            ),
                            if (isRemovable) ...[
                              const SizedBox(width: 10),
                              _RemoveButton(
                                onTap: () => _removeFlashPrizeField(index),
                              ),
                            ],
                          ],
                        ),
                      );
                    }),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: _AddButton(
                        onTap: _addFlashPrizeField,
                      ),
                    ),

                    const SizedBox(height: 30),

                    Align(
                      alignment: Alignment.centerRight,
                      child: _NextButton(
                        enabled: canContinue,
                        onTap: () {
                          if (!canContinue) return;

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RoomCodeScreen(
                                isHost: true,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;

  const _SectionTitle({required this.text});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _VooInput extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final ValueChanged<String> onChanged;

  const _VooInput({
    required this.controller,
    required this.hintText,
    required this.onChanged,
    this.keyboardType,
  });

  @override
  State<_VooInput> createState() => _VooInputState();
}

class _VooInputState extends State<_VooInput> {
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
          keyboardType: widget.keyboardType,
          onChanged: widget.onChanged,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(
              color: Colors.white.withOpacity(0.42),
              fontSize: 15,
            ),
            filled: true,
            fillColor: const Color(0xFF151525),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 18,
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

class _OptionChip extends StatefulWidget {
  final String label;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _OptionChip({
    required this.label,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  State<_OptionChip> createState() => _OptionChipState();
}

class _OptionChipState extends State<_OptionChip> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.isSelected || _pressed;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: active
              ? widget.color.withOpacity(0.16)
              : const Color(0xFF151515),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: active ? widget.color : widget.color.withOpacity(0.45),
            width: active ? 2.4 : 1.6,
          ),
          boxShadow: active
              ? [
                  BoxShadow(
                    color: widget.color.withOpacity(0.28),
                    blurRadius: 16,
                    spreadRadius: 1,
                  ),
                ]
              : [],
        ),
        child: Text(
          widget.label,
          style: TextStyle(
            color: active ? Colors.white : widget.color,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _AddButton extends StatefulWidget {
  final VoidCallback onTap;

  const _AddButton({
    required this.onTap,
  });

  @override
  State<_AddButton> createState() => _AddButtonState();
}

class _AddButtonState extends State<_AddButton> {
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
          color: const Color(0xFF151515),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0xFF22C55E),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF22C55E).withOpacity(_pressed ? 0.38 : 0.18),
              blurRadius: _pressed ? 18 : 10,
              spreadRadius: _pressed ? 1.5 : 0.4,
            ),
          ],
        ),
        child: const Icon(
          Icons.add,
          color: Color(0xFF22C55E),
        ),
      ),
    );
  }
}

class _RemoveButton extends StatefulWidget {
  final VoidCallback onTap;

  const _RemoveButton({
    required this.onTap,
  });

  @override
  State<_RemoveButton> createState() => _RemoveButtonState();
}

class _RemoveButtonState extends State<_RemoveButton> {
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
          color: const Color(0xFF151515),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0xFFEF4444),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFEF4444).withOpacity(_pressed ? 0.34 : 0.16),
              blurRadius: _pressed ? 18 : 10,
              spreadRadius: _pressed ? 1.4 : 0.3,
            ),
          ],
        ),
        child: const Icon(
          Icons.remove,
          color: Color(0xFFEF4444),
        ),
      ),
    );
  }
}

class _RoundBackButton extends StatefulWidget {
  final VoidCallback onTap;

  const _RoundBackButton({
    required this.onTap,
  });

  @override
  State<_RoundBackButton> createState() => _RoundBackButtonState();
}

class _RoundBackButtonState extends State<_RoundBackButton> {
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
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF3B1452),
              Color(0xFF24103A),
            ],
          ),
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0xFF7E2BE8),
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
          size: 20,
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
        ? const Color(0xFF22C55E)
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
          boxShadow: widget.enabled
              ? [
                  BoxShadow(
                    color: buttonColor.withOpacity(_pressed ? 0.55 : 0.22),
                    blurRadius: _pressed ? 18 : 12,
                    spreadRadius: _pressed ? 2 : 0.5,
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