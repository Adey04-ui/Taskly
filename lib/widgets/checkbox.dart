// lib/widgets/premium_checkbox.dart
import 'package:flutter/material.dart';

class PremiumCheckbox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color activeColor;

  const PremiumCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor = const Color(0xFF3134DE),
  });

  @override
  State<PremiumCheckbox> createState() => _PremiumCheckboxState();
}

class _PremiumCheckboxState extends State<PremiumCheckbox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _scale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.8)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.8, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 60,
      ),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onChanged(!widget.value);
        _controller.forward(from: 0);
      },
      child: AnimatedBuilder(
        animation: _scale,
        builder: (context, child) {
          return Transform.scale(scale: _scale.value, child: child);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            gradient: widget.value
                ? LinearGradient(
                    colors: [
                      widget.activeColor,
                      widget.activeColor.withOpacity(0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: widget.value ? null : Colors.transparent,
            border: Border.all(
              color: widget.value
                  ? widget.activeColor
                  : Colors.white38,
              width: 1.5,
            ),
            boxShadow: widget.value
                ? [
                    BoxShadow(
                      color: widget.activeColor.withOpacity(0.5),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : [],
          ),
          child: widget.value
              ? const Icon(Icons.check, size: 16, color: Colors.white)
              : null,
        ),
      ),
    );
  }
}