import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'camera_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController instagramController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  Uint8List? _profileImageBytes;
  bool _isPickingImage = false;

  @override
  void dispose() {
    nameController.dispose();
    birthDateController.dispose();
    instagramController.dispose();
    super.dispose();
  }

  bool get canContinue {
    return nameController.text.trim().isNotEmpty &&
        birthDateController.text.trim().isNotEmpty &&
        _profileImageBytes != null;
  }

  Future<void> _pickProfileImage(ImageSource source) async {
    try {
      setState(() {
        _isPickingImage = true;
      });

      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 85,
      );

      if (pickedFile == null) {
        return;
      }

      final Uint8List bytes = await pickedFile.readAsBytes();

      if (!mounted) return;

      setState(() {
        _profileImageBytes = bytes;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Foto de perfil añadida'),
        ),
      );
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo seleccionar la imagen'),
        ),
      );
    } finally {
      if (!mounted) return;

      setState(() {
        _isPickingImage = false;
      });
    }
  }

  void _showImageSourcePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF151515),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Añadir foto de perfil',
                  style: TextStyle(
                    color: Color(0xFFD78BFF),
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _SourceButton(
                      icon: Icons.photo_library_outlined,
                      label: 'Galería',
                      color: const Color.fromARGB(255, 62, 162, 255),
                      onTap: () {
                        Navigator.pop(context);
                        _pickProfileImage(ImageSource.gallery);
                      },
                    ),
                    const SizedBox(width: 16),
                    _SourceButton(
                      icon: Icons.camera_alt_outlined,
                      label: 'Cámara',
                      color: const Color.fromARGB(255, 44, 245, 117),
                      onTap: () {
                        Navigator.pop(context);
                        _pickProfileImage(ImageSource.camera);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickBirthDate() async {
    FocusScope.of(context).unfocus();

    final DateTime now = DateTime.now();
    final DateTime initialDate = DateTime(now.year - 18, now.month, now.day);

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1950),
      lastDate: now,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      helpText: 'Selecciona tu fecha',
      cancelText: 'Cancelar',
      confirmText: 'Aceptar',
      fieldHintText: 'dd/mm/aaaa',
      fieldLabelText: 'Fecha de nacimiento',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogBackgroundColor: const Color(0xFF151515),
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFD78BFF),
              onPrimary: Colors.black,
              surface: Color(0xFF151515),
              onSurface: Colors.white,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 44, 245, 117),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            datePickerTheme: DatePickerThemeData(
              backgroundColor: const Color(0xFF151515),
              surfaceTintColor: Colors.transparent,
              headerBackgroundColor: const Color(0xFF101010),
              headerForegroundColor: const Color(0xFFD78BFF),
              weekdayStyle: const TextStyle(color: Colors.white70),
              dayStyle: const TextStyle(color: Colors.white),
              yearStyle: const TextStyle(color: Colors.white),
              todayForegroundColor: const WidgetStatePropertyAll(
                Color.fromARGB(255, 62, 162, 255),
              ),
              todayBorder: const BorderSide(
                color: Color.fromARGB(255, 62, 162, 255),
              ),
              dayForegroundColor: const WidgetStatePropertyAll(Colors.white),
              dayBackgroundColor: const WidgetStatePropertyAll(Colors.transparent),
              dayOverlayColor: WidgetStatePropertyAll(
                const Color(0xFFD78BFF).withOpacity(0.15),
              ),
              dayShape: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return const CircleBorder();
                }
                return const CircleBorder();
              }),
              yearForegroundColor: const WidgetStatePropertyAll(Colors.white),
              yearBackgroundColor: const WidgetStatePropertyAll(Colors.transparent),
              rangePickerBackgroundColor: const Color(0xFF151515),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate == null) return;

    final String formatted =
        '${pickedDate.day.toString().padLeft(2, '0')}/'
        '${pickedDate.month.toString().padLeft(2, '0')}/'
        '${pickedDate.year}';

    setState(() {
      birthDateController.text = formatted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0B),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Primero te vamos a Registrar',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFD78BFF),
                    ),
                  ),
                  const SizedBox(height: 26),

                  _VooInput(
                    controller: nameController,
                    hintText: 'Nombre',
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 14),

                  _VooInput(
                    controller: birthDateController,
                    hintText: 'Fecha de nacimiento',
                    readOnly: true,
                    onTap: _pickBirthDate,
                    suffixIcon: const Icon(
                      Icons.calendar_month_outlined,
                      color: Color.fromARGB(255, 62, 162, 255),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 24),

                  GestureDetector(
                    onTap: _isPickingImage ? null : _showImageSourcePicker,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF151515),
                        border: Border.all(
                          color: _profileImageBytes != null
                              ? const Color.fromARGB(255, 44, 245, 117)
                              : const Color(0xFFD78BFF),
                          width: 2,
                        ),
                        boxShadow: _profileImageBytes != null
                            ? [
                                BoxShadow(
                                  color:
                                      const Color.fromARGB(255, 44, 245, 117)
                                          .withOpacity(0.45),
                                  blurRadius: 16,
                                  spreadRadius: 2,
                                ),
                              ]
                            : [],
                      ),
                      child: ClipOval(
                        child: _isPickingImage
                            ? const Center(
                                child: SizedBox(
                                  width: 28,
                                  height: 28,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Color.fromARGB(255, 44, 245, 117),
                                    ),
                                  ),
                                ),
                              )
                            : _profileImageBytes != null
                                ? Image.memory(
                                    _profileImageBytes!,
                                    fit: BoxFit.cover,
                                    width: 120,
                                    height: 120,
                                  )
                                : const Icon(
                                    Icons.person_outline,
                                    size: 56,
                                    color: Colors.white,
                                  ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Text(
                    _profileImageBytes != null
                        ? 'Foto de perfil añadida'
                        : 'Añade tu foto de Perfil',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _VooInput(
                    controller: instagramController,
                    hintText: 'Ig (opcional)',
                    onChanged: (_) {},
                  ),
                  const SizedBox(height: 12),

                  if (!canContinue)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        'Completa nombre, fecha de nacimiento y foto de perfil para continuar.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ),

                  const SizedBox(height: 18),

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

                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => const _CameraPermissionDialog(),
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

class _VooInput extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String> onChanged;
  final bool readOnly;
  final VoidCallback? onTap;
  final Widget? suffixIcon;

  const _VooInput({
    required this.controller,
    required this.hintText,
    required this.onChanged,
    this.readOnly = false,
    this.onTap,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      readOnly: readOnly,
      onTap: onTap,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.white54,
        ),
        suffixIcon: suffixIcon,
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

class _SourceButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _SourceButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: 130,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF101010),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color, width: 2),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
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
  final VoidCallback onTap;
  final bool enabled;

  const _NextButton({
    required this.onTap,
    required this.enabled,
  });

  @override
  State<_NextButton> createState() => _NextButtonState();
}

