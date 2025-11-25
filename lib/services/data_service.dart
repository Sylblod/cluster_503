import '../models/evento_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;// Ajusta esta ruta a donde esté tu modelo

class DataService {
  // Poner aquí la URL de tu Worker de Cloudflare
  final String apiUrl = "https://fr1.cluster503rj.workers.dev/api/eventos"; 

  Future<List<EventoTKD>> getEventos() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // Decodificar el JSON
        List<dynamic> body = jsonDecode(response.body);
        
        // Convertir la lista de JSONs a lista de EventoTKD
        List<EventoTKD> eventos = body
            .map((dynamic item) => EventoTKD.fromJson(item))
            .toList();
            
        return eventos;
      } else {
        throw Exception('Fallo al cargar eventos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<bool> inscribirAlumno(Map<String, dynamic> datos) async {
    await Future.delayed(const Duration(seconds: 2));
    // Aquí iría el código real de http.post
    print("Enviando a Cloudflare: $datos");
    return true;
  }
}