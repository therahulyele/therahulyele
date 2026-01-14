import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedTruthLogo extends StatefulWidget {
  final double size;
  final Duration glitchDuration;

  const AnimatedTruthLogo({
    super.key,
    this.size = 20.0,
    this.glitchDuration = const Duration(milliseconds: 300),
  });

  @override
  State<AnimatedTruthLogo> createState() => _AnimatedTruthLogoState();
}

class _AnimatedTruthLogoState extends State<AnimatedTruthLogo>
    with TickerProviderStateMixin {
  late AnimationController _glitchController;
  late Animation<double> _glitchAnimation;

  @override
  void initState() {
    super.initState();

    // Glitch animation only
    _glitchController = AnimationController(
      duration: widget.glitchDuration,
      vsync: this,
    );

    _glitchAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _glitchController, curve: Curves.easeInOut),
    );

    // Start glitch animation
    _glitchController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _glitchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glitchAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            (math.sin(_glitchAnimation.value * math.pi * 4) * 1) *
                (1 - _glitchAnimation.value),
            (math.cos(_glitchAnimation.value * math.pi * 3) * 0.5) *
                (1 - _glitchAnimation.value),
          ),
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.3),
                  blurRadius: 2,
                  spreadRadius: 0,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: Image.asset(
              'assets/logo.png',
              width: widget.size,
              height: widget.size,
              fit: BoxFit.contain,
            ),
          ),
        );
      },
    );
  }
}
