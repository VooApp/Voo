import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'loading_screen.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  int _currentCameraIndex = 0;

  bool _isInitializing = true;
  bool _isCapturing = false;
  bool _flashEnabled = false;
  double _zoom = 1.0;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera([int cameraIndex = 0]) async {
    try {
      setState(() {
        _isInitializing = true;
      });

      _cameras = await availableCameras();

      if (_cameras.isEmpty) {
        throw Exception('No hay cámaras disponibles');
      }

      _currentCameraIndex = cameraIndex.clamp(0, _cameras.length - 1);

      await _controller?.dispose();

      final controller = CameraController(
        _cameras[_currentCameraIndex],
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await controller.initialize();
      await controller.setFlashMode(FlashMode.off);
      await controller.setZoomLevel(_zoom);

      if (!mounted) return;

      setState(() {
        _controller = controller;
        _isInitializing = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _isInitializing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo abrir la cámara'),
        ),
      );
    }
  }

  Future<void> _switchCamera() async {
    if (_cameras.length < 2) return;
    final nextIndex = (_currentCameraIndex + 1) % _cameras.length;
    await _initCamera(nextIndex);
  }

  Future<void> _toggleFlash() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;

    _flashEnabled = !_flashEnabled;
    await controller.setFlashMode(
      _flashEnabled ? FlashMode.torch : FlashMode.off,
    );

    if (!mounted) return;
    setState(() {});
  }

  Future<void> _capture() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized || _isCapturing) {
      return;
    }

    try {
      setState(() {
        _isCapturing = true;
      });

      await controller.takePicture();

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const LoadingScreen(),
        ),
      );
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo capturar la foto'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isCapturing = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;

    return Scaffold(
      backgroundColor: const Color(0xFF05051C),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
              child: Column(
                children: [
                  Row(
                    children: [
                      _BackButtonPurple(
                        onTap: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Comprueba tu cara',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Coloca tu cara dentro del círculo para comprobar que eres tú.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(34),
                        border: Border.all(
                          color: const Color(0xFF5A2F8E),
                          width: 2,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: _isInitializing
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                        color: Color(0xFF9C4DFF),
                                      ),
                                    )
                                  : (controller != null &&
                                          controller.value.isInitialized)
                                      ? CameraPreview(controller)
                                      : const Center(
                                          child: Text(
                                            'No se pudo cargar la cámara',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                            ),

                            Center(
                              child: IgnorePointer(
                                child: Container(
                                  width: 210,
                                  height: 210,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xFF9C4DFF),
                                      width: 3,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            Positioned(
                              bottom: 104,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black54,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '${_zoom.toStringAsFixed(1)}x',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(12, 14, 12, 10),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: const Color(0xFF2E2E2E),
                        width: 1.2,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _CameraIconButton(
                          icon: _flashEnabled ? Icons.flash_on : Icons.flash_off,
                          onTap: _toggleFlash,
                        ),
                        _CaptureButton(
                          onTap: _capture,
                        ),
                        _CameraIconButton(
                          icon: Icons.cameraswitch,
                          onTap: _switchCamera,
                        ),
                      ],
                    ),
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

class _BackButtonPurple extends StatefulWidget {
  final VoidCallback onTap;

  const _BackButtonPurple({required this.onTap});

  @override
  State<_BackButtonPurple> createState() => _BackButtonPurpleState();
}

class _BackButtonPurpleState extends State<_BackButtonPurple> {
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
              color: const Color(0xFF8B3DFF)
                  .withOpacity(_pressed ? 0.5 : 0.2),
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

class _CaptureButton extends StatefulWidget {
  final VoidCallback onTap;

  const _CaptureButton({required this.onTap});

  @override
  State<_CaptureButton> createState() => _CaptureButtonState();
}

class _CaptureButtonState extends State<_CaptureButton> {
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
      child: AnimatedScale(
        scale: _pressed ? 0.92 : 1,
        duration: const Duration(milliseconds: 120),
        child: Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 4),
          ),
          child: Center(
            child: Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CameraIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CameraIconButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        icon,
        color: Colors.white,
        size: 34,
      ),
    );
  }
}