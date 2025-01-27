import 'package:flutter/material.dart';
import 'package:clinicasanjuan/ventanaPrincipal.dart';
import 'package:clinicasanjuan/main.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthController _authController = AuthController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool isLoading = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  void _mostrarMensaje(String mensaje, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), backgroundColor: color),
    );
  }

  Future<void> _registrarUsuario() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _mostrarMensaje('Todos los campos son obligatorios', Colors.red);
      return;
    }

    if (password != confirmPassword) {
      _mostrarMensaje('Las contraseñas no coinciden', Colors.red);
      return;
    }

    setState(() => isLoading = true);

    try {
      await _authController.registerWithEmailAndPassword(email, password);
      _mostrarMensaje('Registro exitoso', Colors.green);

      // Navega a la pantalla principal
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyAppVentanaPrincipal()),
      );
    } catch (e) {
      print(e);
      _mostrarMensaje(e.toString(), Colors.red);
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Usuario'),
      ),
      body: Center(
        child: SizedBox(
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Correo Electrónico',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible, // Control de visibilidad
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Contraseña',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
              ),
              TextField(
                controller: _confirmPasswordController,
                obscureText: !_isConfirmPasswordVisible, // Control de visibilidad
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Confirmar Contraseña',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _registrarUsuario,
                      child: const Text("Registrar"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
