// lib/widgets/glass_container.dart
import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double? paddingHorizontal;
  final double? paddingVertical;
  final double borderRadius;
  final VoidCallback? onTap;

  // Default padding used when none is specified — sized for icon-only
  // buttons like a back button or a "more options" button.
  static const double _defaultPadding = 12;

  const GlassContainer({
    super.key,
    required this.child,
    this.paddingHorizontal,
    this.paddingVertical,
    this.borderRadius = 18,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        MediaQuery.platformBrightnessOf(context) == Brightness.dark;

    final padding = EdgeInsets.symmetric(
      horizontal: paddingHorizontal ?? _defaultPadding,
      vertical: paddingVertical ?? _defaultPadding,
    );

    final content = Padding(
      padding: padding,
      child: child,
    );

    final Widget container = isDarkMode
        ? _buildGlassVersion(content)
        : _buildLightVersion(content);

    // Only wrap in a gesture detector if the caller actually wants this
    // to be tappable — a stat card, for instance, might not need one.
    if (onTap == null) return container;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: container,
    );
  }

  Widget _buildGlassVersion(Widget content) {
    return LiquidGlassLayer(
      settings: const LiquidGlassSettings(
        thickness: 12,
        blur: 16, // kept subtle — same "just a little glassy" feel as the nav bar
      ),
      child: LiquidGlass(
        shape: LiquidRoundedSuperellipse(borderRadius: borderRadius),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: content,
        ),
      ),
    );
  }

  Widget _buildLightVersion(Widget content) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: content,
    );
  }
}