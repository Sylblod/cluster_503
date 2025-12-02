import 'package:flutter/material.dart';
import '../../services/data_service.dart';
import '../../models/user_model.dart'; // Asegúrate de importar tu modelo UsuarioTKD

class EditUsersScreen extends StatefulWidget {
  final UsuarioTKD? usuario; 

  const EditUsersScreen({super.key, this.usuario});
  
  @override
  State<EditUsersScreen> createState() => _EditUsersScreenState();
}

class _EditUsersScreenState extends State<EditUsersScreen> {
  final _formKey = GlobalKey<FormState>();
  final _service = DataService(); 
  bool _isLoading = false;

  // Controladores
  final _nombreCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _eventCtrl = TextEditingController();
  
  String? _roleUser;
  bool _isActive = true;

  final List<String> _roles = [
    'Admin', 'Teacher'
  ];

  @override
  void initState() {
    super.initState();
    if (widget.usuario != null) {
      _nombreCtrl.text = widget.usuario!.nombreCompleto;
      _emailCtrl.text = widget.usuario!.email;
      _roleUser = widget.usuario!.rol;
      _eventCtrl.text = widget.usuario!.event;
      _isActive = widget.usuario!.activo == 1;
    }
  }

  void _enviarFormulario() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      bool exito = false;
       
      final usuarioEditado = UsuarioTKD(
        id: widget.usuario!.id,
        nombreCompleto: _nombreCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        rol: _roleUser!,
        event: _eventCtrl.text.trim(),
        activo: _isActive ? 1 : 0,
        token: widget.usuario!.token,
      );

        exito = await _service.updateUsuario(usuarioEditado);
      

      setState(() => _isLoading = false);

      if (mounted) {
        if (exito) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Usuario actualizado correctamente"), backgroundColor: Colors.green),
          );
          Navigator.pop(context, true); // Retornamos true para refrescar la tabla
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error al actualizar usuario"), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text("Editar Usuario"), backgroundColor: Colors.indigo,),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Datos de la cuenta", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Divider(),
              
              // Nombre
              TextFormField(
                controller: _nombreCtrl,
                decoration: const InputDecoration(labelText: "Nombre Completo"),
                textCapitalization: TextCapitalization.characters,
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

              // Contraseña: SOLO SE MUESTRA SI ESTAMOS CREANDO (widget.usuario == null)
              if (widget.usuario == null) 
                Column(
                  children: [
                    TextFormField(
                      controller: _passwordCtrl,
                      decoration: const InputDecoration(labelText: "Contraseña"),
                      keyboardType: TextInputType.visiblePassword,
                      validator: (v) => v!.isEmpty ? "Requerido" : null,
                    ),
                    const SizedBox(height: 10),
                  ],
                ),

              // Rol
              DropdownButtonFormField<String>(
                value: _roleUser,
                items: _roles.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (v) => setState(() => _roleUser = v),
                decoration: const InputDecoration(labelText: "Rol"),
                validator: (v) => v == null ? "Requerido" : null,
              ),
              const SizedBox(height: 10),

              // NUEVO CAMPO: Evento
              TextFormField(
                controller: _eventCtrl,
                decoration: const InputDecoration(
                  labelText: "Evento",
                  hintText: "Ej. Torneo Nacional 2024"
                ),
                validator: (v) => v!.isEmpty ? "Requerido" : null,
              ),
              const SizedBox(height: 20),

              // NUEVO CAMPO: Activo (Switch)
              SwitchListTile(
                title: const Text("Usuario Activo"),
                subtitle: Text(_isActive ? "El usuario puede acceder al sistema" : "Acceso bloqueado"),
                value: _isActive,
                activeColor: Colors.green,
                onChanged: (val) {
                  setState(() {
                    _isActive = val;
                  });
                },
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: _isLoading ? null : _enviarFormulario,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white
                ),
                child: _isLoading 
                  ? const CircularProgressIndicator(color: Colors.white) 
                  : Text(widget.usuario == null ? "CREAR" : "GUARDAR CAMBIOS", style: const TextStyle(fontSize: 16)),
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
    _eventCtrl.dispose(); // No olvidar liberar el nuevo controller
    super.dispose();
  }
}