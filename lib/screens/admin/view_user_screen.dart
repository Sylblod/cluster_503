import 'package:flutter/material.dart';
import '../../services/data_service.dart';
import '../../models/user_model.dart';
import 'edit_users_screen.dart';

class ViewUserScreen extends StatefulWidget {
  const ViewUserScreen({super.key});

  @override
  State<ViewUserScreen> createState() => _ViewUserScreenState();
}

class _ViewUserScreenState extends State<ViewUserScreen> {
  final DataService _dataService = DataService();

  List<UsuarioTKD> _listaOriginal = [];
  List<UsuarioTKD> _listaFiltrada = []; 
  bool _isLoading = true;

 
  final TextEditingController _searchCtrl = TextEditingController();
  String? _filtroRol;   
  int? _filtroActivo;
  String? _filtroEvento;

  @override
  void initState() {
    super.initState();
    _cargarUsuarios();
  }

  // Carga inicial de datos
  void _cargarUsuarios() async {
    setState(() => _isLoading = true);
    try {
      final usuarios = await _dataService.getUsuarios();
      setState(() {
        _listaOriginal = usuarios;
        _listaFiltrada = usuarios;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _aplicarFiltros() {
    setState(() {
      _listaFiltrada = _listaOriginal.where((u) {
        final textoBusqueda = _searchCtrl.text.toLowerCase();
        final coincideTexto = u.nombreCompleto.toLowerCase().contains(textoBusqueda) || 
                              u.email.toLowerCase().contains(textoBusqueda);

        final coincideRol = _filtroRol == null || u.rol == _filtroRol;

        final coincideActivo = _filtroActivo == null || u.activo == _filtroActivo;

        final coincideEvento = _filtroEvento == null || 
                               _filtroEvento!.isEmpty || 
                               u.event == _filtroEvento;

        return coincideTexto && coincideRol && coincideActivo && coincideEvento;
      }).toList();
    });
  }

  void _editarUsuario(UsuarioTKD usuario) async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditUsersScreen(usuario: usuario)),
    );
    if (resultado == true) _cargarUsuarios();
  }

  void _confirmarEliminar(UsuarioTKD usuario) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('¿Eliminar usuario?'),
        content: Text('Vas a eliminar a "${usuario.nombreCompleto}".'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              bool exito = await _dataService.deleteUsuario(usuario.id);
              if (mounted && exito) {
                ScaffoldMessenger.of(context).showSnackBar(
                   const SnackBar(content: Text('Eliminado'), backgroundColor: Colors.green)
                );
                _cargarUsuarios();
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
        title: const Text('Gestión de Usuarios'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _cargarUsuarios, 
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
                      hintText: "Buscar por nombre o email...",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    ),
                    onChanged: (val) => _aplicarFiltros(), // Filtra mientras escribes
                  ),
                  const SizedBox(height: 10),
                
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
        
                        _crearDropdown(
                          titulo: "Rol",
                          valorActual: _filtroRol,
                          items: [
                            const DropdownMenuItem(value: null, child: Text("Todos los Roles")),
                            const DropdownMenuItem(value: "Admin", child: Text("Admin")),
                            const DropdownMenuItem(value: "Teacher", child: Text("Teacher")),
                            const DropdownMenuItem(value: "Usuario", child: Text("Usuario")),
                          ],
                          onChanged: (v) {
                            setState(() => _filtroRol = v);
                            _aplicarFiltros();
                          },
                        ),
                        const SizedBox(width: 10),
                        // Filtro ESTADO
                        _crearDropdown<int>(
                          titulo: "Estado",
                          valorActual: _filtroActivo,
                          items: [
                            const DropdownMenuItem(value: null, child: Text("Todos los Estados")),
                            const DropdownMenuItem(value: 1, child: Text("Activos", style: TextStyle(color: Colors.green))),
                            const DropdownMenuItem(value: 0, child: Text("Inactivos", style: TextStyle(color: Colors.red))),
                          ],
                          onChanged: (v) {
                            setState(() => _filtroActivo = v);
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
                    ? const Center(child: Text("No se encontraron resultados."))
                    : SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
                            columnSpacing: 20,
                            columns: const [
                              DataColumn(label: Text('ID')),
                              DataColumn(label: Text('Nombre')),
                              DataColumn(label: Text('Email')),
                              DataColumn(label: Text('Rol')),
                              DataColumn(label: Text('Estado')),
                              DataColumn(label: Text('Evento')),
                              DataColumn(label: Text('Acciones')),
                            ],
                            rows: _listaFiltrada.map((usuario) {
                              final esActivo = (usuario.activo == 1);
                              return DataRow(cells: [
                                DataCell(Text(usuario.id.toString())),
                                DataCell(Text(usuario.nombreCompleto, style: const TextStyle(fontWeight: FontWeight.bold))),
                                DataCell(Text(usuario.email)),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: usuario.rol == 'Admin' ? Colors.purple[100] : Colors.blue[100],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(usuario.rol, style: const TextStyle(fontSize: 12)),
                                  )
                                ),
                                DataCell(
                                  Row(
                                    children: [
                                      Icon(esActivo ? Icons.check_circle : Icons.cancel, 
                                           color: esActivo ? Colors.green : Colors.grey, size: 16),
                                      const SizedBox(width: 5),
                                      Text(esActivo ? "Activo" : "Inactivo"),
                                    ],
                                  ),
                                ),
                                DataCell(Text(usuario.event)),
                                DataCell(
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _editarUsuario(usuario)),
                                      IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _confirmarEliminar(usuario)),
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

  // Widget auxiliar para crear Dropdowns bonitos
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