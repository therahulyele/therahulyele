import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../theme/colors.dart';
import '../../../core/utils/permission_utils.dart';
import '../widgets/animated_truth_logo.dart';
import '../widgets/glowing_border.dart';

class TruthSetupScreen extends StatefulWidget {
  const TruthSetupScreen({super.key});

  @override
  State<TruthSetupScreen> createState() => _TruthSetupScreenState();
}

class _TruthSetupScreenState extends State<TruthSetupScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  final _nameController = TextEditingController();
  DateTime? _dateOfBirth;
  bool _isStudent = true;
  final _salaryController = TextEditingController();
  bool _permissionGranted = false;
  bool _showNextButton = false;
  bool _isCheckingPermission = false;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _fadeController.forward();

    // Add lifecycle observer
    WidgetsBinding.instance.addObserver(this);

    // Check permission status on init
    _checkPermissionStatus();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _nameController.dispose();
    _salaryController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // Check permission when app comes back to foreground
    if (state == AppLifecycleState.resumed && !_permissionGranted) {
      _checkPermissionStatus();
    }
  }

  Future<void> _selectDateOfBirth() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      initialDate: DateTime(2000),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              onPrimary: Colors.black,
              surface: Colors.grey,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _dateOfBirth = picked;
        _checkFormCompletion();
      });
    }
  }

  Future<void> _checkPermissionStatus() async {
    try {
      // Check if usage access permission is granted
      final hasPermission = await PermissionUtils.hasUsageAccessPermission();

      if (hasPermission) {
        setState(() {
          _permissionGranted = true;
          _isCheckingPermission = false;
          _checkFormCompletion();
        });
      } else {
        setState(() {
          _permissionGranted = false;
          _isCheckingPermission = false;
        });
      }
    } catch (e) {
      // If permission check fails, assume not granted
      setState(() {
        _permissionGranted = false;
        _isCheckingPermission = false;
      });
    }
  }

  Future<void> _requestPermission() async {
    setState(() {
      _isCheckingPermission = true;
    });

    try {
      // Request usage access permission
      final success = await PermissionUtils.requestUsageAccessPermission();

      if (success) {
        // Start checking permission status periodically
        _startPermissionCheck();
      } else {
        setState(() {
          _isCheckingPermission = false;
        });

        // Fallback: show dialog
        _showPermissionDialog();
      }
    } catch (e) {
      setState(() {
        _isCheckingPermission = false;
      });

      // Fallback: show dialog
      _showPermissionDialog();
    }
  }

  void _startPermissionCheck() {
    // Check permission every 2 seconds when app comes back to foreground
    Future.delayed(const Duration(seconds: 2), () async {
      if (mounted) {
        await _checkPermissionStatus();

        if (!_permissionGranted) {
          // Continue checking if permission not granted yet
          _startPermissionCheck();
        } else {
          setState(() {
            _isCheckingPermission = false;
          });
        }
      }
    });
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          'Permission Required',
          style: GoogleFonts.inter(color: Colors.white),
        ),
        content: Text(
          'Truth needs access to your screen time data to show you what you\'re losing. No private information is collected - only time usage.',
          style: GoogleFonts.inter(color: Colors.grey[300]),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: GoogleFonts.inter(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: Text(
              'Open Settings',
              style: GoogleFonts.inter(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  void _checkFormCompletion() {
    final isComplete =
        _nameController.text.isNotEmpty &&
        _dateOfBirth != null &&
        _permissionGranted &&
        (_isStudent || _salaryController.text.isNotEmpty);

    if (isComplete && !_showNextButton) {
      setState(() {
        _showNextButton = true;
      });
    }
  }

  void _navigateToResult() {
    Navigator.pushNamed(context, '/truth_result');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GlowingBorder(
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom,
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 40.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Truth introduction with animated logo
                      Column(
                        children: [
                          const AnimatedTruthLogo(
                            size: 100,
                            glitchDuration: Duration(milliseconds: 500),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'I am Truth.\n\nTo reveal what you\'re losing,\nI need to know you — and see your time.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 18,
                              height: 1.4,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // Form fields
                      TextField(
                        controller: _nameController,
                        style: GoogleFonts.inter(color: Colors.white),
                        onChanged: (_) => _checkFormCompletion(),
                        decoration: InputDecoration(
                          labelText: "What do they call you?",
                          labelStyle: GoogleFonts.inter(color: Colors.grey),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.primary),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Date picker
                      InkWell(
                        onTap: _selectDateOfBirth,
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: "When did your time begin?",
                            labelStyle: GoogleFonts.inter(color: Colors.grey),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: AppColors.primary),
                            ),
                          ),
                          child: Text(
                            _dateOfBirth != null
                                ? '${_dateOfBirth!.day}/${_dateOfBirth!.month}/${_dateOfBirth!.year}'
                                : 'Select your date of birth',
                            style: GoogleFonts.inter(
                              color: _dateOfBirth != null
                                  ? Colors.white
                                  : Colors.grey,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Student toggle
                      SwitchListTile(
                        value: _isStudent,
                        onChanged: (value) {
                          setState(() {
                            _isStudent = value;
                            if (value) {
                              _salaryController.clear();
                            }
                            _checkFormCompletion();
                          });
                        },
                        activeThumbColor: AppColors.primary,
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          "Are you still studying?",
                          style: GoogleFonts.inter(color: Colors.white),
                        ),
                      ),

                      // Salary field (only if not student)
                      if (!_isStudent) ...[
                        const SizedBox(height: 10),
                        TextField(
                          controller: _salaryController,
                          keyboardType: TextInputType.number,
                          style: GoogleFonts.inter(color: Colors.white),
                          onChanged: (_) => _checkFormCompletion(),
                          decoration: InputDecoration(
                            labelText: "What's your monthly income?",
                            labelStyle: GoogleFonts.inter(color: Colors.grey),
                            prefixText: "₹ ",
                            prefixStyle: GoogleFonts.inter(color: Colors.white),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: AppColors.primary),
                            ),
                          ),
                        ),
                      ],

                      const SizedBox(height: 24),

                      // Permission button
                      ElevatedButton(
                        onPressed: _permissionGranted || _isCheckingPermission
                            ? null
                            : _requestPermission,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _permissionGranted
                              ? Colors.grey[800]
                              : _isCheckingPermission
                              ? Colors.grey[600]
                              : AppColors.primary,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                        ),
                        child: _isCheckingPermission
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.black,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Checking...",
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              )
                            : Text(
                                _permissionGranted
                                    ? "✓ Permission Granted"
                                    : "Grant Permission",
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),

                      const SizedBox(height: 30),

                      // Next button (appears when form is complete)
                      if (_showNextButton)
                        AnimatedOpacity(
                          opacity: _showNextButton ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 500),
                          child: ElevatedButton(
                            onPressed: _navigateToResult,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.kPrimary,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 48,
                                vertical: 16,
                              ),
                            ),
                            child: Text(
                              'Show me my Truth',
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
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
      ),
    );
  }
}
