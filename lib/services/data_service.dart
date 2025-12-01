import '../models/evento_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;// Ajusta esta ruta a donde esté tu modelo

class DataService {
  //ver eventos
  final String apiEventos = "https://fr1.cluster503rj.workers.dev/api/eventos";
  //modo general
  final String apiInserta = "https://fr1.cluster503rj.workers.dev/api/insertar";

  Future<List<EventoTKD>> getEventos() async {
    try {
      final response = await http.get(Uri.parse(apiEventos));

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
    try {
      String cuerpoJson = jsonEncode(datos);
      final response = await http.post(
        Uri.parse(apiInserta), 
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: cuerpoJson,
      );

      // Verificamos si el servidor respondió con éxito (200 OK o 201 Created)
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Inscripción exitosa: ${response.body}");
        return true; 
      } else {
        print("Error en el servidor: ${response.statusCode} - ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error de conexión al enviar: $e");
      return false;
    }
  }
}