import 'package:flutter/material.dart';

/// ===============================================================
///                     ELENA DESIGN SYSTEM
/// ===============================================================

class ElenaColors {
  static const Color primary = Color(0xFF21808D);
  static const Color secondary = Color(0xFF5E5240);
  static const Color background = Color(0xFFFCFCF9);
  static const Color card = Colors.white;

  static const Color textDark = Color(0xFF2C2C2C);
  static const Color textMedium = Color(0xFF4F4F4F);
  static const Color textLight = Color(0xFF8E8E8E);

  static const Color success = Color(0xFF2ECC71);
  static const Color warning = Color(0xFFF39C12);
  static const Color error = Color(0xFFE74C3C);

  // Gamificación
  static const Color xp = Color(0xFFFFD700);
  static const Color streak = Color(0xFFFF5722);      // ← Necesario para Dashboard
}

/// ===============================================================
///                         TEXT SYSTEM
/// ===============================================================

class ElenaText {
  static const title = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w700,
    color: ElenaColors.textDark,
  );

  static const subtitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: ElenaColors.textMedium,
  );

  static const label = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: ElenaColors.textDark,
  );

  static const body = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: ElenaColors.textDark,
  );

  static const bodyLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: ElenaColors.textDark,
  );

  static const bodySmall = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w300,
    color: ElenaColors.textMedium,
  );
}

/// ===============================================================
///                          COMPONENTES
/// ===============================================================

/// ------------------- CARD -------------------
class ElenaCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final Color? color;

  const ElenaCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? ElenaColors.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: child,
    );
  }
}

/// ------------------- INPUT -------------------
class ElenaInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool obscure;
  final bool obscureText;

  const ElenaInput({
    super.key,
    required this.controller,
    required this.label,
    this.keyboardType,
    this.validator,
    this.obscure = false,
    this.obscureText = false, // compatibilidad
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscure,
      style: ElenaText.body,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: ElenaText.bodySmall.copyWith(color: ElenaColors.textLight),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: ElenaColors.primary, width: 1.5),
          borderRadius: BorderRadius.circular(14),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(14),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}

/// ------------------- BUTTONS -------------------

class ElenaButtonPrimary extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const ElenaButtonPrimary({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: ElenaColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}

class ElenaButtonSecondary extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const ElenaButtonSecondary({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          side: const BorderSide(color: ElenaColors.primary, width: 1.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w600),
        ),
        onPressed: onPressed,
        child: Text(text, style: const TextStyle(color: ElenaColors.primary)),
      ),
    );
  }
}

/// ------------------- SECTION HEADER -------------------
class ElenaSectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;

  const ElenaSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: ElenaText.title),
        if (subtitle != null) ...[
          const SizedBox(height: 6),
          Text(subtitle!, style: ElenaText.subtitle),
        ]
      ],
    );
  }
}

/// ------------------- PROGRESS BAR -------------------
class ElenaProgressBar extends StatelessWidget {
  final int step;
  final int total;

  const ElenaProgressBar({
    super.key,
    required this.step,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final progress = step / total;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: LinearProgressIndicator(
        minHeight: 10,
        value: progress,
        color: ElenaColors.primary,
        backgroundColor: Colors.grey.shade300,
      ),
    );
  }
}

/// ------------------- SIMPLE PROGRESS BAR (Dashboard) -------------------
class ElenaProgressBarSimple extends StatelessWidget {
  final double value;

  const ElenaProgressBarSimple({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: LinearProgressIndicator(
        minHeight: 10,
        value: value.clamp(0, 1),
        color: ElenaColors.primary,
        backgroundColor: Colors.grey.shade300,
      ),
    );
  }
}

/// ------------------- QUICK ACTION BUTTON -------------------
class ElenaQuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const ElenaQuickActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 80,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 28, color: ElenaColors.primary),
            const SizedBox(height: 6),
            Text(
              label,
              style: ElenaText.label.copyWith(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
