import 'package:flutter/material.dart';

class PublicHomeScreen extends StatelessWidget {
  const PublicHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
         
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
              ),
            ),
          ),
        
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
               
                Container(
                  width: 120,
                  height: 120,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.sports_martial_arts, size: 60, color: Color(0xFFFF9800)),
                ),
                const SizedBox(height: 20),
                const Text(
                  "CLUSTER 503",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2.0,
                  ),
                ),
                const Text(
                  "Gestión de Torneos y Exámenes",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const Spacer(),
                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton.icon(
                       
                        onPressed: () => Navigator.pushNamed(context, '/eventos'),
                        icon: const Icon(Icons.calendar_month),
                        label: const Text("VER EVENTOS Y TORNEOS"),
                        style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
                      ),
                      const SizedBox(height: 15),
                      OutlinedButton.icon(
                       
                        onPressed: () => Navigator.pushNamed(context, '/login'),
                        icon: const Icon(Icons.person),
                        label: const Text("ACCESO MAESTROS"),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}