// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:veterinaria_web_front/design/app_colors.dart';

class UserDetail extends StatefulWidget {
  final int idusuario; 
  UserDetail({required this.idusuario}); 
  @override
  _UserDetailState createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {
  final _idUsuarioController = TextEditingController();
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _correoController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _isLoading = true;
  String message = '';

  @override
  void initState() {
    super.initState();
    _fetchUsuario(); 
  }

  Future<void> _fetchUsuario() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8000/usuarios/${widget.idusuario}'), 
      );

      if (response.statusCode == 200) {
        final usuarioData = jsonDecode(response.body);
        
        _idUsuarioController.text = usuarioData['idusuario'].toString();
        _correoController.text = usuarioData['correo']; 
        _nombreController.text = usuarioData['nombre'];
        _apellidoController.text = usuarioData['apellido'];
      } else {
        setState(() {
          message = 'Error al obtener usuario: ${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        message = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false; 
      });
    }
  }

  Future<void> _actualizarUsuario() async {
    setState(() {
      _isLoading = true;
      message = '';
    });

    try {
      final response = await http.put(
        Uri.parse('http://localhost:8000/usuarios/${widget.idusuario}'), 
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'nombre': _nombreController.text,
          'apellido': _apellidoController.text,
          'correo': _correoController.text,
          'clave': _passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context, true); 
      } else {
        setState(() {
          message = 'Error al actualizar usuario: ${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        message = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _eliminarUsuario() async {
    setState(() {
      _isLoading = true;
      message = '';
    });

    try {
      final response = await http.delete(
        Uri.parse('http://localhost:8000/usuarios/${widget.idusuario}'), 
      );

      if (response.statusCode == 200) {
        Navigator.pop(context, true); 
      } else {
        setState(() {
          message = 'Error al eliminar usuario: ${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        message = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showDeleteConfirmationDialog() {
     var colors = Theme.of(context).extension<AppColors>()!;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Eliminación'),
          content: const Text('¿Estás seguro de que deseas eliminar al usuario?'),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(); 
              },
            ),
            TextButton(
              child: Text('Eliminar', style: TextStyle(color: colors.mainColor)), 
              onPressed: () {
                Navigator.of(context).pop(); 
                _eliminarUsuario(); 
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles de Usuario'),
        backgroundColor: Theme.of(context).extension<AppColors>()!.mainColor,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView( 
              padding: const EdgeInsets.all(50.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _idUsuarioController,
                    decoration: const InputDecoration(labelText: 'ID de Usuario'),
                    enabled: false, 
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _nombreController,
                    decoration: const InputDecoration(labelText: 'Nombre'),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _apellidoController,
                    decoration: const InputDecoration(labelText: 'Apellido'),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _correoController,
                    decoration: const InputDecoration(labelText: 'Correo Electrónico'),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Contraseña'),
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: _actualizarUsuario,
                          child: const Text('Modificar'),
                        ),
                        const SizedBox(width: 40),
                        ElevatedButton(
                          onPressed: _showDeleteConfirmationDialog,
                          child: const Text('Eliminar'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (message.isNotEmpty) Text(message, style: const TextStyle(color: Colors.red)),
                ],
              ),
            ),
    );
  }
}
