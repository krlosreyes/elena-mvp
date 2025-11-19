import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Crear cuenta
  Future<User?> register(String email, String password) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user;
  }

  // Iniciar sesión
  Future<User?> login(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user;
  }

  // Cerrar sesión
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Stream de autenticación
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
