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

  static Future<RegistroInvitadoResponse> registrarInvitado({
    required String nombre,
    required bool sexo,
    required DateTime fechaNacimiento,
    required String foto,
    required String? instagram,
    required String estado,
    required List<String> respuestas,
    required String codigoSala,
  }) async {
    final response = await http.post(
      _uri('/Registro/invitado'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nombre': nombre,
        'sexo': sexo,
        'fechaNacimiento': fechaNacimiento.toUtc().toIso8601String(),
        'foto': foto,
        'ig': instagram,
        'estado': estado,
        'respuestas': respuestas,
        'codigoSala': codigoSala,
      }),
    );

    print('POST: ${_uri('/Registro/invitado')}');
    print('STATUS: ${response.statusCode}');
    print('BODY: ${response.body}');

    final Map<String, dynamic> data = jsonDecode(response.body);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(data['mensaje'] ?? 'Error al registrar invitado');
    }
    return RegistroInvitadoResponse.fromJson(data);
  }

  static Future<List<SalaUsuarioModel>> getUsuariosSala(String salaId) async {
    final response = await http.get(_uri('/Usuario/sala/$salaId'));

    print('GET: ${_uri('/Usuario/sala/$salaId')}');
    print('STATUS: ${response.statusCode}');

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Error al obtener usuarios de la sala');
    }

    final List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => SalaUsuarioModel.fromJson(json)).toList();
  }

  static Future<void> banearUsuario(String usuarioId) async {
    final response = await http.patch(
      _uri('/Usuario/$usuarioId/banear'),
      headers: {'Content-Type': 'application/json'},
    );

    print('PATCH: ${_uri('/Usuario/$usuarioId/banear')}');
    print('STATUS: ${response.statusCode}');

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Error al banear usuario');
    }
  }

  static Future<void> salirDeSala(String usuarioId) async {
    final response = await http.patch(
      _uri('/Usuario/$usuarioId/salir'),
      headers: {'Content-Type': 'application/json'},
    );

    print('PATCH: ${_uri('/Usuario/$usuarioId/salir')}');
    print('STATUS: ${response.statusCode}');

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Error al salir de sala');
    }
  }

  static Future<void> cerrarSala(String salaId) async {
    final response = await http.patch(
      _uri('/Sala/$salaId/cerrar'),
      headers: {'Content-Type': 'application/json'},
    );

    print('PATCH: ${_uri('/Sala/$salaId/cerrar')}');
    print('STATUS: ${response.statusCode}');

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Error al cerrar sala');
    }
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

class RegistroInvitadoResponse {
  final String usuarioId;
  final String salaId;
  final String nombreUsuario;

  RegistroInvitadoResponse({
    required this.usuarioId,
    required this.salaId,
    required this.nombreUsuario,
  });

  factory RegistroInvitadoResponse.fromJson(Map<String, dynamic> json) {
    final usuario = json['usuario'] as Map<String, dynamic>;
    final sala = json['sala'] as Map<String, dynamic>;
    return RegistroInvitadoResponse(
      usuarioId: usuario['id']?.toString() ?? '',
      salaId: sala['id']?.toString() ?? '',
      nombreUsuario: usuario['nombre']?.toString() ?? 'Invitado',
    );
  }
}

class SalaUsuarioModel {
  final String id;
  final String nombre;
  final DateTime fechaNacimiento;
  final String estado; 
  final bool esHost;
  final bool baneado;

  SalaUsuarioModel({
    required this.id,
    required this.nombre,
    required this.fechaNacimiento,
    required this.estado,
    required this.esHost,
    required this.baneado,
  });

  int get edad {
    final hoy = DateTime.now();
    int edad = hoy.year - fechaNacimiento.year;
    if (hoy.month < fechaNacimiento.month ||
        (hoy.month == fechaNacimiento.month && hoy.day < fechaNacimiento.day)) {
      edad--;
    }
    return edad;
  }

  // Convierte el string de estado a Color para la UI
  Color get statusColor {
    switch (estado.toLowerCase()) {
      case 'verde':
        return const Color(0xFF22C55E);
      case 'amarillo':
        return const Color(0xFFEAB308);
      case 'rojo':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF22C55E);
    }
  }

  factory SalaUsuarioModel.fromJson(Map<String, dynamic> json) {
    return SalaUsuarioModel(
      id: json['id']?.toString() ?? '',
      nombre: json['nombre']?.toString() ?? '',
      fechaNacimiento: DateTime.parse(
        json['fechaNacimiento']?.toString() ?? DateTime.now().toIso8601String(),
      ),
      estado: json['estado']?.toString() ?? 'verde',
      esHost: json['tipo']?.toString() == 'host',
      baneado: json['baneado'] as bool? ?? false,
    );
  }
}