import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Slide depuis le bas
class SlideUpTransition extends CustomTransition {
  @override
  Widget buildTransition(
    BuildContext context,
    Curve? curve,
    Alignment? alignment,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
          .animate(CurvedAnimation(parent: animation, curve: curve ?? Curves.easeOutCubic)),
      child: child,
    );
  }
}

/// Slide depuis la droite
class SlideRightTransition extends CustomTransition {
  @override
  Widget buildTransition(
    BuildContext context,
    Curve? curve,
    Alignment? alignment,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
          .animate(CurvedAnimation(parent: animation, curve: curve ?? Curves.easeOutCubic)),
      child: child,
    );
  }
}

/// Fade + légère mise à l'échelle (style Netflix)
class FadeScaleTransition extends CustomTransition {
  @override
  Widget buildTransition(
    BuildContext context,
    Curve? curve,
    Alignment? alignment,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: CurvedAnimation(parent: animation, curve: curve ?? Curves.easeIn),
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.96, end: 1.0)
            .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
        child: child,
      ),
    );
  }
}
