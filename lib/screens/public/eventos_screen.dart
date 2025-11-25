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
    _eventosFuture = _service.getEventos();
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

         return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final evento = snapshot.data![index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 16),
                child: InkWell(
                  onTap: () {
                    if (evento.activo) {
                      Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InscripcionFormScreen(evento: evento),
                      ),
                    );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Las inscripciones para este evento están cerradas.'),
                          duration: Duration(seconds: 3),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                    
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(4)), // Redondea esquinas superiores
                        child: Image.network(
                          evento.imagenUrl, // <--- Aquí la App busca el link en internet
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover, // <--- Esto hace que la imagen llene el espacio sin deformarse

                          // Muestra una ruedita cargando mientras baja la imagen
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              height: 120,
                              color: Colors.grey.shade200,
                              child: const Center(child: CircularProgressIndicator()),
                            );
                          },

                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 120,
                              width: double.infinity,
                              color: Colors.grey.shade300,
                              child: const Icon(Icons.broken_image, color: Colors.grey),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Chip(
                                  label: Text(evento.tipo == 'Torneo' ? "TORNEO" : "EXAMEN"),
                                  backgroundColor: evento.tipo == 'Examen' 
                                      ? Colors.orange.shade100 
                                      : Colors.blue.shade100,
                                  labelStyle: TextStyle(
                                    color: evento.tipo == 'Examen' 
                                        ? Colors.orange.shade900 
                                        : Colors.blue.shade900,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                                Chip(
                                  label: Text(evento.activo ? "INSCRIPCIONES ABIERTAS" : "INSCRIPCIONES CERRADAS"),
                                  backgroundColor: evento.activo 
                                      ? Colors.green.shade100 
                                      : Colors.red.shade100,
                                  labelStyle: TextStyle(
                                    color: evento.activo 
                                        ? Colors.green.shade900 
                                        : Colors.red.shade900,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                                Text(evento.fecha, style: const TextStyle(color: Colors.grey)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              evento.titulo,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF1565C0),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(evento.lugar),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );


        },
        
      ),
    );
  }
}