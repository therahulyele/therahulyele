import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/colors.dart';
import '../widgets/animated_text_line.dart';
import '../widgets/digit_slot_machine.dart';
import '../widgets/glowing_border.dart';

class RealityScreen extends StatefulWidget {
  const RealityScreen({super.key});

  @override
  State<RealityScreen> createState() => _RealityScreenState();
}

class _RealityScreenState extends State<RealityScreen>
    with TickerProviderStateMixin {
  late AnimationController _glitchController;
  late AnimationController _ctaController;
  late Animation<double> _glitchAnimation;
  late Animation<double> _ctaFadeAnimation;
  late Animation<Offset> _ctaSlideAnimation;

  @override
  void initState() {
    super.initState();

    // Glitch animation for the final quote
    _glitchController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _glitchAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _glitchController, curve: Curves.easeInOut),
    );

    // CTA button animation
    _ctaController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _ctaFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _ctaController, curve: Curves.easeOut));

    _ctaSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _ctaController, curve: Curves.easeOutCubic),
        );

    Future.delayed(const Duration(milliseconds: 8200), () {
      if (mounted) {
        _ctaController.forward();
      }
    });
  }

  @override
  void dispose() {
    _glitchController.dispose();
    _ctaController.dispose();
    super.dispose();
  }

  void _navigateToNext() {
    Navigator.pushNamed(context, '/truth_setup');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kBackground,
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // const SizedBox(height: 40),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedTextLine(
                          text: "An average person spends",
                          textStyle: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: AppColors.kTextWhite,
                            letterSpacing: 0.5,
                          ),
                          delay: const Duration(milliseconds: 0),
                          duration: const Duration(milliseconds: 400),
                          padding: const EdgeInsets.only(bottom: 12),
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            DigitSlotMachine(
                              text: "4.5",
                              textStyle: GoogleFonts.inter(
                                fontSize: 64,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.0,
                              ),
                              delay: const Duration(milliseconds: 400),
                              duration: const Duration(milliseconds: 700),
                            ),
                            const SizedBox(width: 8),

                            AnimatedTextLine(
                              text: "hours",
                              textStyle: GoogleFonts.inter(
                                fontSize: 28,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                                color: AppColors.kPrimary,
                              ),
                              delay: const Duration(milliseconds: 1150),
                              duration: const Duration(milliseconds: 300),
                              slideUp: true,
                            ),
                          ],
                        ),

                        AnimatedTextLine(
                          text: "on their phone every day.",
                          textStyle: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: AppColors.kTextWhite,
                            letterSpacing: 0.5,
                          ),
                          delay: const Duration(milliseconds: 1500),
                          duration: const Duration(milliseconds: 400),
                          padding: const EdgeInsets.only(bottom: 24),
                        ),

                        AnimatedTextLine(
                          text: "That's",
                          textStyle: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: AppColors.kTextWhite,
                            letterSpacing: 0.5,
                          ),
                          delay: const Duration(milliseconds: 2000),
                          duration: const Duration(milliseconds: 400),
                          padding: const EdgeInsets.only(bottom: 12),
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            DigitSlotMachine(
                              text: "1642",
                              textStyle: GoogleFonts.inter(
                                fontSize: 64,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.0,
                              ),
                              delay: const Duration(milliseconds: 2400),
                              duration: const Duration(milliseconds: 700),
                            ),
                            const SizedBox(width: 8),

                            AnimatedTextLine(
                              text: "hours",
                              textStyle: GoogleFonts.inter(
                                fontSize: 28,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                                color: AppColors.kPrimary,
                              ),
                              delay: const Duration(milliseconds: 3100),
                              duration: const Duration(milliseconds: 300),
                              slideUp: true,
                            ),
                          ],
                        ),

                        AnimatedTextLine(
                          text: "a year.",
                          textStyle: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: AppColors.kTextWhite,
                            letterSpacing: 0.5,
                          ),
                          delay: const Duration(milliseconds: 3500),
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.only(bottom: 24),
                        ),

                        AnimatedTextLine(
                          text: "Or about",
                          textStyle: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: AppColors.kTextWhite,
                            letterSpacing: 0.5,
                          ),
                          delay: const Duration(milliseconds: 3900),
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.only(bottom: 12),
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            DigitSlotMachine(
                              text: "11",
                              textStyle: GoogleFonts.inter(
                                fontSize: 64,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.0,
                              ),
                              delay: const Duration(milliseconds: 4200),
                              duration: const Duration(milliseconds: 700),
                            ),
                            const SizedBox(width: 8),

                            AnimatedTextLine(
                              text: "years",
                              textStyle: GoogleFonts.inter(
                                fontSize: 28,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                                color: AppColors.kPrimary,
                              ),
                              delay: const Duration(milliseconds: 4900),
                              duration: const Duration(milliseconds: 300),
                              slideUp: true,
                            ),
                          ],
                        ),

                        AnimatedTextLine(
                          text: "of your life.",
                          textStyle: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: AppColors.kTextWhite,
                            letterSpacing: 0.5,
                          ),
                          delay: const Duration(milliseconds: 5200),
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.only(bottom: 24),
                        ),

                        _buildGlitchText(),
                      ],
                    ),

                    const SizedBox(height: 40),

                    _buildCTAButton(),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlitchText() {
    return AnimatedBuilder(
      animation: _glitchAnimation,
      builder: (context, child) {
        Future.delayed(const Duration(milliseconds: 3000), () {
          if (mounted) {
            _glitchController.forward();
          }
        });

        return Transform.translate(
          offset: Offset((0.5 - _glitchAnimation.value) * 2, 0),
          child: Opacity(
            opacity: _glitchAnimation.value,
            child: Text(
              "Time you'll never get back.",
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w300,
                color: AppColors.kTextGrey,
                letterSpacing: 0.8,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }

  Widget _buildCTAButton() {
    return AnimatedBuilder(
      animation: _ctaController,
      builder: (context, child) {
        return SlideTransition(
          position: _ctaSlideAnimation,
          child: FadeTransition(
            opacity: _ctaFadeAnimation,
            child: Container(
              width: double.infinity,
              height: 56,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: ElevatedButton(
                onPressed: _navigateToNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.kPrimary,
                  foregroundColor: Colors.black,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                ),
                child: Text(
                  "See your truth",
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
