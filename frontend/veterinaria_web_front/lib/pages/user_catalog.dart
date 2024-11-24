// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:veterinaria_web_front/design/app_colors.dart';
import 'package:veterinaria_web_front/pages/user_create.dart';
import 'package:veterinaria_web_front/pages/user_detail.dart';

class Usuario {
  final int idusuario; 
  final String nombre;
  final String apellido;
  final String correo;

  Usuario({required this.idusuario, required this.nombre, required this.apellido, required this.correo});

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      idusuario: json['idusuario'], 
      nombre: json['nombre'], 
      apellido: json['apellido'],
      correo: json['correo'] 
    );
  }
}

class CatalogoDeUsuarios extends StatefulWidget {
  @override
  _CatalogoDeUsuariosState createState() => _CatalogoDeUsuariosState();  
}

class _CatalogoDeUsuariosState extends State<CatalogoDeUsuarios> {
  List<Usuario> usuarios = []; 
  bool _isLoading = true;
  String message = '';

  @override
  void initState() {
    super.initState();
    _fetchUsuarios();
  }

  Future<void> _fetchUsuarios() async {
    setState(() {
      _isLoading = true;
      message = '';
    });

    try {
      final response = await http.get(Uri.parse('http://localhost:8000/usuarios')); 

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        setState(() {
          usuarios = data.map((json) => Usuario.fromJson(json)).toList();
        });
      } else {
        setState(() {
          message = 'Error al cargar usuarios: ${response.body}';
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

  @override
  Widget build(BuildContext context) {
    var colors = Theme.of(context).extension<AppColors>()!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Usuarios'),
        backgroundColor: colors.mainColor,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : usuarios.isEmpty
              ? Center(child: Text(message.isNotEmpty ? message : 'No hay usuarios registrados.'))
              : ListView.builder(
                  itemCount: usuarios.length,
                  itemBuilder: (context, index) {
                    final usuario = usuarios[index];
                    return ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      tileColor: Colors.white,
                      leading: CircleAvatar(
                        backgroundColor: colors.mainColor,
                        child: Text(usuario.nombre[0], style: TextStyle(color: colors.highlightColor),), 
                      ),
                      title: Text('${usuario.nombre} ${usuario.apellido}'),
                      subtitle: Text(usuario.correo), 
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                          builder: (context) => UserDetail(idusuario: usuario.idusuario,)
                          ),
                        ).then((shouldRefresh){
                            if(shouldRefresh == true ){
                              _fetchUsuarios();
                            }
                          });
                      },
                    );
                  },
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateUser(),
                      ),
                    ).then((shouldRefresh) {
                      if (shouldRefresh == true) {
                        _fetchUsuarios();
                      }
                    });
                  },
                  backgroundColor: colors.mainColor,
                  child: Icon(Icons.add, color: colors.highlightColor),
                ),
    );
  }
}
