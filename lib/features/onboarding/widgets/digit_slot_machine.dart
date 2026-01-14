import 'package:flutter/material.dart';
import 'package:slot_machine_roller/slot_machine_roller.dart';

class DigitSlotMachine extends StatefulWidget {
  final String text;
  final TextStyle? textStyle;
  final Duration delay;
  final Duration duration;
  final TextAlign textAlign;
  final EdgeInsets padding;
  final List<Color> gradientColors;

  const DigitSlotMachine({
    super.key,
    required this.text,
    this.textStyle,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 600),
    this.textAlign = TextAlign.center,
    this.padding = EdgeInsets.zero,
    this.gradientColors = const [Color(0xFFFF7A45), Color(0xFFFF7A45)],
  });

  @override
  State<DigitSlotMachine> createState() => _DigitSlotMachineState();
}

class _DigitSlotMachineState extends State<DigitSlotMachine>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  // Original characters of the input text (kept as-is)
  List<String> _chars = [];
  // Targets for digit positions only; non-digit indices remain null
  List<int?> _digitTargets = [];
  // Mutable list used to trigger each roller individually over time
  List<int?> _currentTargets = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);

    // No fade; rely on slide + scale + roller motion for clarity

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.0, 0.5, curve: Curves.easeOutCubic),
          ),
        );

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.8, curve: Curves.elasticOut),
      ),
    );

    // Parse the text to extract digits
    _parseDigits();

    // Start animation after delay
    Future.delayed(widget.delay, () {
      if (mounted) {
        _startAnimation();
      }
    });
  }

  void _parseDigits() {
    _chars = widget.text.split("");
    _digitTargets = List<int?>.filled(_chars.length, null);
    _currentTargets = List<int?>.filled(_chars.length, null);
    for (int i = 0; i < _chars.length; i++) {
      final char = _chars[i];
      if (RegExp(r'^[0-9]$').hasMatch(char)) {
        _digitTargets[i] = int.parse(char);
      }
    }
  }

  void _startAnimation() {
    setState(() {
      // _isAnimating = true; // This line is removed
    });
    _controller.forward();

    // Stagger per-character roll for digits only
    const int perDigitStaggerMs = 90;
    for (int i = 0; i < _currentTargets.length; i++) {
      if (_digitTargets[i] == null) continue; // skip non-digits
      Future.delayed(Duration(milliseconds: i * perDigitStaggerMs), () {
        if (!mounted) return;
        setState(() {
          _currentTargets[i] = _digitTargets[i];
        });
      });
    }
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
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: _buildSlotMachine(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSlotMachine() {
    // Compute responsive sizes based on provided textStyle
    final double baseSize = (widget.textStyle?.fontSize ?? 40);
    final double digitFontSize = baseSize; // keep uniform size as provided
    final double slotWidth = digitFontSize * 0.6;
    final double slotHeight = digitFontSize * 1.1;
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: widget.gradientColors,
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(bounds),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Calculate if we need to wrap or use single row
          double totalWidth =
              _chars.length * (slotWidth + 1.0); // approx per char
          bool needsWrap = totalWidth > constraints.maxWidth;

          if (needsWrap) {
            return Wrap(
              alignment: WrapAlignment.center,
              children: List.generate(_chars.length, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 0.5),
                  child: _buildDigitSlot(
                    index,
                    slotWidth,
                    slotHeight,
                    digitFontSize,
                  ),
                );
              }),
            );
          } else {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: List.generate(_chars.length, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 0.5),
                  child: _buildDigitSlot(
                    index,
                    slotWidth,
                    slotHeight,
                    digitFontSize,
                  ),
                );
              }),
            );
          }
        },
      ),
    );
  }

  Widget _buildDigitSlot(
    int index,
    double slotWidth,
    double slotHeight,
    double digitFontSize,
  ) {
    final char = _chars[index];
    final isDigit = RegExp(r'^[0-9]$').hasMatch(char);
    if (!isDigit) {
      // Render punctuation and spaces directly for accurate layout/appearance
      if (char == ' ') {
        return SizedBox(width: slotWidth * 0.6);
      }
      return Container(
        height: slotHeight,
        width: slotWidth * 0.64,
        alignment: Alignment.center,
        child: Text(
          char,
          style: widget.textStyle?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            fontSize: digitFontSize,
          ),
        ),
      );
    }

    return SlotMachineRoller(
      height: slotHeight,
      width: slotWidth,
      target: _currentTargets[index],
      reverse: false,
      itemBuilder: (digit) =>
          _buildDigitItem(digit, digitFontSize, slotWidth, slotHeight),
    );
  }

  Widget _buildDigitItem(
    int? digit,
    double digitFontSize,
    double slotWidth,
    double slotHeight,
  ) {
    String displayText;

    if (digit == null) {
      displayText = '?';
    } else if (digit == 10) {
      displayText = '.';
    } else if (digit == 11) {
      displayText = ',';
    } else if (digit == 12) {
      displayText = ' ';
    } else {
      displayText = digit.toString();
    }

    return Container(
      height: slotHeight,
      width: slotWidth,
      alignment: Alignment.center,
      child: Text(
        displayText,
        style: widget.textStyle?.copyWith(
          color: Colors.white, // This will be overridden by the shader
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
          fontSize: digitFontSize,
        ),
      ),
    );
  }
}
