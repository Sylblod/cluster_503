import 'package:flutter/material.dart'; // Necesario para forzar mayúsculas
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
  final _service = DataService(); 
  bool _isLoading = false;

  // --- 1. CONTROLADORES (Equivalente a los inputs de texto) ---
  final _nombreCtrl = TextEditingController();
  final _emailCtrl = TextEditingController(); // Nuevo
  final _edadCtrl = TextEditingController();
  final _escuelaCtrl = TextEditingController();
  final _maestroCtrl = TextEditingController(); // Nuevo

  // --- 2. VARIABLES DE ESTADO (Equivalente a selects y checkboxes) ---
  String? _ramaSeleccionada;
  String? _cintaSeleccionada;
  
  // Lista para guardar las modalidades seleccionadas (checkboxes múltiples)
  final List<String> _modalidadesSeleccionadas = [];
  
  // Variable para los Términos y Condiciones
  bool _terminosAceptados = false;

  // --- 3. LISTAS DE OPCIONES ---
  final List<String> _ramas = ['FEMENIL', 'VARONIL'];
  
  final List<String> _cintas = [
    'Blanca', 'Amarilla', 'Naranja', 'Verde', 'Azul', 'Morada', 
    'Cafe', 'Marron','Roja', 'Negra Poom', 'Negra Dan'
  ];

  final List<String> _opcionesModalidad = ['Formas', 'Combate', 'Circuito Motriz'];

  void _enviarFormulario() async {
    if (_formKey.currentState!.validate()) {
      
      // Validación manual para los términos
      if (!_terminosAceptados) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Debes aceptar los términos y condiciones')),
        );
        return;
      }

      // Validación manual para modalidad (al menos una seleccionada)
      if (_modalidadesSeleccionadas.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Selecciona al menos una modalidad')),
        );
        return;
      }

      setState(() => _isLoading = true);
      final datos = {
        "nombre": _nombreCtrl.text,
        "email": _emailCtrl.text,
        "edad": _edadCtrl.text,
        "rama": _ramaSeleccionada,
        "cinta": _cintaSeleccionada,
        "modalidad": _modalidadesSeleccionadas.join(","), // Envía una lista
        "escuela": _escuelaCtrl.text,
        "maestro": _maestroCtrl.text
      };

      final exito = await _service.inscribirAlumno(datos);

      setState(() => _isLoading = false);

      if (mounted && exito) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Inscripción enviada!')),
        );
        Navigator.pop(context); 
      }
    }
  }

  // --- MOSTRAR MODAL ---
  void _mostrarTerminos() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Términos y Condiciones"),
        content: SingleChildScrollView(
          child: const Text(
            "Acepto los términos y condiciones relacionados con la participación... "
            "estoy de acuerdo en cumplir con ellos en su totalidad."
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cerrar"),
          ),
        ],
      ),
    );
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- SECCIÓN 1: DATOS PERSONALES ---
              const Text("Datos Personales", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Divider(),
              
              // Nombre (HTML: class="mayusculas")
              TextFormField(
                controller: _nombreCtrl,
                decoration: const InputDecoration(labelText: "Nombre Completo"),
                textCapitalization: TextCapitalization.characters, // Teclado en mayúsculas
                validator: (v) => v!.isEmpty ? "Requerido" : null,
              ),
              const SizedBox(height: 10),

              // Email
              TextFormField(
                controller: _emailCtrl,
                decoration: const InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
                validator: (v) => v!.isEmpty || !v.contains('@') ? "Email inválido" : null,
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  // Edad
                  Expanded(
                    child: TextFormField(
                      controller: _edadCtrl,
                      decoration: const InputDecoration(labelText: "Edad"),
                      keyboardType: TextInputType.number,
                      validator: (v) => v!.isEmpty ? "Requerido" : null,
                    ),
                  ),
                  const SizedBox(width: 15),
                  // Rama (Select)
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _ramaSeleccionada,
                      items: _ramas.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                      onChanged: (v) => setState(() => _ramaSeleccionada = v),
                      decoration: const InputDecoration(labelText: "Rama"),
                      validator: (v) => v == null ? "Requerido" : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // --- SECCIÓN 2: CATEGORÍA ---
              const Text("Categoría y Modalidad", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Divider(),

              // Cinta (Select)
              DropdownButtonFormField<String>(
                value: _cintaSeleccionada,
                items: _cintas.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (v) => setState(() => _cintaSeleccionada = v),
                decoration: const InputDecoration(labelText: "Cinta"),
                validator: (v) => v == null ? "Requerido" : null,
              ),
              const SizedBox(height: 15),

              // Modalidad (Checkboxes múltiples)
              const Text("Modalidad (Selecciona una o varias):"),
              ..._opcionesModalidad.map((modalidad) {
                return CheckboxListTile(
                  title: Text(modalidad),
                  value: _modalidadesSeleccionadas.contains(modalidad),
                  onChanged: (bool? seleccionado) {
                    setState(() {
                      if (seleccionado == true) {
                        _modalidadesSeleccionadas.add(modalidad);
                      } else {
                        _modalidadesSeleccionadas.remove(modalidad);
                      }
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  dense: true,
                );
              }).toList(),
              
              const SizedBox(height: 20),

              // --- SECCIÓN 3: ESCUELA ---
              const Text("Datos de la Escuela", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Divider(),

              // Escuela (Solo Mayúsculas)
              TextFormField(
                controller: _escuelaCtrl,
                decoration: const InputDecoration(labelText: "Nombre de Institución/Escuela"),
                textCapitalization: TextCapitalization.characters,
                validator: (v) => v!.isEmpty ? "Requerido" : null,
              ),
              const SizedBox(height: 10),

              // Maestro (Solo Mayúsculas)
              TextFormField(
                controller: _maestroCtrl,
                decoration: const InputDecoration(labelText: "Nombre del Maestro/a"),
                textCapitalization: TextCapitalization.characters,
                validator: (v) => v!.isEmpty ? "Requerido" : null,
              ),
              const SizedBox(height: 20),

              // --- SECCIÓN 4: TÉRMINOS ---
              InkWell(
                onTap: _mostrarTerminos, // Abre el "Modal"
                child: const Text(
                  "Ver Términos y Condiciones (Click aquí)",
                  style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                ),
              ),
              CheckboxListTile(
                title: const Text("Acepto los términos y condiciones"),
                value: _terminosAceptados,
                onChanged: (v) => setState(() => _terminosAceptados = v!),
                controlAffinity: ListTileControlAffinity.leading,
              ),

              const SizedBox(height: 30),

              // BOTÓN ENVIAR
              ElevatedButton(
                onPressed: _isLoading ? null : _enviarFormulario,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.blueAccent, // Color similar a tu botón HTML
                  foregroundColor: Colors.white
                ),
                child: _isLoading 
                  ? const CircularProgressIndicator(color: Colors.white) 
                  : const Text("ENVIAR", style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    _nombreCtrl.dispose();
    _emailCtrl.dispose();
    _edadCtrl.dispose();
    _escuelaCtrl.dispose();
    _maestroCtrl.dispose();
    super.dispose();
  }
}