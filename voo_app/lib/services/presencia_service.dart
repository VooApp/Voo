import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'api_service.dart';

class PresenciaService {
  static Timer? _timer;

  // Inicia la verificación de presencia cada 3 horas
  // Se llama cuando el invitado entra a la sala
  static void iniciar({
    required String usuarioId,
  }) {
    // Cancelamos cualquier timer anterior
    _timer?.cancel();

    // Ejecutamos cada 3 horas
    _timer = Timer.periodic(const Duration(hours: 3), (_) async {
      await _verificarPresencia(usuarioId: usuarioId);
    });

    debugPrint('PresenciaService: verificación cada 3h iniciada');
  }

  // Para el timer cuando el usuario sale de la sala
  static void detener() {
    _timer?.cancel();
    _timer = null;
    debugPrint('PresenciaService: verificación detenida');
  }

  // Lógica de verificación
  static Future<bool> _verificarPresencia({
    required String usuarioId,
  }) async {
    try {
      // 1. Pedir permiso de ubicación
      final permiso = await Geolocator.checkPermission();
      if (permiso == LocationPermission.denied ||
          permiso == LocationPermission.deniedForever) {
        debugPrint('PresenciaService: sin permisos de ubicación');
        return false;
      }

      // 2. Obtener ubicación actual
      final posicion = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // 3. Mandar coordenadas a la API
      final resultado = await ApiService.confirmarPresencia(
        usuarioId: usuarioId,
        latitud: posicion.latitude,
        longitud: posicion.longitude,
        accuracy: posicion.accuracy,
      );

      final dentroRadio = resultado['dentroRadio'] as bool? ?? false;

      debugPrint(
          'PresenciaService: dentroRadio=$dentroRadio');

      return dentroRadio;
    } catch (e) {
      debugPrint('PresenciaService: error → $e');
      return false;
    }
  }

  // Llamada manual para confirmar presencia
  // La app puede llamar a esto cuando el usuario
  // responde a la notificación de "¿Sigues en la fiesta?"
  static Future<bool> confirmarManualmente({
    required String usuarioId,
  }) async {
    return await _verificarPresencia(usuarioId: usuarioId);
  }
}