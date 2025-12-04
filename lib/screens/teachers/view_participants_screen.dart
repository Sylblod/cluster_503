import 'package:flutter/material.dart';
import '../../services/data_service.dart';
import '../../models/participants_model.dart';
import 'edit_participants_screen.dart';

class ViewUserScreenParticipantsTeacher extends StatefulWidget {
  const ViewUserScreenParticipantsTeacher({super.key});

  @override
  State<ViewUserScreenParticipantsTeacher> createState() => _ViewUserScreenParticipantsTeacherState();
}

class _ViewUserScreenParticipantsTeacherState extends State<ViewUserScreenParticipantsTeacher> {
  final DataService _dataService = DataService();

  List<ParticipantesTKD> _listaOriginal = [];
  List<ParticipantesTKD> _listaFiltrada = []; 
  bool _isLoading = true;

 
  final TextEditingController _searchCtrl = TextEditingController();
  String? _filtroRama;   
  String? _filtroEscuela;

  @override
  void initState() {
    super.initState();
    _cargarparticipantess();
  }

  void _cargarparticipantess() async {
    setState(() => _isLoading = true);
    try {
      final participantes = await _dataService.getParticipantes();
      setState(() {
        _listaOriginal = participantes;
        _listaFiltrada = participantes;
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
        final coincideTexto = u.nombre.toLowerCase().contains(textoBusqueda);

        final coinciderama= _filtroRama == null || u.rama== _filtroRama;


        final coincideEvento = _filtroEscuela == null || 
                               _filtroEscuela!.isEmpty || 
                               u.escuela == _filtroEscuela;

        return coincideTexto && coinciderama && coincideEvento;
      }).toList();
    });
  }

    void _editarParticipante(ParticipantesTKD participante) async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditParticipantsScreen(participante: participante)),
    );
    if (resultado == true) _cargarparticipantess();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Participantes inscritos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _cargarparticipantess, 
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
                      hintText: "Buscar por nombre",
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
                          titulo: "Rama",
                          valorActual: _filtroRama,
                          items: [
                            const DropdownMenuItem(value: null, child: Text("Todas las Ramas")),
                            const DropdownMenuItem(value: "VARONIL", child: Text("VARONIL")),
                            const DropdownMenuItem(value: "FEMENIL", child: Text("FEMENIL")),
                          ],
                          onChanged: (v) {
                            setState(() => _filtroRama = v);
                            _aplicarFiltros();
                          },
                        ),
                        const SizedBox(width: 10),
          
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
                              DataColumn(label: Text('Escuela')),
                              DataColumn(label: Text('Maestro')),
                              DataColumn(label: Text('Rama')),
                              DataColumn(label: Text('Modalidad')),
                              DataColumn(label: Text('Acciones')),
                            ],
                            rows: _listaFiltrada.map((participantes) {
                              return DataRow(cells: [
                                DataCell(Text(participantes.id.toString())),
                                DataCell(Text(participantes.nombre, style: const TextStyle(fontWeight: FontWeight.bold))),
                                DataCell(Text(participantes.escuela)),
                                DataCell(Text(participantes.maestro)),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: participantes.rama== 'VARONIL' ? Colors.purple[100] : Colors.blue[100],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(participantes.rama, style: const TextStyle(fontSize: 12)),
                                  )
                                ),
                                DataCell(Text(participantes.modalidad)),
                                DataCell(
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _editarParticipante(participantes)),
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