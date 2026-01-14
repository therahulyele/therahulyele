import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/colors.dart';
import '../widgets/animated_truth_logo.dart';
import '../widgets/glowing_border.dart';

class TruthResultScreen extends StatefulWidget {
  const TruthResultScreen({super.key});

  @override
  State<TruthResultScreen> createState() => _TruthResultScreenState();
}

class _TruthResultScreenState extends State<TruthResultScreen>
    with TickerProviderStateMixin {
  late AnimationController _counterController;
  late AnimationController _glitchController;
  late AnimationController _ctaController;

  late Animation<double> _counterAnimation;
  late Animation<double> _glitchAnimation;
  late Animation<double> _ctaFadeAnimation;
  late Animation<Offset> _ctaSlideAnimation;

  // Example data - replace with actual computed values
  final double _dailyHours = 5.3;
  final int _reels = 230;
  final int _lifeYearsLost = 9;
  final int _moneyLost = 72000;

  @override
  void initState() {
    super.initState();

    _counterController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _glitchController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _ctaController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _counterAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _counterController, curve: Curves.easeOut),
    );

    _glitchAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _glitchController, curve: Curves.easeInOut),
    );

    _ctaFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _ctaController, curve: Curves.easeOut));

    _ctaSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _ctaController, curve: Curves.easeOutCubic),
        );

    // Start animations in sequence
    _startAnimations();
  }

  void _startAnimations() async {
    // Start counter animation
    _counterController.forward();

    // Start glitch animation after counter
    await Future.delayed(const Duration(milliseconds: 2500));
    _glitchController.forward();

    // Start CTA animation after glitch
    await Future.delayed(const Duration(milliseconds: 1000));
    _ctaController.forward();
  }

  @override
  void dispose() {
    _counterController.dispose();
    _glitchController.dispose();
    _ctaController.dispose();
    super.dispose();
  }

  void _navigateToDashboard() {
    Navigator.pushReplacementNamed(context, '/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GlowingBorder(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated Truth logo
                  const AnimatedTruthLogo(
                    size: 80,
                    glitchDuration: Duration(milliseconds: 500),
                  ),
                  const SizedBox(height: 32),

                  // Animated counter text
                  AnimatedBuilder(
                    animation: _counterAnimation,
                    builder: (context, child) {
                      final dailyHours = (_dailyHours * _counterAnimation.value)
                          .toStringAsFixed(1);
                      final reels = (_reels * _counterAnimation.value).round();
                      final lifeYearsLost =
                          (_lifeYearsLost * _counterAnimation.value).round();
                      final moneyLost = (_moneyLost * _counterAnimation.value)
                          .round();

                      return Text(
                        "You spend ${dailyHours}h on your phone each day.\n"
                        "That's ≈ $reels reels a day.\n\n"
                        "At this pace, you'll lose $lifeYearsLost years of your life to the screen.\n"
                        "Worth about ₹$moneyLost every year.\n",
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 18,
                          height: 1.6,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      );
                    },
                  ),

                  const SizedBox(height: 30),

                  // Truth glitch text
                  AnimatedBuilder(
                    animation: _glitchAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(
                          (0.5 - _glitchAnimation.value) * 3, // Glitch effect
                          0,
                        ),
                        child: Opacity(
                          opacity: _glitchAnimation.value,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const AnimatedTruthLogo(
                                size: 16,
                                glitchDuration: Duration(milliseconds: 500),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "If nothing changes, this is your future.",
                                style: GoogleFonts.inter(
                                  color: AppColors.primary,
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 50),

                  // CTA Button
                  AnimatedBuilder(
                    animation: _ctaController,
                    builder: (context, child) {
                      return SlideTransition(
                        position: _ctaSlideAnimation,
                        child: FadeTransition(
                          opacity: _ctaFadeAnimation,
                          child: ElevatedButton(
                            onPressed: _navigateToDashboard,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.kPrimary,
                              foregroundColor: Colors.black,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 48,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'I want to take it back',
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // Micro-text
                  FadeTransition(
                    opacity: _ctaFadeAnimation,
                    child: Text(
                      'Truth will track your days and help you reclaim them.',
                      style: GoogleFonts.inter(
                        color: Colors.grey,
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
