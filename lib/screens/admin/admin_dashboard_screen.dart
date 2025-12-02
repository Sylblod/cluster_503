import 'package:flutter/material.dart';
import '../../models/user_model.dart';


class AdminDashboardScreen extends StatelessWidget {

  final UsuarioTKD? usuario;
  const AdminDashboardScreen({super.key, this.usuario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: const Text("Panel de Administrador"),
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      actions: [
        PopupMenuButton<String>(
          icon: const Icon(Icons.logout), 
          tooltip: 'Opciones',

          onSelected: (value) {
            if (value == 'logout') {
              Navigator.pushNamedAndRemoveUntil(context, '/', (r) => false);
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: 'logout',
              child: Row(
                children: [
                  Icon(Icons.logout, color: Colors.black),
                  SizedBox(width: 8),
                  Text(
                    'Cerrar sesión',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildAdminOption(
            context,
            icon: Icons.manage_accounts,
            title: "Crear Usuario",
            subtitle: "Dar de alta a nuevos usuarios",
            ruta: '/create_users_screen',
            color: Colors.indigo,
          ),
          const SizedBox(height: 15),
          _buildAdminOption(
            context,
            icon: Icons.list_alt,
            title: "Usuarios",
            subtitle: "Ver, editar, eliminar los usuarios",
            ruta: '/view_user_screen',
            color: Colors.indigo,
          ),
          const SizedBox(height: 15),
          _buildAdminOption(
            context,
            icon: Icons.event,
            title: "Crear evento",
            subtitle: "Dar de alta a nuevos eventos",
            ruta: '/create_events_screen',
            color: Colors.teal,
          ),
          const SizedBox(height: 15),
          _buildAdminOption(
            context,
            icon: Icons.list_alt,
            title: "Eventos",
            subtitle: "Ver, editar, eliminar los eventos",
            ruta: '/view_events_screen',
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