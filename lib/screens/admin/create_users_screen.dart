import 'package:flutter/material.dart'; // Necesario para forzar mayúsculas
import '../../services/data_service.dart';

class CreateUsersScreen extends StatefulWidget {

  const CreateUsersScreen({super.key});
  
  @override
  State<CreateUsersScreen> createState() => _CreateUsersScreenState();
}

class _CreateUsersScreenState extends State<CreateUsersScreen> {
  final _formKey = GlobalKey<FormState>();
  final _service = DataService(); 
  bool _isLoading = false;

  final _nombreCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  String? _roleUser;

  final List<String> _roles = [
    'Admin', 'Teacher'
  ];

  void _enviarFormulario() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final datos = {
        "name": _nombreCtrl.text.trim(),
        "email": _emailCtrl.text.trim(),
        "password": _passwordCtrl.text,
        "role": _roleUser,
      };
      final resultado = await _service.insertarUsuario(datos);

      setState(() => _isLoading = false);

      if (mounted) {
        if (resultado['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registro exitoso!'),
              backgroundColor: Colors.green, // Verde para éxito
            ),
          );
          Navigator.pop(context);
        } else {
          // SI FALLA: Leemos el mensaje exacto que vino del Worker
          String mensajeError = resultado['message']; 
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(mensajeError), 
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Crear Usuarios"), backgroundColor: Colors.indigo,),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Datos de la cuenta", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Divider(),
              
              TextFormField(
                controller: _nombreCtrl,
                decoration: const InputDecoration(labelText: "Nombre Completo"),
                textCapitalization: TextCapitalization.characters, // Teclado en mayúsculas
                validator: (v) => v!.isEmpty ? "Requerido" : null,
              ),
              const SizedBox(height: 10),

              // Email
              TextFormField(
                controller: _emailCtrl,
                decoration: const InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
                validator: (v) => v!.isEmpty || !v.contains('@') ? "Email inválido" : null,
              ),
              const SizedBox(height: 10),
            TextFormField(
              controller: _passwordCtrl,
              
              decoration: InputDecoration(labelText: "Contraseña"),
              keyboardType: TextInputType.visiblePassword,
              validator: (v) => v!.isEmpty ? "Requerido" : null,
            ),

              DropdownButtonFormField<String>(
                value: _roleUser,
                items: _roles.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (v) => setState(() => _roleUser = v),
                decoration: const InputDecoration(labelText: "Role"),
                validator: (v) => v == null ? "Requerido" : null,
              ),


              const SizedBox(height: 50),

              ElevatedButton(
                onPressed: _isLoading ? null : _enviarFormulario,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white
                ),
                child: _isLoading 
                  ? const CircularProgressIndicator(color: Colors.white) 
                  : const Text("ENVIAR", style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    _nombreCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }
}