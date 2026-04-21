import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:universal_html/html.dart' as html;

import '../home/home_screen.dart';

class RoomCodeScreen extends StatefulWidget {
  final bool isHost;

  const RoomCodeScreen({
    super.key,
    required this.isHost,
  });

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

    await Future.delayed(const Duration(milliseconds: 1500));

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

      html.AnchorElement(href: url)
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

  void _goToHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => HomeScreen(isHost: widget.isHost),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color accentColor =
        _copied ? const Color(0xFF22C55E) : const Color(0xFF7E2BE8);

    return Scaffold(
      backgroundColor: const Color(0xFF05051C),
      body: Stack(
        children: [
          Container(
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
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 430),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Código de Sala',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Comparte el código o el QR con tus invitados.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.68),
                          fontSize: 14,
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 24),
                      GestureDetector(
                        onTap: _copyCode,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 22,
                            vertical: 24,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF141421),
                                Color(0xFF0E0E18),
                              ],
                            ),
                            border: Border.all(
                              color: accentColor,
                              width: _copied ? 4 : 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: accentColor.withOpacity(
                                  _copied ? 0.6 : 0.08,
                                ),
                                blurRadius: _copied ? 35 : 10,
                                spreadRadius: _copied ? 3 : 0,
                              ),
                              if (_copied)
                                BoxShadow(
                                  color: const Color(0xFF22C55E).withOpacity(0.4),
                                  blurRadius: 60,
                                  spreadRadius: 6,
                                ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white.withOpacity(0.08),
                                      blurRadius: 12,
                                      spreadRadius: 0.4,
                                    ),
                                  ],
                                ),
                                child: QrImageView(
                                  data: roomCode,
                                  version: QrVersions.auto,
                                  size: 180,
                                  backgroundColor: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Tu código de sala',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.72),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                roomCode,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF22C55E),
                                  fontSize: 30,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 2.5,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Toca el QR o el código para copiarlo',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.48),
                                  fontSize: 13,
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 14,
                        runSpacing: 12,
                        children: [
                          _IconOnlyActionButton(
                            icon: _downloading
                                ? Icons.hourglass_top
                                : Icons.download_outlined,
                            color: const Color(0xFF9C4DFF),
                            onTap: _downloadCodeCard,
                          ),
                          _IconOnlyActionButton(
                            icon: _sharing
                                ? Icons.hourglass_top
                                : Icons.share_outlined,
                            color: const Color(0xFF9C4DFF),
                            onTap: _shareCode,
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      _MainButton(
                        label: 'Ir al inicio',
                        onTap: _goToHome,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 28,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: AnimatedSlide(
                offset: _copied ? Offset.zero : const Offset(0, -0.25),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutBack,
                child: AnimatedOpacity(
                  opacity: _copied ? 1 : 0,
                  duration: const Duration(milliseconds: 220),
                  child: Center(
                    child: AnimatedScale(
                      scale: _copied ? 1 : 0.9,
                      duration: const Duration(milliseconds: 260),
                      curve: Curves.easeOutBack,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFF0B3D1E),
                              Color(0xFF22C55E),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF22C55E).withOpacity(0.55),
                              blurRadius: 30,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Código copiado',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: -10000,
            top: 0,
            child: Material(
              color: Colors.transparent,
              child: RepaintBoundary(
                key: _downloadCardKey,
                child: Container(
                  width: 430,
                  padding: const EdgeInsets.fromLTRB(28, 34, 28, 30),
                  decoration: const BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.topCenter,
                      radius: 1.15,
                      colors: [
                        Color(0xFF171128),
                        Color(0xFF0C0A18),
                        Color(0xFF05051C),
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 66,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                            height: 1,
                          ),
                          children: [
                            TextSpan(
                              text: 'V',
                              style: TextStyle(
                                color: const Color(0xFF22C55E),
                                shadows: [
                                  Shadow(
                                    color: const Color(0xFF22C55E)
                                        .withOpacity(0.65),
                                    blurRadius: 18,
                                  ),
                                ],
                              ),
                            ),
                            TextSpan(
                              text: 'O',
                              style: TextStyle(
                                color: const Color(0xFFEAB308),
                                shadows: [
                                  Shadow(
                                    color: const Color(0xFFEAB308)
                                        .withOpacity(0.65),
                                    blurRadius: 18,
                                  ),
                                ],
                              ),
                            ),
                            TextSpan(
                              text: 'O',
                              style: TextStyle(
                                color: const Color(0xFFEF4444),
                                shadows: [
                                  Shadow(
                                    color: const Color(0xFFEF4444)
                                        .withOpacity(0.65),
                                    blurRadius: 18,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Código de Sala',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Comparte esta tarjeta con tus invitados',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.60),
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 28),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 28,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(34),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF1A1A28),
                              Color(0xFF11111B),
                            ],
                          ),
                          border: Border.all(
                            color: const Color(0xFF9C4DFF),
                            width: 2.4,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF9C4DFF).withOpacity(0.18),
                              blurRadius: 24,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(28),
                              ),
                              child: QrImageView(
                                data: roomCode,
                                version: QrVersions.auto,
                                size: 230,
                                backgroundColor: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'Tu código de acceso',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              roomCode,
                              style: TextStyle(
                                color: Color(0xFF22C55E),
                                fontSize: 38,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 3,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              'Escanea el QR o introduce el código para entrar en la sala.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.58),
                                fontSize: 14,
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 26),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: const Color(0xFF22C55E).withOpacity(0.45),
                            width: 1.5,
                          ),
                          color: const Color(0xFF22C55E).withOpacity(0.08),
                        ),
                        child: const Text(
                          'VOO · Ahora o nunca',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF22C55E),
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.4,
                          ),
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

class _IconOnlyActionButton extends StatefulWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _IconOnlyActionButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  State<_IconOnlyActionButton> createState() => _IconOnlyActionButtonState();
}

class _IconOnlyActionButtonState extends State<_IconOnlyActionButton> {
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
        width: 58,
        height: 58,
        decoration: BoxDecoration(
          color: const Color(0xFF151515),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: widget.color,
            width: 2,
          ),
          boxShadow: _pressed
              ? [
                  BoxShadow(
                    color: widget.color.withOpacity(0.38),
                    blurRadius: 16,
                    spreadRadius: 1.2,
                  ),
                ]
              : [],
        ),
        child: Icon(
          widget.icon,
          color: widget.color,
          size: 24,
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
    const color = Color(0xFF22C55E);

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
                    color: color.withOpacity(0.45),
                    blurRadius: 18,
                    spreadRadius: 1.5,
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