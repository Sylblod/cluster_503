import 'package:flutter/material.dart';
import '../../services/data_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _service = DataService(); 
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _isHidden = true;
  bool _isLoading = false;

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

    void _enviarFormulario() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final datos = {
        "email": _emailCtrl.text,
        "password": _passwordCtrl.text,
      };

      final exito = await _service.login(datos);

      setState(() => _isLoading = false);
      
      if (exito.token != null && mounted) {
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bienvenido ${exito.nombreCompleto}')),
        );
        
        Navigator.pushReplacementNamed(context, '/dashboard', arguments: exito); 
        
      } else {
        // Si usuarioRecibido es null, falló el login
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error: Correo o contraseña incorrectos'),
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
      appBar: AppBar(title: const Text("Acceso Maestros")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Divider(),
              const Icon(Icons.lock, size: 80, color: Colors.blue),
              const SizedBox(height: 20),
            TextFormField(
              controller: _emailCtrl,
              decoration: InputDecoration(labelText: "Correo", prefixIcon: Icon(Icons.email)),
              keyboardType: TextInputType.emailAddress,
              validator: (v) => v!.isEmpty || !v.contains('@') ? "Email inválido" : null,
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: _passwordCtrl,
              obscureText: _isHidden,
              decoration: InputDecoration(labelText: "Contraseña", prefixIcon: Icon(Icons.key), suffixIcon: GestureDetector(
                      onTap: _togglePasswordView,
                      child: Icon(
                        _isHidden ? Icons.visibility : Icons.visibility_off,
                      ),
                    
                      )),
              keyboardType: TextInputType.visiblePassword,
              validator: (v) => v!.isEmpty ? "Requerido" : null,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed:  _isLoading ? null : _enviarFormulario,
              child: const Text("Ingresar"),
            )
          ],
        ),
      ),
      )
    );
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }
}