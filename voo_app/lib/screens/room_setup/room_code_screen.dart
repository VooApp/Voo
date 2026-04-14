import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:universal_html/html.dart' as html;

class RoomCodeScreen extends StatefulWidget {
  const RoomCodeScreen({super.key});

  @override
  State<RoomCodeScreen> createState() => _RoomCodeScreenState();
}

class _RoomCodeScreenState extends State<RoomCodeScreen> {
  static const String roomCode = 'CV 7624X5';

  final GlobalKey _downloadCardKey = GlobalKey();

  bool _copied = false;
  bool _sharing = false;
  bool _downloading = false;

  Future<void> _copyCode() async {
    await Clipboard.setData(const ClipboardData(text: roomCode));

    if (!mounted) return;

    setState(() {
      _copied = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Código copiado'),
      ),
    );

    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    setState(() {
      _copied = false;
    });
  }

  Future<void> _shareCode() async {
    if (_sharing) return;

    setState(() {
      _sharing = true;
    });

    try {
      final result = await SharePlus.instance.share(
        ShareParams(
          text: 'Únete a mi sala de VOO con este código: $roomCode',
          subject: 'Código de sala VOO',
          title: 'Compartir código de sala',
        ),
      );

      if (mounted && result.status == ShareResultStatus.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Código compartido'),
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo compartir el código'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _sharing = false;
        });
      }
    }
  }

  Future<void> _downloadCodeCard() async {
    if (_downloading) return;

    setState(() {
      _downloading = true;
    });

    try {
      await Future.delayed(const Duration(milliseconds: 50));
      await WidgetsBinding.instance.endOfFrame;

      final boundary =
          _downloadCardKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;

      if (boundary == null) {
        throw Exception('No se encontró la tarjeta para descargar');
      }

      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (byteData == null) {
        throw Exception('No se pudo generar el PNG');
      }

      final Uint8List pngBytes = byteData.buffer.asUint8List();

      final blob = html.Blob([pngBytes], 'image/png');
      final url = html.Url.createObjectUrlFromBlob(blob);

      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', 'codigo_sala_voo.png')
        ..click();

      html.Url.revokeObjectUrl(url);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tarjeta PNG descargada'),
        ),
      );
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo descargar el PNG'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _downloading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color accentColor = _copied
        ? const Color.fromARGB(255, 44, 245, 117)
        : const Color(0xFFD78BFF);

    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0B),
      body: Stack(
        children: [
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Código de Sala',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFD78BFF),
                        ),
                      ),
                      const SizedBox(height: 24),

                      GestureDetector(
                        onTap: _copyCode,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 28,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF151515),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: accentColor,
                              width: 2,
                            ),
                            boxShadow: _copied
                                ? [
                                    BoxShadow(
                                      color: const Color.fromARGB(
                                        255,
                                        44,
                                        245,
                                        117,
                                      ).withOpacity(0.45),
                                      blurRadius: 18,
                                      spreadRadius: 2,
                                    ),
                                  ]
                                : [],
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: QrImageView(
                                  data: roomCode,
                                  version: QrVersions.auto,
                                  size: 140,
                                  backgroundColor: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 18),
                              Text(
                                _copied ? 'Copiado ✔' : 'Tu código de sala',
                                style: TextStyle(
                                  color: _copied
                                      ? const Color.fromARGB(255, 44, 245, 117)
                                      : Colors.white70,
                                  fontSize: 15,
                                  fontWeight: _copied
                                      ? FontWeight.w700
                                      : FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                roomCode,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 44, 245, 117),
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 2,
                                  decoration: TextDecoration.underline,
                                  decorationColor: _copied
                                      ? const Color.fromARGB(255, 44, 245, 117)
                                      : Colors.white54,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                _copied
                                    ? 'El código se ha copiado al portapapeles'
                                    : 'Toca el QR o el código para copiarlo',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: _copied ? Colors.white : Colors.white54,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 26),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _ActionButton(
                            icon: _downloading
                                ? Icons.hourglass_top
                                : Icons.download_outlined,
                            label: _downloading
                                ? 'Descargando...'
                                : 'Descargar',
                            color: const Color.fromARGB(255, 62, 162, 255),
                            onTap: _downloadCodeCard,
                          ),
                          const SizedBox(width: 16),
                          _ActionButton(
                            icon: _sharing
                                ? Icons.hourglass_top
                                : Icons.share_outlined,
                            label: _sharing
                                ? 'Compartiendo...'
                                : 'Compartir',
                            color: const Color.fromARGB(255, 44, 245, 117),
                            onTap: _shareCode,
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      _ActionButton(
                        icon: Icons.copy_all_outlined,
                        label: _copied ? 'Copiado' : 'Copiar código',
                        color: const Color.fromARGB(255, 44, 245, 117),
                        onTap: _copyCode,
                      ),

                      const SizedBox(height: 28),

                      _MainButton(
                        label: 'Ir al inicio',
                        onTap: () {
                          Navigator.popUntil(context, (route) => route.isFirst);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Tarjeta oculta para generar el PNG
          Positioned(
            left: -10000,
            top: 0,
            child: Material(
              color: Colors.transparent,
              child: RepaintBoundary(
                key: _downloadCardKey,
                child: Container(
                  width: 400,
                  height: 800,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 32,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0B0B0B),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(
                      color: const Color(0xFFD78BFF),
                      width: 3,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          RichText(
                            text: const TextSpan(
                              style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2,
                              ),
                              children: [
                                TextSpan(
                                  text: 'V',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 44, 245, 117),
                                  ),
                                ),
                                TextSpan(
                                  text: 'O',
                                  style: TextStyle(
                                    color: Color(0xFFEAB308),
                                  ),
                                ),
                                TextSpan(
                                  text: 'O',
                                  style: TextStyle(
                                    color: Color(0xFFEF4444),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Código de Sala',
                            style: TextStyle(
                              color: Color(0xFFD78BFF),
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),

                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: const Color(0xFF151515),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: const Color.fromARGB(255, 44, 245, 117),
                                width: 3,
                              ),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: QrImageView(
                                    data: roomCode,
                                    version: QrVersions.auto,
                                    size: 220,
                                    backgroundColor: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 18),
                                const Text(
                                  'Únete con este código',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  roomCode,
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 44, 245, 117),
                                    fontSize: 32,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const Text(
                        'Comparte esta tarjeta con tus invitados',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
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
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF151515),
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
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(widget.icon, color: widget.color, size: 20),
            const SizedBox(width: 8),
            Text(
              widget.label,
              style: TextStyle(
                color: widget.color,
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

class _MainButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const _MainButton({
    required this.label,
    required this.onTap,
  });

  @override
  State<_MainButton> createState() => _MainButtonState();
}

class _MainButtonState extends State<_MainButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    const color = Color.fromARGB(255, 44, 245, 117);

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF151515),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: color,
            width: 2,
          ),
          boxShadow: _pressed
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.55),
                    blurRadius: 18,
                    spreadRadius: 2,
                  ),
                ]
              : [],
        ),
        child: const Text(
          'Ir al inicio',
          style: TextStyle(
            color: color,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}