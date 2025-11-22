import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Acceso Maestros")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock, size: 80, color: Colors.blue),
            const SizedBox(height: 20),
            const TextField(
              decoration: InputDecoration(labelText: "Correo", prefixIcon: Icon(Icons.email)),
            ),
            const SizedBox(height: 15),
            const TextField(
              obscureText: true,
              decoration: InputDecoration(labelText: "Contraseña", prefixIcon: Icon(Icons.key)),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Login simulado...")),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("ENTRAR"),
            )
          ],
        ),
      ),
    );
  }
}