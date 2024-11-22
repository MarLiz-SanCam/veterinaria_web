// ignore_for_file: library_private_types_in_public_api, prefer_const_declarations, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:veterinaria_web_front/pages/home.dart';
import 'package:veterinaria_web_front/pages/user_catalog.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _login() async {
    final String correo = _usernameController.text;
    final String clave = _passwordController.text;
    final url = 'http://localhost:8000/login';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'correo': correo, 'clave': clave}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data['valid'] == 1) {
          // Inicio de sesión exitoso
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Inicio de sesión exitoso')),
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        } else {
          // Error de validación
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${data['error']}')),
          );
        }
      } else {
        // Error en la solicitud HTTP
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error en el servidor')),
        );
      }
    } catch (e) {
      // Error de conexión o excepción
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de conexión: $e')),
      );
    }
  }

  void _loginButtonPressed() async {
    await _login(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Usuario'),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _loginButtonPressed,
              label: const Text('Iniciar Sesión'),
              icon: const Icon(Icons.login),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CatalogoDeUsuarios()),
                );
              },
              label: const Text('Ver Usuarios'),
              icon: const Icon(Icons.people),
            ),
          ],
        ),
      ),
    );
  }
}
