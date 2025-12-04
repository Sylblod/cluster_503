import 'package:flutter/material.dart';
import '../../services/data_service.dart';
import '../../models/participants_model.dart'; 

class EditParticipantsScreen extends StatefulWidget {
  final ParticipantesTKD? participante; 

  const EditParticipantsScreen({super.key, this.participante});
  
  @override
  State<EditParticipantsScreen> createState() => _EditParticipantsScreenState();
}

class _EditParticipantsScreenState extends State<EditParticipantsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _service = DataService(); 
  bool _isLoading = false;

  final _nombreCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _edadCtrl = TextEditingController();
  final _escuelaCtrl = TextEditingController();
  final _maestroCtrl = TextEditingController();

  String? _ramaSeleccionada;
  String? _cintaSeleccionada;
  final List<String> _modalidadesSeleccionadas = [];

  final List<String> _ramas = ['FEMENIL', 'VARONIL'];
  
  final List<String> _cintas = [
    'Blanca', 'Amarilla', 'Naranja', 'Verde', 'Azul', 'Morada', 
    'Cafe', 'Marron','Roja', 'Negra Poom', 'Negra Dan'
  ];

  final List<String> _opcionesModalidad = ['Formas', 'Combate', 'Circuito Motriz'];

  @override
  void initState() {
    super.initState();
    if (widget.participante != null){
      _nombreCtrl.text = widget.participante!.nombre;
      _emailCtrl.text = widget.participante!.email;
      _edadCtrl.text = widget.participante!.edad;
      _escuelaCtrl.text = widget.participante!.escuela;
      _maestroCtrl.text = widget.participante!.maestro;
    }

    if (_ramas.contains(widget.participante!.rama)) {
      _ramaSeleccionada = widget.participante!.rama;
    }
    if (_cintas.contains(widget.participante!.cinta)) {
      _cintaSeleccionada = widget.participante!.cinta;
    }
    if (widget.participante!.modalidad.isNotEmpty) {
      final listaModalidades = widget.participante!.modalidad.split(',');
      // Limpiamos espacios en blanco por si acaso "Formas, Combate"
      for (var mod in listaModalidades) {
        String limpia = mod.trim();
        if (_opcionesModalidad.contains(limpia)) {
          _modalidadesSeleccionadas.add(limpia);
        }
      }
    }
  }

  void _enviarFormulario() async {
    if (_formKey.currentState!.validate()) {
      
      if (_modalidadesSeleccionadas.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Selecciona al menos una modalidad')),
        );
        return;
      }

      setState(() => _isLoading = true);
      bool exito = false;

      final datos = ParticipantesTKD(
        id: widget.participante!.id,
        nombre: _nombreCtrl.text,
        email: _emailCtrl.text,
        edad: _edadCtrl.text,
        rama: _ramaSeleccionada!,
        cinta: _cintaSeleccionada!,
        modalidad: _modalidadesSeleccionadas.join(","),
        escuela: _escuelaCtrl.text,
        maestro: _maestroCtrl.text
      );

      exito = await _service.updateParticipante(datos); 

      setState(() => _isLoading = false);

      if (mounted) {
        if (exito) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Participante actualizado correctamente"), backgroundColor: Colors.green),
          );
          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Error al actualizar"), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Participante"), 
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
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
              
              TextFormField(
                controller: _nombreCtrl,
                decoration: const InputDecoration(labelText: "Nombre Completo"),
                textCapitalization: TextCapitalization.characters,
                validator: (v) => v!.isEmpty ? "Requerido" : null,
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: _emailCtrl,
                decoration: const InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
                validator: (v) => v!.isEmpty || !v.contains('@') ? "Email inválido" : null,
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _edadCtrl,
                      decoration: const InputDecoration(labelText: "Edad"),
                      keyboardType: TextInputType.number,
                      validator: (v) => v!.isEmpty ? "Requerido" : null,
                    ),
                  ),
                  const SizedBox(width: 15),
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

              DropdownButtonFormField<String>(
                value: _cintaSeleccionada,
                items: _cintas.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (v) => setState(() => _cintaSeleccionada = v),
                decoration: const InputDecoration(labelText: "Cinta"),
                validator: (v) => v == null ? "Requerido" : null,
              ),
              const SizedBox(height: 15),

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

              TextFormField(
                controller: _escuelaCtrl,
                decoration: const InputDecoration(labelText: "Nombre de Institución/Escuela"),
                textCapitalization: TextCapitalization.characters,
                validator: (v) => v!.isEmpty ? "Requerido" : null,
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: _maestroCtrl,
                decoration: const InputDecoration(labelText: "Nombre del Maestro/a"),
                textCapitalization: TextCapitalization.characters,
                validator: (v) => v!.isEmpty ? "Requerido" : null,
              ),
              const SizedBox(height: 30),

              // BOTÓN GUARDAR
              ElevatedButton(
                onPressed: _isLoading ? null : _enviarFormulario,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white
                ),
                child: _isLoading 
                  ? const CircularProgressIndicator(color: Colors.white) 
                  : const Text("GUARDAR CAMBIOS", style: TextStyle(fontSize: 16)),
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