// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors, use_build_context_synchronously, duplicate_ignore

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CreatePet extends StatefulWidget {
  @override
  _CreatePetState createState() => _CreatePetState();
}

class _CreatePetState extends State<CreatePet> {
  final _formKey = GlobalKey<FormState>();

  // Variables para los campos de la mascota
  String especimen = '';
  String raza = '';
  int idDueno = 0; // Debe ser un entero
  String nombre = '';
  String nacimiento = '';

  Future<void> crearMascota() async {
    final url = 'http://localhost:8000/mascotas'; // Cambiar si usas un servidor remoto

    final body = {
      'especimen': especimen,
      'raza': raza,
      'iddueño': idDueno,
      'nombre': nombre,
      'nacimiento': nacimiento,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        if (responseBody['message'] == 'Mascota agregada correctamente') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Mascota registrada exitosamente')),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${responseBody['message']}')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de conexión: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Mascota'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Especimen'),
                onChanged: (value) => especimen = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el especimen';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Raza'),
                onChanged: (value) => raza = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa la raza';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'ID del Dueño'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  idDueno = int.tryParse(value) ?? 0;
                },
                validator: (value) {
                  if (value == null || value.isEmpty || int.tryParse(value) == null) {
                    return 'Por favor ingresa un ID válido';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Nombre'),
                onChanged: (value) => nombre = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el nombre';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Fecha de Nacimiento (YYYY-MM-DD)'),
                onChanged: (value) => nacimiento = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa la fecha de nacimiento';
                  }
                  // Validar formato de fecha
                  final regex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
                  if (!regex.hasMatch(value)) {
                    return 'Formato de fecha inválido (YYYY-MM-DD)';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    crearMascota();
                  }
                },
                child: Text('Registrar Mascota'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
