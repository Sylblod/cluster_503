class UsuarioTKD {
  final int id;
  final int activo;
  final String email;
  final String nombreCompleto;
  final String rol;
  final String? token;
  final String event;

  UsuarioTKD({
    required this.id,
    required this.activo,
    required this.email,
    required this.nombreCompleto,
    required this.rol,
    required this.token,
    required this.event,
  });

  factory UsuarioTKD.fromJson(Map<String, dynamic> json) {
    return UsuarioTKD(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      nombreCompleto: json['name'] ?? 'Sin Nombre',
      rol: json['role'] ?? '',
      token: json['reset_token'],
      event: json['event'] ?? '',
      activo: json['is_active'] ?? 0, 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': nombreCompleto,
      'role': rol,
      'reset_token': token,
      'event': event,
      'is_active': activo,
    };
  }
}