import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VOO Test',
      home: const MensajePage(),
    );
  }
}

class MensajePage extends StatefulWidget {
  const MensajePage({super.key});

  @override
  State<MensajePage> createState() => _MensajePageState();
}

class _MensajePageState extends State<MensajePage> {
  final TextEditingController _controller = TextEditingController();
  String _respuesta = '';

  Future<void> _enviarMensaje() async {
    final url = Uri.parse('http://localhost:5011/mensaje');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'texto': _controller.text}),
    );

    setState(() {
      if (response.statusCode == 200) {
        _respuesta = '✅ Guardado correctamente';
      } else {
        _respuesta = '❌ Error: ${response.statusCode}';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('VOO - Enviar mensaje')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Escribe un mensaje',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _enviarMensaje,
              child: const Text('Enviar a MongoDB'),
            ),
            const SizedBox(height: 24),
            Text(_respuesta, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}