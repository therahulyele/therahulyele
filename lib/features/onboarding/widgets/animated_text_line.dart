import 'package:flutter/material.dart';

class AnimatedTextLine extends StatefulWidget {
  final String text;
  final TextStyle? textStyle;
  final Duration delay;
  final Duration duration;
  final TextAlign textAlign;
  final EdgeInsets padding;
  final bool slideUp;
  final bool fadeIn;

  const AnimatedTextLine({
    super.key,
    required this.text,
    this.textStyle,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 300),
    this.textAlign = TextAlign.center,
    this.padding = EdgeInsets.zero,
    this.slideUp = false,
    this.fadeIn = true,
  });

  @override
  State<AnimatedTextLine> createState() => _AnimatedTextLineState();
}

class _AnimatedTextLineState extends State<AnimatedTextLine>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _slideAnimation = Tween<Offset>(
      begin: widget.slideUp ? const Offset(0, 0.3) : Offset.zero,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    // Start animation after delay
    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: widget.fadeIn
                  ? _fadeAnimation
                  : const AlwaysStoppedAnimation(1.0),
              child: Text(
                widget.text,
                style: widget.textStyle,
                textAlign: widget.textAlign,
              ),
            ),
          );
        },
      ),
    );
  }
}
