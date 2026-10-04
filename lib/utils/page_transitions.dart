// lib/utils/page_transitions.dart
import 'package:flutter/material.dart';

/// A slide-in-from-the-right transition, used for every screen change
/// in the app. Going back (Navigator.pop) automatically plays this
/// same animation in reverse — Flutter handles that for you.
Route<T> slideRoute<T>(
  Widget page, {
  Duration transitionDuration = const Duration(milliseconds: 600),
  Duration? reverseTransitionDuration,
}) {
  return PageRouteBuilder<T>(
    transitionDuration: transitionDuration,
    reverseTransitionDuration: reverseTransitionDuration ?? transitionDuration,
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      final tween = Tween(begin: begin, end: end)
          .chain(CurveTween(curve: Curves.easeInOutCubic));
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}