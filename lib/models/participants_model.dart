class ParticipantesTKD {
  final int id;
  final String nombre;
  final String email;
  final String edad;
  final String rama;
  final String modalidad;
  final String cinta;
  final String escuela;
  final String maestro;

  ParticipantesTKD({
    required this.id,
    required this.nombre,
    required this.email,
    required this.edad,
    required this.rama,
    required this.modalidad,
    required this.cinta,
    required this.escuela,
    required this.maestro,
  });

  factory ParticipantesTKD.fromJson(Map<String, dynamic> json) {
    return ParticipantesTKD(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      nombre: json['nombre'] ?? 'Sin Nombre',
      edad: json['edad'] ?? '',
      rama: json['rama'] ?? '',
      modalidad: json['modalidad'] ?? '',
      cinta: json['cinta'] ?? '',
      escuela: json['escuela'] ?? '',
      maestro: json['maestro'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'nombre': nombre,
      'edad': edad,
      'rama': rama,
      'modalidad': modalidad,
      'cinta': cinta,
      'escuela': escuela,
      'maestro': maestro,
    };
  }
}