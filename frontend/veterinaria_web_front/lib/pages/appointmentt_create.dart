import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// ignore: use_key_in_widget_constructors
class CrearCitaPage extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _CrearCitaPageState createState() => _CrearCitaPageState();
}

class _CrearCitaPageState extends State<CrearCitaPage> {
  final _formKey = GlobalKey<FormState>();
   final TextEditingController _idMascotaController = TextEditingController();
  final TextEditingController _fechaController = TextEditingController();
  final TextEditingController _motivoController = TextEditingController();
  final TextEditingController _diagnosticoController = TextEditingController();
  final TextEditingController _pesoController = TextEditingController();
  final TextEditingController _alturaController = TextEditingController();
  final TextEditingController _largoController = TextEditingController();
  final TextEditingController _pagoTotalController = TextEditingController();

  Future<void> _crearCita() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse('http://localhost:8000/citas'), 
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'idMascota': _idMascotaController.text,
          'fecha': _fechaController.text,
          'motivo': _motivoController.text,
          'diagnostico': _diagnosticoController.text,
          'peso': _pesoController.text,
          'altura': _alturaController.text,
          'largo': _largoController.text,
          'pago_total': _pagoTotalController.text,
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseBody['message'])),
        );
        _formKey.currentState!.reset();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al crear la cita')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Cita'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _idMascotaController,
                decoration: const InputDecoration(labelText: 'ID de Mascota'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa el ID de la mascota';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _fechaController,
                decoration: const InputDecoration(labelText: 'Fecha (YYYY-MM-DD)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa la fecha';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _motivoController,
                decoration: const InputDecoration(labelText: 'Motivo'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa el motivo';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _diagnosticoController,
                decoration: const InputDecoration(labelText: 'Diagnóstico'),
              ),
              TextFormField(
                controller: _pesoController,
                decoration: const InputDecoration(labelText: 'Peso (kg)'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _alturaController,
                decoration: const InputDecoration(labelText: 'Altura (cm)'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _largoController,
                decoration: const InputDecoration(labelText: 'Largo (cm)'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _pagoTotalController,
                decoration: const InputDecoration(labelText: 'Pago Total'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _crearCita,
                child: const Text('Crear Cita'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
