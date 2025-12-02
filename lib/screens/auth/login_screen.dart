import 'package:flutter/material.dart';
import '../../services/data_service.dart';
import '../admin/admin_dashboard_screen.dart';
import '../teachers/dashboard_screen.dart';

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
      try {

      final exito = await _service.login(datos);
      
      if (exito.rol != '' && mounted) {
        
      
        print('Valor: ${exito.activo}');
        print('Tipo de dato: ${exito.activo.runtimeType}');
        print('Valor: ${exito.rol}');
        print('Tipo de dato: ${exito.rol.runtimeType}');
        
        if ( exito.activo == 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error: Usuario inactivo'),
              backgroundColor: Colors.red,
            ),
          );
          setState(() => _isLoading = false);
          return;
        }
          ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bienvenido ${exito.nombreCompleto}')),
        );

        if (exito.rol == 'Admin') {
          //Navigator.pushReplacementNamed(context, '/admin_dashboard', arguments: exito);
          Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) => AdminDashboardScreen(usuario: exito)),(route) => false,);
          return;
        }else if (exito.rol == 'Teacher') {
        //Navigator.pushReplacementNamed(context, '/dashboard', arguments: exito); 
        Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) => DashboardScreen(usuario: exito)),(route) => false,);
      }
      }
      }
      catch (e) {
        if (mounted) {
          setState(() => _isLoading = false);
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error: Correo o contraseña incorrectos'),
              backgroundColor: Colors.red,)
        );
      } }
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