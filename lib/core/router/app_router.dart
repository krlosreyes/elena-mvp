import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Auth
import '../../features/auth/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';

// Dashboard
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/fasting/presentation/screens/fasting_screen.dart';


// Onboarding
import '../../features/onboarding/presentation/screens/onboarding_step1_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_step2_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_step3_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_step4_screen.dart';

import 'package:cloud_firestore/cloud_firestore.dart';


/// ===============================================================
/// RouterNotifier — reemplaza GoRouterRefreshStream
/// ===============================================================
class RouterNotifier extends ChangeNotifier {
  final Ref ref;

  RouterNotifier(this.ref) {
    ref.listen(authStateProvider, (_, __) {
      notifyListeners();
    });
  }
}

final routerNotifierProvider = Provider<RouterNotifier>((ref) {
  return RouterNotifier(ref);
});


/// ===============================================================
/// GoRouter provider — versión final con onboarding obligatorio
/// ===============================================================
final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  final routerNotifier = ref.watch(routerNotifierProvider);

  return GoRouter(
    initialLocation: '/login',
    refreshListenable: routerNotifier,
    debugLogDiagnostics: false,

    routes: [
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/register', builder: (_, __) => const RegisterScreen()),
      GoRoute(path: '/dashboard', builder: (_, __) => const DashboardScreen()),
      GoRoute(path: '/fasting', builder: (_, __) => const FastingScreen(),
),


      GoRoute(path: '/onboarding/step1', builder: (_, __) => const OnboardingStep1Screen()),
      GoRoute(path: '/onboarding/step2', builder: (_, __) => const OnboardingStep2Screen()),
      GoRoute(path: '/onboarding/step3', builder: (_, __) => const OnboardingStep3Screen()),
      GoRoute(path: '/onboarding/step4', builder: (_, __) => const OnboardingStep4Screen()),
    ],

    redirect: (_, state) async {
      final user = authState.asData?.value;
      final location = state.uri.toString();

      // Rutas de onboarding
      final isOnboarding = location.startsWith('/onboarding');

      // 1. Usuario NO autenticado → solo login/register
      if (user == null) {
        if (location == '/login' || location == '/register') return null;
        return '/login';
      }

      // 2. Verificar si el usuario YA TIENE profile (ya terminó onboarding)
      final snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final hasProfile = snap.data()?['profile'] != null;

      // 3. Si NO ha hecho onboarding → DEBE hacer onboarding
      if (!hasProfile) {
        if (!isOnboarding) return '/onboarding/step1';
        return null;
      }

      // 4. Si ya hizo onboarding y está en login/register → dashboard
      if (location == '/login' || location == '/register') {
        return '/dashboard';
      }

      return null;
    },
  );
});
