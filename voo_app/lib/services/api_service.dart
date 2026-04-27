import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static String get baseUrl {
    const envUrl = String.fromEnvironment('API_BASE_URL');

    if (envUrl.isNotEmpty) return envUrl;

    if (kIsWeb) {
      return 'http://localhost:5011';
    }

    if (Platform.isAndroid) {
      return 'http://10.0.2.2:5011';
    }

    return 'http://localhost:5011';
  }

  static Uri _uri(String path) {
    return Uri.parse('$baseUrl$path');
  }

  static Future<RegistroHostResponse> registrarHost({
    required String nombre,
    required bool sexo,
    required DateTime fechaNacimiento,
    required String foto,
    required String? instagram,
    required String estado,
    required List<String> respuestas,
    required String nombreSala,
    required String contexto,
    required int aforo,
    required String direccion,
    required int codigoPostal,
    required double latitudSala,
    required double longitudSala,
    required String premioMayor,
    required List<String> premiosFlash,
  }) async {
    final uri = _uri('/Registro/host');

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'nombre': nombre,
        'sexo': sexo,
        'fechaNacimiento': fechaNacimiento.toUtc().toIso8601String(),
        'foto': foto,
        'ig': instagram,
        'estado': estado,
        'respuestas': respuestas,
        'nombreSala': nombreSala,
        'contexto': contexto,
        'aforo': aforo,
        'direccion': direccion,
        'codigoPostal': codigoPostal,
        'latitudSala': latitudSala,
        'longitudSala': longitudSala,
        'premioMayor': premioMayor,
        'premiosFlash': premiosFlash,
      }),
    );

    debugPrint('POST: $uri');
    debugPrint('STATUS: ${response.statusCode}');
    debugPrint('BODY: ${response.body}');

    Map<String, dynamic> data = {};

    if (response.body.isNotEmpty) {
      data = jsonDecode(response.body) as Map<String, dynamic>;
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(data['mensaje'] ?? 'Error al registrar host');
    }

    return RegistroHostResponse.fromJson(data);
  }
}

class RegistroHostResponse {
  final String mensaje;
  final String usuarioId;
  final String salaId;
  final String codigoSala;
  final String nombreUsuario;

  RegistroHostResponse({
    required this.mensaje,
    required this.usuarioId,
    required this.salaId,
    required this.codigoSala,
    required this.nombreUsuario,
  });

  factory RegistroHostResponse.fromJson(Map<String, dynamic> json) {
    final usuario = json['usuario'] as Map<String, dynamic>? ?? {};
    final sala = json['sala'] as Map<String, dynamic>? ?? {};

    return RegistroHostResponse(
      mensaje: json['mensaje']?.toString() ?? '',
      usuarioId: usuario['id']?.toString() ?? '',
      salaId: sala['id']?.toString() ?? '',
      codigoSala:
          json['codigoSala']?.toString() ?? sala['codigoSala']?.toString() ?? '',
      nombreUsuario: usuario['nombre']?.toString() ?? 'Host',
    );
  }
}