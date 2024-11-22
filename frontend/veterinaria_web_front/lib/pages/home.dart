// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:veterinaria_web_front/design/app_colors.dart';
import 'package:veterinaria_web_front/pages/appointmentt_create.dart';

class HomePage extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Cita> citas = [];

  @override
  void initState() {
    super.initState();
    _loadCitas();
  }

  Future<void> _loadCitas() async {
    try {
      final fetchedCitas = await fetchCitas();
      setState(() {
        citas = fetchedCitas;
      });
    } catch (error) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar las citas: $error')),
      );
    }
  }

  Future<List<Cita>> fetchCitas() async {
    final response = await http.get(Uri.parse('http://localhost:8000/citas'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((cita) => Cita.fromJson(cita)).toList();
    } else {
      throw Exception('Error al cargar las citas');
    }
  }

  Future<void> deleteCita(int idCita) async {
    final response = await http.delete(
      Uri.parse('http://localhost:8000/citas/$idCita'),
    );

    if (response.statusCode == 200) {
      setState(() {
        citas.removeWhere((cita) => cita.idCita == idCita);
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cita eliminada correctamente')),
      );
    } else {
      throw Exception('Error al eliminar la cita');
    }
  }

  @override
  Widget build(BuildContext context) {
    var colors = Theme.of(context).extension<AppColors>()!;
    return Scaffold(
      appBar: AppBar(title: Text('Citas')),
      drawer: Drawer(
        child: Container(
          color: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: colors.mainColor,
                ),
                child: Text(
                  'Menú',
                  style: TextStyle(
                    color: colors.dark,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                title: Text('Especies y Razas'),
                onTap: () {
                  // TODO: Navegar a la pantalla de especies y razas
                },
              ),
              ListTile(
                title: Text('Tratamientos'),
                onTap: () {
                  // TODO: Navegar a la pantalla de tratamientos
                },
              ),
              ListTile(
                title: Text('Propietarios'),
                onTap: () {
                  // TODO: Navegar a la pantalla de propietarios
                },
              ),
              ListTile(
                title: Text('Mascotas'),
                onTap: () {
                  // TODO: Navegar a la pantalla de mascotas
                },
              ),
            ],
          ),
        ),
      ),
      body: citas.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: citas.length,
              itemBuilder: (context, index) {
                Cita cita = citas[index];
                return Card(
                  elevation: 3,
                  color: colors.secondColor,
                  child: ListTile(
                    trailing: IconButton(
                      icon: Icon(Icons.done, color: colors.mainColor),
                      onPressed: () async {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Marcando cita como completada...')),
                        );
                        try {
                          await deleteCita(cita.idCita);
                        } catch (error) {
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: $error')),
                          );
                        }
                      },
                    ),
                    leading: Icon(Icons.pets, color: colors.light),
                    title: Text('Motivo: ${cita.motivo}'),
                    subtitle: Text(
                        'Fecha: ${cita.fecha}\nDiagnóstico: ${cita.diagnostico}'),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CrearCitaPage()),
          ).then((_) => _loadCitas());
        },
        backgroundColor: colors.mainColor,
        tooltip: 'Agregar Cita',
        child: Icon(Icons.add, color: colors.highlightColor),
      ),
    );
  }
}

class Cita {
  final int idCita;
  final int idMascota;
  final String fecha;
  final String motivo;
  final String diagnostico;
  final double peso;
  final double altura;
  final double largo;
  final double pagoTotal;

  Cita({
    required this.idCita,
    required this.idMascota,
    required this.fecha,
    required this.motivo,
    required this.diagnostico,
    required this.peso,
    required this.altura,
    required this.largo,
    required this.pagoTotal,
  });

  factory Cita.fromJson(Map<String, dynamic> json) {
    return Cita(
      idCita: json['idCita'],
      idMascota: json['idMascota'],
      fecha: json['fecha'],
      motivo: json['motivo'],
      diagnostico: json['diagnostico'],
      peso: json['peso'],
      altura: json['altura'],
      largo: json['largo'],
      pagoTotal: json['pago_total'],
    );
  }
}
