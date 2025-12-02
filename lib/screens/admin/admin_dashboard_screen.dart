import 'package:flutter/material.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Panel de Administrador"),
        backgroundColor: Colors.black87, // Color oscuro para diferenciar Admin
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/', (r) => false),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildAdminOption(
            context,
            icon: Icons.manage_accounts,
            title: "Gestionar Maestros",
            subtitle: "Dar de alta, baja o editar maestros",
            ruta: '/admin_maestros', // Crearemos esta ruta en el siguiente paso
            color: Colors.indigo,
          ),
          const SizedBox(height: 15),
          _buildAdminOption(
            context,
            icon: Icons.list_alt,
            title: "Reporte Global",
            subtitle: "Ver todos los alumnos inscritos",
            ruta: '/admin_reportes', // Pendiente para después
            color: Colors.teal,
          ),
        ],
      ),
    );
  }

  Widget _buildAdminOption(BuildContext context, {required IconData icon, required String title, required String subtitle, required String ruta, required Color color}) {
    return Card(
      elevation: 4,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: color, size: 30),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // Validamos si la ruta existe antes de navegar para evitar errores
          try {
            Navigator.pushNamed(context, ruta);
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Módulo en construcción")));
          }
        },
      ),
    );
  }
}