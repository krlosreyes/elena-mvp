// Elena UI System – Base Components
// Este archivo define los componentes reutilizables para toda la app.
// Incluye: colores, botones, inputs, cards, headers y barra de progreso.

import 'package:flutter/material.dart';

// ----------------------
// 1. COLOR SYSTEM
// ----------------------
class ElenaColors {
  static const Color primary = Color(0xFF21808D);
  static const Color secondary = Color(0xFF5E5240);
  static const Color background = Color(0xFFFCFCF9);
  static const Color textDark = Colors.black87;
  static const Color textLight = Colors.black54;
  static const Color card = Colors.white;
}

// ----------------------
// 2. TYPOGRAPHY
// ----------------------
class ElenaText {
  static const title = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: ElenaColors.primary,
  );

  static const subtitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: ElenaColors.textDark,
  );

  static const label = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: ElenaColors.textDark,
  );
}

// ----------------------
// 3. ELEVATED BUTTON (PRIMARY)
// ----------------------
class ElenaButtonPrimary extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const ElenaButtonPrimary({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: ElenaColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: onPressed,
        child: Text(text, style: const TextStyle(fontSize: 18, color: Colors.white)),
      ),
    );
  }
}

// ----------------------
// 4. OUTLINE BUTTON (SECONDARY)
// ----------------------
class ElenaButtonSecondary extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const ElenaButtonSecondary({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          side: const BorderSide(color: ElenaColors.primary, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: onPressed,
        child: Text(text, style: const TextStyle(fontSize: 18, color: ElenaColors.primary)),
      ),
    );
  }
}

// ----------------------
// 5. TEXT INPUT
// ----------------------
class ElenaInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const ElenaInput({
    super.key,
    required this.controller,
    required this.label,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
      ),
    );
  }
}

// ----------------------
// 6. CARD CONTAINER
// ----------------------
class ElenaCard extends StatelessWidget {
  final Widget child;
  const ElenaCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: ElenaColors.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

// ----------------------
// 7. PROGRESS BAR (STEP INDICATOR)
// ----------------------
class ElenaProgressBar extends StatelessWidget {
  final int step;
  final int total;

  const ElenaProgressBar({super.key, required this.step, required this.total});

  @override
  Widget build(BuildContext context) {
    final double progress = step / total;

    return Container(
      height: 6,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(3),
      ),
      child: FractionallySizedBox(
        widthFactor: progress,
        alignment: Alignment.centerLeft,
        child: Container(
          decoration: BoxDecoration(
            color: ElenaColors.primary,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ),
    );
  }
}

// ----------------------
// 8. HEADER DE SECCIÓN
// ----------------------
class ElenaSectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const ElenaSectionHeader({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: ElenaText.title),
        const SizedBox(height: 8),
        Text(subtitle, style: ElenaText.subtitle),
      ],
    );
  }
}
