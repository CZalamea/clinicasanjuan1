import 'package:flutter/material.dart';
import '../services/auth_services.dart';
import '../ventanaPrincipal.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  // Función para mostrar mensajes al usuario
  void _showMessage(String message, bool isError) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Función para manejar el inicio de sesión
  Future<void> _handleSignIn() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showMessage('Por favor, completa todos los campos', true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await _authService.signIn(
        _emailController.text,
        _passwordController.text,
      );

      if (result.success) {
        if (!mounted) return;
        
        // Navegar a la pantalla principal
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const MyAppVentanaPrincipal(),
          ),
        );
      } else {
        _showMessage(result.message, true);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // Función para manejar el registro
  Future<void> _handleRegister() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showMessage('Por favor, completa todos los campos', true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await _authService.register(
        _emailController.text,
        _passwordController.text,
      );

      _showMessage(result.message, !result.success);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo o título de la aplicación
              const Icon(
                Icons.lock_outline,
                size: 100,
                color: Colors.blue,
              ),
              const SizedBox(height: 32),
              
              // Campo de correo electrónico
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Correo Electrónico',
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                enabled: !_isLoading,
              ),
              const SizedBox(height: 16),
              
              // Campo de contraseña
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Contraseña',
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                enabled: !_isLoading,
              ),
              const SizedBox(height: 24),
              
              // Botones de acción
              if (_isLoading)
                const CircularProgressIndicator()
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _handleSignIn,
                      icon: const Icon(Icons.login),
                      label: const Text('Ingresar'),
                    ),
                    ElevatedButton.icon(
                      onPressed: _handleRegister,
                      icon: const Icon(Icons.person_add),
                      label: const Text('Registrarse'),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
