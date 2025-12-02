import 'package:flutter/material.dart';
import '../../services/data_service.dart';

class CreateEventsScreen extends StatefulWidget {
  const CreateEventsScreen({super.key});
  
  @override
  State<CreateEventsScreen> createState() => _CreateEventsScreenState();
}

class _CreateEventsScreenState extends State<CreateEventsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _service = DataService(); 
  bool _isLoading = false;

  // Controladores para Eventos
  final _tituloCtrl = TextEditingController();
  final _fechaCtrl = TextEditingController();
  final _lugarCtrl = TextEditingController();
  final _imagenUrlCtrl = TextEditingController();
  
  // Variables para Dropdown y Switch
  String? _tipoSeleccionado;
  bool _activo = true; // Por defecto el evento nace activo

  // Opciones fijas como pediste
  final List<String> _tiposEventos = ['Examen', 'Torneo'];

  void _enviarFormulario() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Preparamos el mapa de datos igual que la tabla de base de datos
      final datos = {
        "titulo": _tituloCtrl.text.trim(),
        "fecha": _fechaCtrl.text.trim(),
        "lugar": _lugarCtrl.text.trim(),
        "tipo": _tipoSeleccionado,
        "imagenUrl": _imagenUrlCtrl.text.trim(),
        "activo": _activo,
      };
      final resultados = await _service.insertarEvento(datos); 

      setState(() => _isLoading = false);

      if (mounted) {
        if (resultados['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registro exitoso!'),
              backgroundColor: Colors.green, // Verde para éxito
            ),
          );
          Navigator.pop(context);
        } else {
          // SI FALLA: Leemos el mensaje exacto que vino del Worker
          String mensajeError = resultados['message']; 
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(mensajeError), 
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crear Nuevo Evento"), 
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Detalles del Evento", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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

              // Tipo (Dropdown)
              DropdownButtonFormField<String>(
                value: _tipoSeleccionado,
                items: _tiposEventos.map((tipo) => DropdownMenuItem(value: tipo, child: Text(tipo))).toList(),
                onChanged: (v) => setState(() => _tipoSeleccionado = v),
                decoration: const InputDecoration(
                  labelText: "Tipo de Evento",
                  prefixIcon: Icon(Icons.category),
                  border: OutlineInputBorder()
                ),
                validator: (v) => v == null ? "Selecciona un tipo" : null,
              ),
              const SizedBox(height: 15),

              // Fecha
              TextFormField(
                controller: _fechaCtrl,
                decoration: const InputDecoration(
                  labelText: "Fecha (YYYY-MM-DD)",
                  prefixIcon: Icon(Icons.calendar_today),
                  hintText: "Ej. 2023-12-15"
                ),
                validator: (v) => v!.isEmpty ? "La fecha es requerida" : null,
              ),
              const SizedBox(height: 15),

              // Lugar
              TextFormField(
                controller: _lugarCtrl,
                decoration: const InputDecoration(
                  labelText: "Lugar / Ubicación",
                  prefixIcon: Icon(Icons.location_on)
                ),
                validator: (v) => v!.isEmpty ? "El lugar es requerido" : null,
              ),
              const SizedBox(height: 15),

              // Imagen URL
              TextFormField(
                controller: _imagenUrlCtrl,
                decoration: const InputDecoration(
                  labelText: "URL de la Imagen",
                  prefixIcon: Icon(Icons.image),
                  hintText: "https://..."
                ),
                keyboardType: TextInputType.url,
                validator: (v) => v!.isEmpty ? "La imagen es requerida" : null,
              ),
              const SizedBox(height: 15),

              // Switch Activo
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text("Publicar inmediatamente"),
                subtitle: Text(_activo ? "El evento será visible" : "Se guardará como borrador"),
                value: _activo,
                activeColor: Colors.teal,
                onChanged: (val) => setState(() => _activo = val),
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
                  : const Text("CREAR EVENTO", style: TextStyle(fontSize: 16)),
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
    super.dispose();
  }
}