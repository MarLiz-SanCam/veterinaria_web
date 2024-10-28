import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:veterinaria_web_front/design/app_colors.dart';
import 'package:veterinaria_web_front/pages/create_cita.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var colors = Theme.of(context).extension<AppColors>()!;
    return Scaffold(
      appBar: AppBar(
        title: Text('Citas Veterinarias'),
        backgroundColor: colors.mainColor,
      ),
      drawer: Drawer(
  child: Container(
    color: Colors.white, // Establece el color de fondo a blanco puro
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          child: Text(
            'Menú',
            style: TextStyle(
              color: colors.dark,
              fontSize: 24,
            ),
          ),
          decoration: BoxDecoration(
            color: colors.mainColor,
          ),
        ),
        ListTile(
          title: Text('Especies y Razas'),
          onTap: () {
            // TODO:Navegar a la pantalla de especies y razas
          },
        ),
        ListTile(
          title: Text('Tratamientos'),
          onTap: () {
            // TODO:Navegar a la pantalla de tratamientos
          },
        ),
        ListTile(
          title: Text('Propietarios'),
          onTap: () {
            // TODO:Navegar a la pantalla de propietarios
          },
        ),
        ListTile(
          title: Text('Mascotas'),
          onTap: () {
            // TODO:Navegar a la pantalla de mascotas
          },
        ),
      ],
    ),
  ),
),
      body: FutureBuilder<List<Cita>>(
        future: fetchCitas(), // Llama a tu función para obtener las citas
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Cita> citas = snapshot.data!;
            return ListView.builder(
              itemCount: citas.length,
              itemBuilder: (context, index) {
                Cita cita = citas[index];
                return Card(
                  elevation: 3,
                  color: colors.secondColor,
                  child: ListTile(
                    trailing: Icon(Icons.arrow_forward_ios, color: colors.mainColor),
                    leading: Icon(Icons.pets, color: colors.light),
                    title: Text('Motivo: ${cita.motivo}'),
                    subtitle: Text(
                        'Fecha: ${cita.fecha}\nDiagnóstico: ${cita.diagnostico}'),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
            Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CrearCitaPage()),
            );
        },
        backgroundColor: colors.mainColor,
        child: Icon(Icons.add, color: colors.highlightColor),
        tooltip: 'Agregar Cita',
      ),
    );
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
