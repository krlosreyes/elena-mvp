import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../ui/elena_ui_system.dart';
import '../../../../ui/layouts/elena_centered_layout.dart';

import '../../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final repo = ref.read(authRepositoryProvider);

      await repo.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (mounted) {
        context.go('/dashboard');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ElenaColors.background,
      body: SafeArea(
        child: ElenaCenteredLayout(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: ElenaCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Bienvenido de nuevo 👋",
                      style: ElenaText.title,
                    ),
                    const SizedBox(height: 8),

                    const Text(
                      "Ingresa a tu cuenta para continuar",
                      style: ElenaText.subtitle,
                    ),

                    const SizedBox(height: 24),

                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          ElenaInput(
                            controller: emailController,
                            label: "Correo electrónico",
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) =>
                                v == null || v.isEmpty ? "Campo requerido" : null,
                          ),

                          const SizedBox(height: 20),

                          ElenaInput(
                            controller: passwordController,
                            label: "Contraseña",
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: true,
                            validator: (v) =>
                                v == null || v.isEmpty ? "Campo requerido" : null,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ElenaButtonPrimary(
                            text: "Ingresar",
                            onPressed: _login,
                          ),

                    const SizedBox(height: 16),

                    ElenaButtonSecondary(
                      text: "Crear una cuenta",
                      onPressed: () => context.go('/register'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
