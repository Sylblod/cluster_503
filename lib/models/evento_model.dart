class EventoTKD {
  final int id;
  final String titulo;
  final String fecha;
  final String lugar;
  final String tipo;
  final String imagenUrl;
  final bool activo;

  EventoTKD({
    required this.id,
    required this.titulo,
    required this.fecha,
    required this.lugar,
    required this.tipo,
    required this.imagenUrl,
    required this.activo,
  });

  factory EventoTKD.fromJson(Map<String, dynamic> json) {
    return EventoTKD(
      id: json['id'] ?? 0,
      titulo: json['titulo'] ?? 'Sin título',
      fecha: json['fecha'] ?? '',
      lugar: json['lugar'] ?? '',
      tipo: json['tipo'] ?? 'torneo',
      imagenUrl: json['imagenUrl'] ?? 'https://cluster503.com/assets/no-image.png',
      activo: (json['activo'] == 1), 
    );
  }
}