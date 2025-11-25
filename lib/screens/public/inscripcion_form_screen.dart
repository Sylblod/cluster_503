import 'package:flutter/material.dart';
import '../../models/evento_model.dart'; 
import '../../services/data_service.dart';

class InscripcionFormScreen extends StatefulWidget {
  final EventoTKD evento;

  const InscripcionFormScreen({super.key, required this.evento});

  @override
  State<InscripcionFormScreen> createState() => _InscripcionFormScreenState();
}

class _InscripcionFormScreenState extends State<InscripcionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _service = DataService(); // Instancia del servicio
  bool _isLoading = false;

 
  final _nombreCtrl = TextEditingController();
  final _edadCtrl = TextEditingController();
  final _escuelaCtrl = TextEditingController();
  String? _cintaSeleccionada;

  final List<String> _cintas = [
    'Blanca', 'Amarilla', 'Naranja', 'Verde', 'Azul', 'Morada', 'Cafe', 'Marron','Roja', 'Negra Poom', 'Negra Dan'
  ];

  void _enviarFormulario() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

     
      final datos = {
        "evento_id": widget.evento.id,
        "nombre": _nombreCtrl.text,
        "edad": _edadCtrl.text,
        "cinta": _cintaSeleccionada,
        "escuela": _escuelaCtrl.text,
      };

    
      final exito = await _service.inscribirAlumno(datos);

      setState(() => _isLoading = false);

      if (mounted) {
        if (exito) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('¡Inscripción enviada!')),
          );
          Navigator.pop(context); // Regresar a la lista
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Inscripción a ${widget.evento.titulo}")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nombreCtrl,
                decoration: const InputDecoration(labelText: "Nombre del Alumno"),
                validator: (v) => v!.isEmpty ? "Requerido" : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _edadCtrl,
                decoration: const InputDecoration(labelText: "Edad"),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? "Requerido" : null,
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField(
                value: _cintaSeleccionada,
                items: _cintas.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (v) => setState(() => _cintaSeleccionada = v),
                decoration: const InputDecoration(labelText: "Cinta"),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _isLoading ? null : _enviarFormulario,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50), 
                ),
                child: _isLoading 
                  ? const CircularProgressIndicator(color: Colors.white) 
                  : const Text("ENVIAR INSCRIPCIÓN"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}