import 'package:flutter/material.dart';
import 'package:veterinaria_web_front/design/app_colors.dart';
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
    //TODO: Implementar la lógica de inicio de sesión
  }

  void _loginButtonPressed() async {
    await _login(); 
  }

  @override
  Widget build(BuildContext context) {
    var colors = Theme.of(context).extension<AppColors>()!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors.mainColor,
        title: const Text('Control Veterinario'),
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
              onPressed: _loginButtonPressed, // Cambia aquí
              label:  Text('Iniciar Sesión'),
              icon: Icon(Icons.login),
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