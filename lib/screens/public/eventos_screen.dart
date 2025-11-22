import 'package:flutter/material.dart';
import '../../models/evento_model.dart';
import '../../services/data_service.dart';
import 'inscripcion_form_screen.dart'; // Necesitamos importar el formulario

class EventosScreen extends StatefulWidget {
  const EventosScreen({super.key});

  @override
  State<EventosScreen> createState() => _EventosScreenState();
}

class _EventosScreenState extends State<EventosScreen> {
  final DataService _service = DataService();
  late Future<List<EventoTKD>> _eventosFuture;

  @override
  void initState() {
    super.initState();
    _eventosFuture = _service.getEventos(); // Cargamos los eventos al iniciar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Eventos Disponibles")),
      body: FutureBuilder<List<EventoTKD>>(
        future: _eventosFuture,
        builder: (context, snapshot) {
          // 1. Cargando...
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } 
          // 2. Error
          else if (snapshot.hasError) {
            return const Center(child: Text("Error al cargar eventos"));
          } 
          // 3. Datos listos
          else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No hay eventos"));
          }

          // 4. Dibujar la lista
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final evento = snapshot.data![index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  leading: const Icon(Icons.event, size: 40, color: Colors.orange),
                  title: Text(evento.titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("${evento.fecha} - ${evento.lugar}"),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Navegar al formulario enviando el evento seleccionado
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InscripcionFormScreen(evento: evento),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}