import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sharevoices/services/theme/theme_service.dart';

class AppDecoratedBox extends ConsumerWidget {
  final Widget? child;
  final Color color;
  final VoidCallback? onPressed;
  final bool withShadow;

  const AppDecoratedBox({
    super.key,
    this.child,
    required this.color,
    this.onPressed,
    this.withShadow = true,
  });

  @override
  Widget build(BuildContext context, ref) {
    return GestureDetector(
      onTap: onPressed,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          boxShadow: withShadow
              ? [
                  BoxShadow(
                    color: !ref.watch(themeProvider).isDarkTheme()
                        ? Colors.black.withValues(alpha: 0.2)
                        : Colors.white.withValues(alpha: 0.2),
                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: const Offset(0, 1), // changes position of shadow
                  ),
                ]
              : [],
        ),
        child: child,
      ),
    );
  }
}