class _NextButtonState extends State<_NextButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final Color buttonColor = widget.enabled
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

class _CameraPermissionDialog extends StatelessWidget {
  const _CameraPermissionDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
        decoration: BoxDecoration(
          color: const Color(0xFF151515),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: const Color(0xFFD78BFF),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.camera_alt_outlined,
              size: 42,
              color: Colors.white,
            ),
            const SizedBox(height: 18),
            const Text(
              'Necesitamos permisos para acceder a tu cámara para comprobar que eres tú.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                height: 1.4,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _DialogActionButton(
                  label: 'Denegar',
                  color: const Color(0xFFEF4444),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(width: 14),
                _DialogActionButton(
                  label: 'Permitir',
                  color: const Color.fromARGB(255, 44, 245, 117),
                  onTap: () {
                    Navigator.pop(context);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CameraScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DialogActionButton extends StatefulWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _DialogActionButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  State<_DialogActionButton> createState() => _DialogActionButtonState();
}

class _DialogActionButtonState extends State<_DialogActionButton> {
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
        decoration: BoxDecoration(
          color: const Color(0xFF101010),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: widget.color,
            width: 2,
          ),
          boxShadow: _pressed
              ? [
                  BoxShadow(
                    color: widget.color.withOpacity(0.55),
                    blurRadius: 16,
                    spreadRadius: 2,
                  ),
                ]
              : [],
        ),
        child: Text(
          widget.label,
          style: TextStyle(
            color: widget.color,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}