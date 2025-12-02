import 'package:flutter/material.dart';
import '../../models/user_model.dart';

class DashboardScreen extends StatelessWidget {

  final UsuarioTKD? usuario;
  const DashboardScreen({super.key, this.usuario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: const Text("Panel de Maestros"),
      backgroundColor: Colors.orange,
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
                  Icon(Icons.logout, color: Colors.orange),
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
            title: "Participantes Inscritos",
            subtitle: "Ver los participantes",
            ruta: '/view_user_screen_participants',
            color: Colors.teal,
          ),
          const SizedBox(height: 15),
          _buildAdminOption(
            context,
            icon: Icons.event,
            title: "Crear evento",
            subtitle: "Ver todos los eventos creados",
            ruta: '/admin_eventos',
            color: Colors.orange,
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