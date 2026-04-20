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
                    'Creemos la sala',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFD78BFF),
                    ),
                  ),
                  const SizedBox(height: 24),

                  const _SectionTitle(text: 'Nombre de la sala'),
                  const SizedBox(height: 10),
                  _VooInput(
                    controller: roomNameController,
                    hintText: 'Escribe el nombre de la sala',
                    onChanged: (_) => setState(() {}),
                  ),

                  const SizedBox(height: 22),

                  const _SectionTitle(text: 'Contexto'),
                  const SizedBox(height: 12),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _OptionChip(
                        label: 'Pool Party',
                        isSelected: selectedContext == 'pool_party',
                        color: const Color(0xFFD78BFF),
                        onTap: () {
                          setState(() {
                            selectedContext = 'pool_party';
                          });
                        },
                      ),
                      _OptionChip(
                        label: 'Cena formal',
                        isSelected: selectedContext == 'cena_formal',
                        color: const Color(0xFFD78BFF),
                        onTap: () {
                          setState(() {
                            selectedContext = 'cena_formal';
                          });
                        },
                      ),
                      _OptionChip(
                        label: 'Reunión informal',
                        isSelected: selectedContext == 'reunion_informal',
                        color: const Color(0xFFD78BFF),
                        onTap: () {
                          setState(() {
                            selectedContext = 'reunion_informal';
                          });
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),

                  const _SectionTitle(text: 'Aforo'),
                  const SizedBox(height: 12),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _OptionChip(
                        label: '15-30',
                        isSelected: selectedCapacity == '15_30',
                        color: const Color.fromARGB(255, 44, 245, 117),
                        onTap: () {
                          setState(() {
                            selectedCapacity = '15_30';
                          });
                        },
                      ),
                      _OptionChip(
                        label: '30-50',
                        isSelected: selectedCapacity == '30_50',
                        color: const Color.fromARGB(255, 44, 245, 117),
                        onTap: () {
                          setState(() {
                            selectedCapacity = '30_50';
                          });
                        },
                      ),
                      _OptionChip(
                        label: '+50',
                        isSelected: selectedCapacity == '50_plus',
                        color: const Color.fromARGB(255, 44, 245, 117),
                        onTap: () {
                          setState(() {
                            selectedCapacity = '50_plus';
                          });
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),

                  const _SectionTitle(text: 'Dirección'),
                  const SizedBox(height: 10),
                  _VooInput(
                    controller: addressController,
                    hintText: 'Escribe la dirección',
                    onChanged: (_) => setState(() {}),
                  ),

                  const SizedBox(height: 18),

                  const _SectionTitle(text: 'CP'),
                  const SizedBox(height: 10),
                  _VooInput(
                    controller: cpController,
                    hintText: 'Código postal',
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                  ),

                  const SizedBox(height: 22),

                  const _SectionTitle(
                    text: 'Premio mayor para el invitado ganador',
                  ),
                  const SizedBox(height: 10),
                  _VooInput(
                    controller: grandPrizeController,
                    hintText: 'Ej: Sorpresa',
                    onChanged: (_) => setState(() {}),
                  ),

                  const SizedBox(height: 22),

                  const _SectionTitle(text: 'Premios para retos flash'),
                  const SizedBox(height: 10),

                  ...List.generate(flashPrizeControllers.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _VooInput(
                        controller: flashPrizeControllers[index],
                        hintText: 'Premio flash ${index + 1}',
                        onChanged: (_) => setState(() {}),
                      ),
                    );
                  }),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _AddButton(
                        onTap: _addFlashPrizeField,
                      ),
                    ],
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
                              builder: (_) => const RoomCodeScreen(),
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
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _VooInput extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
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

class _OptionChip extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF151515),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: color,
            width: isSelected ? 3 : 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.45),
                    blurRadius: 16,
                    spreadRadius: 2,
                  ),
                ]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  final VoidCallback onTap;

  const _AddButton({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: const Color(0xFF151515),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color.fromARGB(255, 44, 245, 117),
            width: 2,
          ),
        ),
        child: const Icon(
          Icons.add,
          color: Color.fromARGB(255, 44, 245, 117),
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