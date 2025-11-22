import '../models/evento_model.dart';

class DataService {

  Future<List<EventoTKD>> getEventos() async {
    await Future.delayed(const Duration(seconds: 1)); // Simula espera de internet
    return [
      EventoTKD(
        id: '1',
        titulo: 'Gran Torneo Regional 2025',
        fecha: '15 Nov 2025',
        lugar: 'Gimnasio Polifuncional',
        tipo: EventType.torneo,
        imagenUrl: 'https://via.placeholder.com/150/FF9800/FFFFFF?text=Torneo',
      ),
      EventoTKD(
        id: '2',
        titulo: 'Examen de Cintas Negras',
        fecha: '20 Dic 2025',
        lugar: 'Dojo Central Cluster 503',
        tipo: EventType.examen,
        imagenUrl: 'https://via.placeholder.com/150/2196F3/FFFFFF?text=Examen',
      ),
    ];
  }

  // Simulación de enviar datos (POST)
  Future<bool> inscribirAlumno(Map<String, dynamic> datos) async {
    await Future.delayed(const Duration(seconds: 2));
    // Aquí iría el código real de http.post
    print("Enviando a Cloudflare: $datos");
    return true;
  }
}