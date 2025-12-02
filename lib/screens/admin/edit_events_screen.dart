import 'package:flutter/material.dart';
import '../../services/data_service.dart';
import '../../models/evento_model.dart'; 

class EditEventsScreen extends StatefulWidget {
  final EventoTKD? evento; 

  const EditEventsScreen({super.key, this.evento});
  
  @override
  State<EditEventsScreen> createState() => _EditEventsScreenState();
}

class _EditEventsScreenState extends State<EditEventsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _service = DataService(); 
  bool _isLoading = false;

  final _tituloCtrl = TextEditingController();
  final _fechaCtrl = TextEditingController();
  final _lugarCtrl = TextEditingController();
  final _imagenUrlCtrl = TextEditingController();
  
  String? _tipoSeleccionado; 
  bool _isActive = true;
  @override
  void initState() {
    super.initState();
    
    if (widget.evento != null) {
      _tituloCtrl.text = widget.evento!.titulo;
      _fechaCtrl.text = widget.evento!.fecha;
      _lugarCtrl.text = widget.evento!.lugar;
      _imagenUrlCtrl.text = widget.evento!.imagenUrl;
      _tipoSeleccionado = widget.evento!.tipo; 
      _isActive = widget.evento!.activo; 
    }
  }
  void _enviarFormulario() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      bool exito = false;
       
      final eventoEditado = EventoTKD(
        id: widget.evento!.id,
        titulo: _tituloCtrl.text.trim(),
        fecha: _fechaCtrl.text.trim(),
        lugar: _lugarCtrl.text.trim(),
        
        // Aquí enviamos lo que seleccionó en el Dropdown
        tipo: _tipoSeleccionado!, 
        
        imagenUrl: _imagenUrlCtrl.text.trim(),
        activo: _isActive,
      );

      exito = await _service.updateEvento(eventoEditado);
    

      setState(() => _isLoading = false);

      if (mounted) {
        if (exito) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Evento guardado correctamente"), backgroundColor: Colors.green),
          );
          Navigator.pop(context, true); 
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Error al guardar el evento"), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Editar Evento"), backgroundColor: Colors.teal,),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Información del Evento", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Divider(),
              
              // Título
              TextFormField(
                controller: _tituloCtrl,
                decoration: const InputDecoration(
                  labelText: "Título del Evento",
                  prefixIcon: Icon(Icons.title),
                ),
                textCapitalization: TextCapitalization.sentences,
                validator: (v) => v!.isEmpty ? "El título es requerido" : null,
              ),
              const SizedBox(height: 15),

              // --- AQUÍ AGREGUÉ EL DROPDOWN (SELECTOR) ---
              DropdownButtonFormField<String>(
                value: _tipoSeleccionado,
                decoration: const InputDecoration(
                  labelText: "Tipo de Evento",
                  prefixIcon: Icon(Icons.category),
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: "Examen", child: Text("Examen")),
                  DropdownMenuItem(value: "Torneo", child: Text("Torneo")),
                ],
                onChanged: (valor) {
                  setState(() {
                    _tipoSeleccionado = valor;
                  });
                },
                validator: (value) => value == null ? "Selecciona el tipo de evento" : null,
              ),
              const SizedBox(height: 15),

              // Fecha
              TextFormField(
                controller: _fechaCtrl,
                decoration: const InputDecoration(
                  labelText: "Fecha",
                  hintText: "Ej. 2024-10-25",
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                validator: (v) => v!.isEmpty ? "La fecha es requerida" : null,
              ),
              const SizedBox(height: 15),

              // Lugar
              TextFormField(
                controller: _lugarCtrl,
                decoration: const InputDecoration(
                  labelText: "Lugar",
                  prefixIcon: Icon(Icons.location_on),
                ),
                validator: (v) => v!.isEmpty ? "El lugar es requerido" : null,
              ),
              const SizedBox(height: 15),

              // URL de Imagen
              TextFormField(
                controller: _imagenUrlCtrl,
                decoration: const InputDecoration(
                  labelText: "URL de Imagen",
                  hintText: "https://ejemplo.com/imagen.jpg",
                  prefixIcon: Icon(Icons.image),
                ),
                keyboardType: TextInputType.url,
                validator: (v) => v!.isEmpty ? "La imagen es requerida" : null,
              ),
              const SizedBox(height: 20),

              // Switch Activo
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text("Evento Activo"),
                subtitle: Text(_isActive ? "Inscripciones Abiertas" : "Inscripciones Cerradas"),
                value: _isActive,
                activeColor: Colors.green,
                onChanged: (val) {
                  setState(() {
                    _isActive = val;
                  });
                },
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: _isLoading ? null : _enviarFormulario,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white
                ),
                child: _isLoading 
                  ? const CircularProgressIndicator(color: Colors.white) 
                  : Text("GUARDAR CAMBIOS", style: const TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    _tituloCtrl.dispose();
    _fechaCtrl.dispose();
    _lugarCtrl.dispose();
    _imagenUrlCtrl.dispose();
    // No necesitamos dispose para _tipoSeleccionado porque es un String
    super.dispose();
  }
}