import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserDetail extends StatefulWidget {
  final int idusuario; // Cambiado a int para el ID del usuario

  UserDetail({required this.idusuario}); // Acepta solo el ID

  @override
  _UserDetailState createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {
  final _idUsuarioController = TextEditingController();
  final _nombreUsuarioController = TextEditingController();
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _isLoading = true;
  String message = '';

  @override
  void initState() {
    super.initState();
    _fetchUsuario(); // Llama a la función para obtener los detalles del usuario
  }

  Future<void> _fetchUsuario() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8000/usuarios/${widget.idusuario}'), // Cambia a tu endpoint
      );

      if (response.statusCode == 200) {
        final usuarioData = jsonDecode(response.body);
        
        // Inicializa los controladores con los datos del usuario
        _idUsuarioController.text = usuarioData['idusuario'].toString();
        _nombreUsuarioController.text = usuarioData['correo']; // Asumiendo que 'correo' es el nombre de usuario
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
        _isLoading = false; // Finaliza la carga
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
        Uri.parse('http://localhost:8000/usuarios/${widget.idusuario}'), // Cambia a tu endpoint
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'nombre_usuario': _nombreUsuarioController.text,
          'nombre': _nombreController.text,
          'apellido': _apellidoController.text,
          'password': _passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context, true); // Regresa a la lista si se actualiza correctamente
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
        Uri.parse('http://localhost:8000/usuarios/${widget.idusuario}'), // Cambia a tu endpoint
      );

      if (response.statusCode == 200) {
        Navigator.pop(context, true); // Regresar a la lista si se elimina correctamente
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar Eliminación'),
          content: Text('¿Estás seguro de que deseas eliminar al usuario ?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
            ),
            TextButton(
              child: Text('Eliminar'),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
                _eliminarUsuario(); // Llama a la función de eliminar
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
        title: Text('Detalles de Usuario'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _idUsuarioController,
                    decoration: InputDecoration(labelText: 'ID de Usuario'),
                    enabled: false, // Hace que el campo sea solo lectura
                  ),
                  TextField(
                    controller: _nombreUsuarioController,
                    decoration: InputDecoration(labelText: 'Nombre de Usuario (Correo)'),
                  ),
                  TextField(
                    controller: _nombreController,
                    decoration: InputDecoration(labelText: 'Nombre'),
                  ),
                  TextField(
                    controller: _apellidoController,
                    decoration: InputDecoration(labelText: 'Apellido'),
                  ),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(labelText: 'Contraseña'),
                    obscureText: true,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _actualizarUsuario,
                    child: Text('Actualizar Usuario'),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _showDeleteConfirmationDialog,
                    child: Text('Eliminar Usuario'),
                    //style: ElevatedButton.styleFrom(primary: Colors.red),
                  ),
                  SizedBox(height: 20),
                  if (message.isNotEmpty) Text(message, style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
    );
  }
}
