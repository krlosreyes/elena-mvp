import 'package:firebase_auth/firebase_auth.dart';

class AuthTest {
  static Future<void> testSignUp() async {
    try {
      final email = "test${DateTime.now().millisecondsSinceEpoch}@mail.com";
      final password = "12345678";

      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      print("AUTH SIGN UP OK: ${userCredential.user?.uid}");
    } catch (e) {
      print("AUTH SIGN UP ERROR: $e");
    }
  }

  static Future<void> testLogin() async {
    try {
      // Usa el mismo usuario creado antes (se quedará autenticado)
      final user = FirebaseAuth.instance.currentUser;
      print("AUTH CURRENT USER: ${user?.uid}");
    } catch (e) {
      print("AUTH LOGIN ERROR: $e");
    }
  }
}
