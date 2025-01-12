// lib/services/auth_service.dart

import 'package:firebase_auth/firebase_auth.dart';

// Esta clase nos ayuda a manejar los resultados de la autenticación
class AuthResult {
  final bool success;
  final String message;
  final User? user;

  AuthResult({
    required this.success,
    required this.message,
    this.user,
  });
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Obtener el usuario actual
  User? get currentUser => _auth.currentUser;

  // Stream para escuchar cambios en el estado de autenticación
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Método para iniciar sesión
  Future<AuthResult> signIn(String email, String password) async {
    try {
      // Validamos el formato del correo electrónico
      if (!email.contains('@')) {
        return AuthResult(
          success: false,
          message: 'Por favor, ingresa un correo electrónico válido',
        );
      }

      // Intentamos hacer el login
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      return AuthResult(
        success: true,
        message: 'Inicio de sesión exitoso',
        user: userCredential.user,
      );
    } on FirebaseAuthException catch (e) {
      // Manejamos los diferentes tipos de errores que puede devolver Firebase
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'No existe una cuenta con este correo electrónico';
          break;
        case 'wrong-password':
          message = 'Contraseña incorrecta';
          break;
        case 'user-disabled':
          message = 'Esta cuenta ha sido deshabilitada';
          break;
        case 'too-many-requests':
          message = 'Demasiados intentos fallidos. Intenta más tarde';
          break;
        default:
          message = 'Error al iniciar sesión: ${e.message}';
      }
      return AuthResult(success: false, message: message);
    } catch (e) {
      return AuthResult(
        success: false,
        message: 'Error inesperado: $e',
      );
    }
  }

  // Método para registrar un nuevo usuario
  Future<AuthResult> register(String email, String password) async {
    try {
      // Validaciones básicas
      if (password.length < 6) {
        return AuthResult(
          success: false,
          message: 'La contraseña debe tener al menos 6 caracteres',
        );
      }

      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      return AuthResult(
        success: true,
        message: 'Registro exitoso',
        user: userCredential.user,
      );
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'email-already-in-use':
          message = 'Ya existe una cuenta con este correo electrónico';
          break;
        case 'invalid-email':
          message = 'El correo electrónico no es válido';
          break;
        case 'operation-not-allowed':
          message = 'La operación no está permitida';
          break;
        case 'weak-password':
          message = 'La contraseña es muy débil';
          break;
        default:
          message = 'Error en el registro: ${e.message}';
      }
      return AuthResult(success: false, message: message);
    } catch (e) {
      return AuthResult(
        success: false,
        message: 'Error inesperado: $e',
      );
    }
  }

  // Método para cerrar sesión
  Future<void> signOut() async {
    await _auth.signOut();
  }
}

