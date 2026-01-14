import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../../../theme/colors.dart';
import '../widgets/glowing_border.dart';
import '../widgets/animated_truth_logo.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen>
    with TickerProviderStateMixin {
  late AnimationController _ctaController;
  late Animation<double> _ctaFadeAnimation;
  late Animation<double> _ctaPulseAnimation;

  @override
  void initState() {
    super.initState();

    _ctaController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _ctaFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _ctaController, curve: Curves.easeOut));

    _ctaPulseAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _ctaController, curve: Curves.easeInOut));

    // Start CTA animation after text finishes
    Future.delayed(const Duration(milliseconds: 4000), () {
      if (mounted) {
        _ctaController.forward();
      }
    });
  }

  @override
  void dispose() {
    _ctaController.dispose();
    super.dispose();
  }

  void _navigateToReality() {
    Navigator.pushNamed(context, '/reality');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GlowingBorder(
        child: SafeArea(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Typewriter text animation
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: AnimatedTextKit(
                        animatedTexts: [
                          TypewriterAnimatedText(
                            'This isn\'t a productivity app.\nThis is a mirror.\n\n'
                            'It won\'t motivate you.\nIt will tell you the truth.\n\n'
                            'Are you ready?',
                            textStyle: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 20,
                              height: 1.6,
                              fontWeight: FontWeight.w400,
                            ),
                            speed: const Duration(milliseconds: 50),
                          ),
                        ],
                        totalRepeatCount: 1,
                      ),
                    ),

                    const SizedBox(height: 40),

                    // CTA Button with pulse animation
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: AnimatedBuilder(
                        animation: _ctaController,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _ctaPulseAnimation.value,
                            child: FadeTransition(
                              opacity: _ctaFadeAnimation,
                              child: ElevatedButton(
                                onPressed: _navigateToReality,
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
                                  'Get Started',
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
                    ),

                    const SizedBox(height: 16),

                    // Micro-text with Truth logo
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: FadeTransition(
                        opacity: _ctaFadeAnimation,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const AnimatedTruthLogo(
                              size: 16,
                              glitchDuration: Duration(milliseconds: 500),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Only a few make it past this screen.',
                              style: GoogleFonts.inter(
                                color: Colors.grey,
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
