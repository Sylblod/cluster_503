import 'package:flutter/material.dart';
import '../../services/data_service.dart';
import '../../models/evento_model.dart'; // Asegúrate de tener este modelo importado
import 'edit_events_screen.dart'; // Asegúrate de que esta pantalla acepte EventoTKD

class ViewEventsScreen extends StatefulWidget {
  const ViewEventsScreen({super.key});

  @override
  State<ViewEventsScreen> createState() => _ViewEventsScreenState();
}

class _ViewEventsScreenState extends State<ViewEventsScreen> {
  final DataService _dataService = DataService();

  // Cambiamos a listas de Eventos
  List<EventoTKD> _listaOriginal = [];
  List<EventoTKD> _listaFiltrada = []; 
  bool _isLoading = true;

  final TextEditingController _searchCtrl = TextEditingController();
  
  bool? _filtroActivo;
  String? _filtroTipo;

  @override
  void initState() {
    super.initState();
    _cargarEventos();
  }

  // Carga inicial de datos (Eventos)
  void _cargarEventos() async {
    setState(() => _isLoading = true);
    try {
      // Asumiendo que tu data_service tiene este método
      final eventos = await _dataService.getEventos();
      setState(() {
        _listaOriginal = eventos;
        _listaFiltrada = eventos;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar eventos: $e')),
        );
      }
    }
  }

  void _aplicarFiltros() {
    setState(() {
      _listaFiltrada = _listaOriginal.where((e) {
        // 1. Filtro de Texto (Título o Lugar)
        final textoBusqueda = _searchCtrl.text.toLowerCase();
        final coincideTexto = e.titulo.toLowerCase().contains(textoBusqueda) || 
                              e.lugar.toLowerCase().contains(textoBusqueda);

        
        final coincideActivo = _filtroActivo == null || e.activo == _filtroActivo;

        final coincideTipo = _filtroTipo == null || e.tipo == _filtroTipo;

        return coincideTexto && coincideActivo && coincideTipo;
      }).toList();
    });
  }

  void _editarEvento(EventoTKD evento) async {
    // Asegúrate de actualizar EditEventsScreen para recibir un 'evento' en lugar de 'usuario'
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditEventsScreen(evento: evento)),
    );
    if (resultado == true) _cargarEventos();
  }

  void _confirmarEliminar(EventoTKD evento) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('¿Eliminar evento?'),
        content: Text('Vas a eliminar el evento "${evento.titulo}".'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              // Asumiendo que existe deleteEvento en tu servicio
              bool exito = await _dataService.deleteEvento(evento.id);
              if (mounted && exito) {
                ScaffoldMessenger.of(context).showSnackBar(
                   const SnackBar(content: Text('Eliminado'), backgroundColor: Colors.green)
                );
                _cargarEventos();
              }
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Eventos'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _cargarEventos, 
          ),
        ],
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(10),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  // Buscador de Texto
                  TextField(
                    controller: _searchCtrl,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: "Buscar por título o lugar...",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    ),
                    onChanged: (val) => _aplicarFiltros(), 
                  ),
                  const SizedBox(height: 10),
                
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        // Filtro ESTADO (Adaptado a bool)
                        _crearDropdown<bool>(
                          titulo: "Estado",
                          valorActual: _filtroActivo,
                          items: const [
                            DropdownMenuItem(value: null, child: Text("Todos los Estados")),
                            DropdownMenuItem(value: true, child: Text("Activos", style: TextStyle(color: Colors.green))),
                            DropdownMenuItem(value: false, child: Text("Inactivos", style: TextStyle(color: Colors.red))),
                          ],
                          onChanged: (v) {
                            setState(() => _filtroActivo = v);
                            _aplicarFiltros();
                          },
                        ),
                        const SizedBox(width: 10),
                        _crearDropdown<String>(
                          titulo: "Tipo",
                          valorActual: _filtroTipo,
                          items: const [
                            DropdownMenuItem(value: null, child: Text("Todos los Tipos")),
                            DropdownMenuItem(value: "Examen", child: Text("Examen")),
                            DropdownMenuItem(value: "Torneo", child: Text("Torneo")),
                          ],
                          onChanged: (v) {
                            setState(() => _filtroTipo = v);
                            _aplicarFiltros();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _listaFiltrada.isEmpty
                    ? const Center(child: Text("No se encontraron eventos."))
                    : SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
                            columnSpacing: 20,
                            columns: const [
                              DataColumn(label: Text('Imagen')), // Nueva columna
                              DataColumn(label: Text('ID')),
                              DataColumn(label: Text('Título')),
                              DataColumn(label: Text('Fecha')),
                              DataColumn(label: Text('Lugar')),
                              DataColumn(label: Text('Tipo')),
                              DataColumn(label: Text('Estado')),
                              DataColumn(label: Text('Acciones')),
                            ],
                            rows: _listaFiltrada.map((evento) {
                              return DataRow(cells: [
                                // --- COLUMNA DE IMAGEN ---
                                DataCell(
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        evento.imagenUrl,
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            width: 50, height: 50,
                                            color: Colors.grey[200],
                                            child: const Icon(Icons.broken_image, color: Colors.grey),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                // --- DATOS DEL EVENTO ---
                                DataCell(Text(evento.id.toString())),
                                DataCell(Text(evento.titulo, style: const TextStyle(fontWeight: FontWeight.bold))),
                                DataCell(Text(evento.fecha)),
                                DataCell(Text(evento.lugar)),
                                DataCell(Text(evento.tipo)),
                                DataCell(
                                  Chip(
                                    label: Text(
                                      evento.activo ? 'Activo' : 'Inactivo',
                                      style: const TextStyle(color: Colors.white, fontSize: 12),
                                    ),
                                    backgroundColor: evento.activo ? Colors.green : Colors.grey,
                                  ),
                                ),
                                DataCell(
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _editarEvento(evento)),
                                      IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _confirmarEliminar(evento)),
                                    ],
                                  ),
                                ),
                              ]);
                            }).toList(),
                          ),
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  // Widget auxiliar para crear Dropdowns
  Widget _crearDropdown<T>({
    required String titulo, 
    required T? valorActual, 
    required List<DropdownMenuItem<T>> items,
    required Function(T?) onChanged
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(5),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: valorActual,
          hint: Text(titulo),
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }
}