class UsuarioTKD {
  final int id;
  final String email;
  final String nombreCompleto; 
  final String rol;
  final String? token;

  UsuarioTKD({
    required this.id,
    required this.email,
    required this.nombreCompleto,
    required this.rol,
    this.token,
  });

  // Factory para convertir el JSON de Cloudflare a tu Objeto Dart
  factory UsuarioTKD.fromJson(Map<String, dynamic> json) {
    return UsuarioTKD(
      id: json['id'], 
      email: json['email'],
      // Ojo aquí: mapeamos la clave del JSON a la variable de Dart
      nombreCompleto: json['nombre_completo'] ?? 'Sin Nombre', 
      rol: json['rol'] ?? 'usuario',
      token: json['token'],
    );
  }

  // Para guardar el usuario (útil más adelante)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'nombre_completo': nombreCompleto,
      'rol': rol,
      'token': token,
    };
  }
}