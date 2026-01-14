import 'package:flutter/material.dart';

class GlowingBorder extends StatefulWidget {
  final Widget child;
  final double borderWidth;
  final Color glowColor;
  final Duration animationDuration;
  final bool animate;

  const GlowingBorder({
    super.key,
    required this.child,
    this.borderWidth = 2.0,
    this.glowColor = Colors.white,
    this.animationDuration = const Duration(milliseconds: 8000),
    this.animate = true,
  });

  @override
  State<GlowingBorder> createState() => _GlowingBorderState();
}

class _GlowingBorderState extends State<GlowingBorder>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _travelAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _travelAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    if (widget.animate) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: SharpGlowPainter(
            progress: _travelAnimation.value,
            borderWidth: widget.borderWidth,
            glowColor: widget.glowColor,
          ),
          child: widget.child,
        );
      },
    );
  }
}

class SharpGlowPainter extends CustomPainter {
  final double progress;
  final double borderWidth;
  final Color glowColor;

  SharpGlowPainter({
    required this.progress,
    required this.borderWidth,
    required this.glowColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    final perimeter = 2 * (width + height);
    final glowLength = 100.0; // Increased glow length
    final currentPosition = progress * perimeter;

    // Create subtle glow effect with multiple layers
    final outerGlowPaint = Paint()
      ..color = glowColor.withValues(alpha: 0.3)
      ..strokeWidth = borderWidth + 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final middleGlowPaint = Paint()
      ..color = glowColor.withValues(alpha: 0.6)
      ..strokeWidth = borderWidth + 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final innerGlowPaint = Paint()
      ..color = glowColor
      ..strokeWidth = borderWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Draw the subtle traveling glow with multiple layers
    _drawSharpGlow(
      canvas,
      width,
      height,
      currentPosition,
      glowLength,
      outerGlowPaint,
    );
    _drawSharpGlow(
      canvas,
      width,
      height,
      currentPosition,
      glowLength,
      middleGlowPaint,
    );
    _drawSharpGlow(
      canvas,
      width,
      height,
      currentPosition,
      glowLength,
      innerGlowPaint,
    );
  }

  void _drawSharpGlow(
    Canvas canvas,
    double width,
    double height,
    double position,
    double glowLength,
    Paint glowPaint,
  ) {
    final perimeter = 2 * (width + height);
    double currentPos = position % perimeter;
    double endPos = (currentPos + glowLength) % perimeter;

    // Handle wrapping
    if (endPos < currentPos) {
      _drawGlowSegment(canvas, width, height, currentPos, perimeter, glowPaint);
      _drawGlowSegment(canvas, width, height, 0, endPos, glowPaint);
    } else {
      _drawGlowSegment(canvas, width, height, currentPos, endPos, glowPaint);
    }
  }

  void _drawGlowSegment(
    Canvas canvas,
    double width,
    double height,
    double startPos,
    double endPos,
    Paint glowPaint,
  ) {
    final perimeter = 2 * (width + height);
    startPos = startPos % perimeter;
    endPos = endPos % perimeter;

    if (startPos == endPos) return;

    // Left edge (top to bottom) - 0 to height
    if (startPos < height) {
      final startY = startPos;
      final endY = (endPos < height) ? endPos : height;
      if (endY > startY) {
        canvas.drawLine(Offset(0, startY), Offset(0, endY), glowPaint);
      }
    }
    // Bottom edge (left to right) - height to height + width
    else if (startPos < height + width) {
      final startX = startPos - height;
      final endX = (endPos < height + width) ? endPos - height : width;
      if (endX > startX) {
        canvas.drawLine(
          Offset(startX, height),
          Offset(endX, height),
          glowPaint,
        );
      }
    }
    // Right edge (bottom to top) - height + width to 2*height + width
    else if (startPos < 2 * height + width) {
      final startY = height - (startPos - height - width);
      final endY = (endPos < 2 * height + width)
          ? height - (endPos - height - width)
          : 0.0;
      if (startY > endY) {
        canvas.drawLine(Offset(width, endY), Offset(width, startY), glowPaint);
      }
    }
    // Top edge (right to left) - 2*height + width to 2*(height + width)
    else {
      final startX = width - (startPos - 2 * height - width);
      final endX = (endPos < 2 * (height + width))
          ? width - (endPos - 2 * height - width)
          : 0.0;
      if (startX > endX) {
        canvas.drawLine(Offset(endX, 0), Offset(startX, 0), glowPaint);
      }
    }
  }

  @override
  bool shouldRepaint(SharpGlowPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
