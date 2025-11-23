import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../ui/elena_ui_system.dart';
import '../../../../ui/layouts/elena_centered_layout.dart';

import '../../providers/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final repo = ref.read(authRepositoryProvider);

      await repo.register(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (mounted) {
        context.go('/onboarding/step1');
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
                    const Text("Crea tu cuenta ✨", style: ElenaText.title),
                    const SizedBox(height: 8),
                    const Text(
                      "Empieza tu transformación con Elena.",
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
                            label: "Contraseña (mínimo 6 caracteres)",
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: true,
                            validator: (v) {
                              if (v == null || v.isEmpty) return "Campo requerido";
                              if (v.length < 6) return "Mínimo 6 caracteres";
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ElenaButtonPrimary(
                            text: "Crear cuenta",
                            onPressed: _register,
                          ),

                    const SizedBox(height: 16),

                    ElenaButtonSecondary(
                      text: "Ya tengo una cuenta",
                      onPressed: () => context.go('/'),
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
