import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Repository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

/// Current user getter
final authProvider = Provider<User?>((ref) {
  return ref.watch(authRepositoryProvider).currentUser;
});

/// Auth state stream (PROTEGIDO PARA WEB)
final authStateProvider = StreamProvider<User?>((ref) {
  final repo = ref.watch(authRepositoryProvider);

  return repo.authStateChanges.handleError((error) {
    print('AuthState error (ignorado para evitar crash Web): $error');
  });
});
