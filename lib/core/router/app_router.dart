import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Screens
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/dashboard/dashboard_placeholder.dart';

import '../../features/onboarding/presentation/screens/onboarding_step1_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_step2_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_step3_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_step4_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',

  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LoginScreen(),
    ),

    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),

    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardPlaceholder(),
    ),

    // ----------------------------
    // ONBOARDING (flat, funcional)
    // ----------------------------
    GoRoute(
      path: '/onboarding/step1',
      builder: (context, state) => const OnboardingStep1Screen(),
    ),
    GoRoute(
      path: '/onboarding/step2',
      builder: (context, state) => const OnboardingStep2Screen(),
    ),
    GoRoute(
      path: '/onboarding/step3',
      builder: (context, state) => const OnboardingStep3Screen(),
    ),
    GoRoute(
      path: '/onboarding/step4',
      builder: (context, state) => const OnboardingStep4Screen(),
    ),
  ],
);
