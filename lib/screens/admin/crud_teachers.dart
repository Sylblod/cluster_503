import 'package:flutter/material.dart';
import '../../services/data_service.dart';

class MaestrosCrudScreen extends StatefulWidget {
  const MaestrosCrudScreen({super.key});

  @override
  State<MaestrosCrudScreen> createState() => _MaestrosCrudScreenState();
}

class _MaestrosCrudScreenState extends State<MaestrosCrudScreen> {
  final _service = DataService();
  late Future<List<Map<String, String>>> _maestrosFuture;

  @override
  void initState() {
    super.initState();
    _recargarLista();
  }

  void _recargarLista() {
    setState(() {
      _maestrosFuture = _service.getMaestros();
    });
  }

  void _mostrarDialogoAgregar() {
    final nombreCtrl = TextEditingController();
    final escuelaCtrl = TextEditingController();
    final emailCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Nuevo Maestro"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nombreCtrl, decoration: const InputDecoration(labelText: "Nombre")),
            TextField(controller: escuelaCtrl, decoration: const InputDecoration(labelText: "Escuela")),
            TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: "Email")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
          ElevatedButton(
            onPressed: () async {
              await _service.agregarMaestro(nombreCtrl.text, escuelaCtrl.text, emailCtrl.text);
              Navigator.pop(context);
              _recargarLista(); // Actualizar la lista visualmente
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Maestro agregado")));
            },
            child: const Text("Guardar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gestión de Maestros"), backgroundColor: Colors.indigo, foregroundColor: Colors.white),
      floatingActionButton: FloatingActionButton(
        onPressed: _mostrarDialogoAgregar,
        backgroundColor: Colors.indigo,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: FutureBuilder<List<Map<String, String>>>(
        future: _maestrosFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          
          final lista = snapshot.data!;
          return ListView.builder(
            itemCount: lista.length,
            itemBuilder: (context, index) {
              final m = lista[index];
              return ListTile(
                leading: CircleAvatar(child: Text(m['nombre']![0])),
                title: Text(m['nombre']!),
                subtitle: Text("${m['escuela']} • ${m['email']}"),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    await _service.eliminarMaestro(m['id']!);
                    _recargarLista();
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}