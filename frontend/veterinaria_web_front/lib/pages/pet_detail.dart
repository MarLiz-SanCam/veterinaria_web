// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:veterinaria_web_front/design/app_colors.dart';

class PetDetail extends StatefulWidget {
  final int idMascota;  // Cambié 'idusuario' por 'idMascota'
  PetDetail({required this.idMascota});
  
  @override
  _PetDetailState createState() => _PetDetailState();
}

class _PetDetailState extends State<PetDetail> {
  final _idMascotaController = TextEditingController();
  final _especimenController = TextEditingController();
  final _razaController = TextEditingController();
  final _nombreController = TextEditingController();
  final _nacimientoController = TextEditingController();

  bool _isLoading = true;
  String message = '';

  @override
  void initState() {
    super.initState();
    _fetchMascota();  // Cambié el nombre del método
  }

  Future<void> _fetchMascota() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8000/mascotas/${widget.idMascota}'),  // Cambié la ruta para mascotas
      );

      if (response.statusCode == 200) {
        final mascotaData = jsonDecode(response.body);
        
        _idMascotaController.text = mascotaData['idMascota'].toString();
        _nombreController.text = mascotaData['nombre'];
        _especimenController.text = mascotaData['especimen'];
        _razaController.text = mascotaData['raza'];
        _nacimientoController.text = mascotaData['nacimiento'];
      } else {
        setState(() {
          message = 'Error al obtener mascota: ${response.body}';
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

  Future<void> _actualizarMascota() async {
    setState(() {
      _isLoading = true;
      message = '';
    });

    try {
      final response = await http.put(
        Uri.parse('http://localhost:8000/mascotas/${widget.idMascota}'),  // Cambié la ruta para mascotas
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'nombre': _nombreController.text,
          'especimen': _especimenController.text,
          'raza': _razaController.text,
          'nacimiento': _nacimientoController.text,
        }),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context, true); 
      } else {
        setState(() {
          message = 'Error al actualizar mascota: ${response.body}';
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

  Future<void> _eliminarMascota() async {
    setState(() {
      _isLoading = true;
      message = '';
    });

    try {
      final response = await http.delete(
        Uri.parse('http://localhost:8000/mascotas/${widget.idMascota}'),  // Cambié la ruta para mascotas
      );

      if (response.statusCode == 200) {
        Navigator.pop(context, true); 
      } else {
        setState(() {
          message = 'Error al eliminar mascota: ${response.body}';
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
          content: const Text('¿Estás seguro de que deseas eliminar a la mascota?'),
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
                _eliminarMascota(); 
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
        title: const Text('Detalles de Mascota'),
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
                    controller: _idMascotaController,
                    decoration: const InputDecoration(labelText: 'ID de Mascota'),
                    enabled: false, 
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _nombreController,
                    decoration: const InputDecoration(labelText: 'Nombre'),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _especimenController,
                    decoration: const InputDecoration(labelText: 'Especimen'),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _razaController,
                    decoration: const InputDecoration(labelText: 'Raza'),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _nacimientoController,
                    decoration: const InputDecoration(labelText: 'Fecha de Nacimiento'),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: _actualizarMascota,
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
