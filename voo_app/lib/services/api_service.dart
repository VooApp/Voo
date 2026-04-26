import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:5011',
  );

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
    final response = await http.post(
      _uri('/Registro/host'),
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

    print('POST: ${_uri('/Registro/host')}');
    print('STATUS: ${response.statusCode}');
    print('BODY: ${response.body}');

    final Map<String, dynamic> data = jsonDecode(response.body);

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
    final usuario = json['usuario'] as Map<String, dynamic>;
    final sala = json['sala'] as Map<String, dynamic>;

    return RegistroHostResponse(
      mensaje: json['mensaje']?.toString() ?? '',
      usuarioId: usuario['id']?.toString() ?? '',
      salaId: sala['id']?.toString() ?? '',
      codigoSala: json['codigoSala']?.toString() ??
          sala['codigoSala']?.toString() ??
          '',
      nombreUsuario: usuario['nombre']?.toString() ?? 'Host',
    );
  }
}