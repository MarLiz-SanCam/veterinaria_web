// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_declarations, prefer_const_constructors, use_build_context_synchronously, duplicate_ignore, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:veterinaria_web_front/design/app_colors.dart';
import 'package:veterinaria_web_front/pages/pet_add.dart';

class PetCatalog extends StatefulWidget {
  @override
  _PetCatalogState createState() => _PetCatalogState();
}

class _PetCatalogState extends State<PetCatalog> {
  final bool _isLoading = false;
  String message = '';
  List<dynamic> mascotas = [];
  String nombreMascota = '';
  String especimen = '';
  String raza = '';
  String propietario = '';
  String nacimiento = '';

  Future<void> obtenerMascotas() async {
    final url = 'http://localhost:8000/mascotas'; 

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> responseBody = json.decode(response.body);
        setState(() {
          mascotas = responseBody;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${response.body}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error de conexión: $e')));
    }
  }

  Future<void> agregarMascota() async {
    final url = 'http://localhost:8000/mascotas'; 

    final body = {
      'especimen': especimen,
      'raza': raza,
      'iddueño': propietario,
      'nombre': nombreMascota,
      'nacimiento': nacimiento,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        if (responseBody['valid'] == 1) {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Mascota agregada')));
          obtenerMascotas(); // Actualiza la lista de mascotas
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${responseBody['error']}')));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${response.body}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error de conexión: $e')));
    }
  }

  Future<void> eliminarMascota(String idMascota) async {
    final url = 'http://localhost:8000/mascotas/$idMascota'; 

    try {
      final response = await http.delete(Uri.parse(url));

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        if (responseBody['valid'] == 1) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Mascota eliminada')));
          obtenerMascotas(); // Actualiza la lista de mascotas
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(':c Error: ${responseBody['error']}')));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('...Error: ${response.body}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error de conexión: $e')));
    }
  }

  @override
  void initState() {
    super.initState();
    obtenerMascotas(); // Llama al método para obtener las mascotas cuando la pantalla se carga
  }


  @override
  Widget build(BuildContext context) {
    var colors = Theme.of(context).extension<AppColors>()!;
    return Scaffold(
      appBar: AppBar(
        title: Text('Mascotas Pacientes'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : mascotas.isEmpty
            ? Center(child: Text(message.isNotEmpty ? message : 'No hay usuarios registrados.'))
            : ListView.builder(
                itemCount: mascotas.length,
                itemBuilder: (context, index) {
                  final mascota = mascotas[index];
                  return Card(
                    elevation: 3,
                    color: colors.mainColor,
                    child: ListTile(
                    shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                    title: Text(mascota['nombre']),
                    subtitle: Text('Raza: '+mascota['raza']+'\n Fecha de nacimiento: '+mascota['nacimiento']),
                    tileColor: colors.secondColor,
                    leading: CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('assets/images/5.png'),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        eliminarMascota(mascota['idMascota'].toString());
                      },
                    ),
                  ),
                );
            },
          ),
          floatingActionButton: FloatingActionButton(
        onPressed: () {
          
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreatePet(),
                      ),
                    );
        },
        backgroundColor: colors.mainColor,
        tooltip: 'Agregar Mascota',
        child: Icon(Icons.add, color: colors.highlightColor),
      ),
    );
  }
}
