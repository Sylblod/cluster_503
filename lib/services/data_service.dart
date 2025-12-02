import '../models/evento_model.dart';
import '../models/user_model.dart';
import '../models/participants_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DataService {
  //ver eventos
  final String apiEventos = "https://fr1.cluster503rj.workers.dev/api/eventos";
  final String apiActualizarEvento = "https://fr1.cluster503rj.workers.dev/api/evento/actualizar";
  final String apiCrearEvento = "https://fr1.cluster503rj.workers.dev/api/evento/insertar";
  final String apiEliminarEvento = "https://fr1.cluster503rj.workers.dev/api/evento/eliminar";

  //modo general
  final String apiInserta = "https://fr1.cluster503rj.workers.dev/api/insertar";
  //Login
  final String apiLogin = "https://fr1.cluster503rj.workers.dev/api/login";
  //usuarios
  //insertar
  final String apiInsertarUsuario = "https://fr1.cluster503rj.workers.dev/api/insertar/users";
  //mostrar usuarios
  final String apiMostrarUsuarios = "https://fr1.cluster503rj.workers.dev/api/user/listar";
  final String apiActualizarUsuario = "https://fr1.cluster503rj.workers.dev/api/user/actualizar";
  final String apiEliminarUsuario = "https://fr1.cluster503rj.workers.dev/api/user/eliminar";
  //participantes
  final String apiMostrarParticipantes = "https://fr1.cluster503rj.workers.dev/api/listar";

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

  Future<UsuarioTKD> login(Map<String, dynamic> datos) async {
    try {
      String cuerpoJson = jsonEncode(datos);
      final response = await http.post(
        Uri.parse(apiLogin), 
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: cuerpoJson,
      );
     if (response.statusCode == 200) {

      final Map<String, dynamic> respuestaJson = jsonDecode(response.body);
      
      final Map<String, dynamic> datosUsuario = respuestaJson['usuario'];

      return UsuarioTKD.fromJson(datosUsuario);
      
    } else {
      print("Error login: ${response.body}");
      throw Exception('Fallo al iniciar sesión: ${response.statusCode}');
    }
    } catch (e) {
      print("Error de conexión al iniciar sesión: $e");
      throw Exception('Error de conexión: $e');
    }
  }

  Future<Map<String, dynamic>> insertarUsuario(Map<String, dynamic> datos) async {
    try {
      String cuerpoJson = jsonEncode(datos);
      final response = await http.post(
        Uri.parse(apiInsertarUsuario),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: cuerpoJson,
      );
      final Map<String, dynamic> respuestaDecodificada = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          "success": true,
          "message": respuestaDecodificada['message'] ?? "Registro exitoso"
        };
      } else {
        return {
          "success": false,
          "message": respuestaDecodificada['error'] ?? "Error desconocido en el servidor"
        };
      }
    } catch (e) {
      return {
        "success": false,
        "message": "Error de conexión: $e"
      };
    }
  }

 Future<List<UsuarioTKD>> getUsuarios() async {
    try {
      final response = await http.get(Uri.parse(apiMostrarUsuarios));

      if (response.statusCode == 200) {
       
        List<dynamic> body = jsonDecode(response.body);

        List<UsuarioTKD> usuarios = body
            .map((dynamic item) => UsuarioTKD.fromJson(item))
            .toList();
        return usuarios;
      } else {
        throw Exception('Fallo al cargar usuarios: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<bool> updateUsuario(UsuarioTKD usuario) async {
  try {
     final response = await http.put(Uri.parse(apiActualizarUsuario),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(usuario.toJson()),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Error al actualizar: ${response.body}');
      return false;
    }
  } catch (e) {
    print('Error de conexión: $e');
    return false;
  }
}

  Future<bool> deleteUsuario(int id) async {
  try {
    final response = await http.delete(Uri.parse('$apiEliminarUsuario?id=$id'), 
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Error al eliminar: ${response.body}');
      return false;
    }
  } catch (e) {
    print('Error de conexión: $e');
    return false;
  }
  }

  Future<List<ParticipantesTKD>> getParticipantes() async {
    try {
      final response = await http.get(Uri.parse(apiMostrarParticipantes));

      if (response.statusCode == 200) {
       
        List<dynamic> body = jsonDecode(response.body);

        List<ParticipantesTKD> participantes = body
            .map((dynamic item) => ParticipantesTKD.fromJson(item))
            .toList();
        return participantes;
      } else {
        throw Exception('Fallo al cargar participantes: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<bool> deleteEvento(int id) async {
  try {
    final response = await http.delete(Uri.parse('$apiActualizarEvento?id=$id'), 
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Error al eliminar: ${response.body}');
      return false;
    }
  } catch (e) {
    print('Error de conexión: $e');
    return false;
  }
  }

  Future<bool> updateEvento(EventoTKD eventos) async {
  try {
     final response = await http.put(Uri.parse(apiActualizarEvento),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(eventos.toJson()),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Error al actualizar: ${response.body}');
      return false;
    }
  } catch (e) {
    print('Error de conexión: $e');
    return false;
  }
}

  Future<Map<String, dynamic>> insertarEvento(Map<String, dynamic> datos) async {
    try {
      String cuerpoJson = jsonEncode(datos);
      final response = await http.post(
        Uri.parse(apiCrearEvento),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: cuerpoJson,
      );
      final Map<String, dynamic> respuestaDecodificada = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          "success": true,
          "message": respuestaDecodificada['message'] ?? "Registro exitoso"
        };
      } else {
        return {
          "success": false,
          "message": respuestaDecodificada['error'] ?? "Error desconocido en el servidor"
        };
      }
    } catch (e) {
      return {
        "success": false,
        "message": "Error de conexión: $e"
      };
    }
  }

}