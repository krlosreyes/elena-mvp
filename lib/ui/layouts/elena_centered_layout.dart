import 'package:flutter/material.dart';

class ElenaCenteredLayout extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const ElenaCenteredLayout({
    super.key,
    required this.child,
    this.maxWidth = 420, // tamaño tipo card 
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth,
        ),
        child: child,
      ),
    );
  }
}
