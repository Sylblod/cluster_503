enum EventType { torneo, examen }

class EventoTKD {
  final String id;
  final String titulo;
  final String fecha;
  final String lugar;
  final EventType tipo;
  final String imagenUrl;

  EventoTKD({
    required this.id,
    required this.titulo,
    required this.fecha,
    required this.lugar,
    required this.tipo,
    required this.imagenUrl,
  });
}