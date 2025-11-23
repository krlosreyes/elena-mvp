import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // LOGIN
  Future<User?> login(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user;
  }

  // REGISTER
  Future<User?> register(String email, String password) async {
  try {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return cred.user;
  } on FirebaseAuthException catch (e) {
    // Convertimos excepción a string humano y seguro
    throw Exception(e.message ?? 'Error de Firebase');
  } catch (e) {
    throw Exception('Error inesperado: $e');
  }
}


  // LOGOUT
  Future<void> logout() async {
    await _auth.signOut();
  }

  // AUTH STATE (getter recomendado)
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // CURRENT USER
  User? get currentUser => _auth.currentUser;
}
