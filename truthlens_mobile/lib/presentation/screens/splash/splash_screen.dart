import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:truthlens_mobile/business_logic/blocs/auth/auth_bloc.dart';
import 'package:truthlens_mobile/business_logic/blocs/auth/auth_event.dart';
import 'package:truthlens_mobile/business_logic/blocs/auth/auth_state.dart';
import 'package:truthlens_mobile/services/splash_services.dart';

import '../../routes/app_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _subtitleController;
  late AnimationController _dotsController;

  late Animation<double> _logoFadeAnimation;
  late Animation<double> _logoScaleAnimation;
  late Animation<Offset> _textSlideAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<Offset> _subtitleSlideAnimation;
  late Animation<double> _subtitleFadeAnimation;
  late Animation<double> _dotsFadeAnimation;

  @override
  void initState() {
    super.initState();

    // Logo animations
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _logoFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _logoScaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOutBack),
      ),
    );

    // Text animations
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));

    _textFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeIn));

    // Subtitle animations
    _subtitleController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _subtitleSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(parent: _subtitleController, curve: Curves.easeOut),
        );

    _subtitleFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _subtitleController, curve: Curves.easeIn),
    );

    // Dots animation
    _dotsController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _dotsFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _dotsController, curve: Curves.easeIn));

    // Start animations in sequence
    _startAnimations();
    if (mounted) {
      context.read<AuthBloc>().add(const AutoLoginRequested());
      context.read<AuthBloc>().add(const GoogleAutoLoginRequested());
    }
  }

  void _startAnimations() async {
    // Check 1: Check mounted status before any AnimationController is used.
    if (!mounted) return;
    await Future.delayed(const Duration(milliseconds: 300));
    _logoController.forward();

    // Check 2: Check mounted status before the next chain of animations.
    if (!mounted) return;
    await Future.delayed(const Duration(milliseconds: 600));
    _textController.forward();

    // Check 3: Check mounted status.
    if (!mounted) return;
    await Future.delayed(const Duration(milliseconds: 400));
    _subtitleController.forward();

    // Check 4: Check mounted status.
    if (!mounted) return;
    await Future.delayed(const Duration(milliseconds: 300));
    _dotsController.forward();

    // Navigate to next screen after animations
    await Future.delayed(const Duration(milliseconds: 2000));

    // Determine the initial route (login or home) from the splash service
    final route = await SplashService.getInitialRoute();

    // // Check 5: Final check before attempting navigation (which disposes the widget)
    // if (!mounted) return;
    // Navigator.pushReplacementNamed(context, route);
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _subtitleController.dispose();
    _dotsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            // Navigate to home screen
            Navigator.pushReplacementNamed(context, AppRoutes.home);
          } else if (state is Unauthenticated) {
            // Navigate to login screen
            Navigator.pushReplacementNamed(context, AppRoutes.login);
          } else if (state is AuthError) {
            // Maybe show error, then go to login
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
            Navigator.pushReplacementNamed(context, AppRoutes.login);
          }
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/img2.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.5),
                  Colors.black.withOpacity(0.3),
                  Colors.purple.withOpacity(0.1),
                  Colors.purple.withOpacity(0.3),
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),

                  // Logo with animations
                  AnimatedBuilder(
                    animation: _logoController,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _logoFadeAnimation,
                        child: ScaleTransition(
                          scale: _logoScaleAnimation,
                          child: Container(
                            width: 200,
                            height: 140,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.remove_red_eye_outlined,
                                    color: Colors.lightBlueAccent,
                                    size: 40,
                                  ),
                                  const SizedBox(width: 20),
                                  Icon(
                                    Icons.shield_outlined,
                                    color: Colors.purpleAccent.shade100,
                                    size: 40,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 40),

                  // TruthLens text with slide up animation
                  AnimatedBuilder(
                    animation: _textController,
                    builder: (context, child) {
                      return SlideTransition(
                        position: _textSlideAnimation,
                        child: FadeTransition(
                          opacity: _textFadeAnimation,
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Truth',
                                  style: TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                                TextSpan(
                                  text: 'lens',
                                  style: TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.lightBlueAccent,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 12),

                  // Deepfake Detection subtitle with slide up animation
                  AnimatedBuilder(
                    animation: _subtitleController,
                    builder: (context, child) {
                      return SlideTransition(
                        position: _subtitleSlideAnimation,
                        child: FadeTransition(
                          opacity: _subtitleFadeAnimation,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Deepfake Detection',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.white.withOpacity(0.9),
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 30),

                  // Dots indicator
                  AnimatedBuilder(
                    animation: _dotsController,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _dotsFadeAnimation,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildDot(Colors.lightBlueAccent),
                            const SizedBox(width: 12),
                            _buildDot(Colors.purpleAccent.shade100),
                            const SizedBox(width: 12),
                            _buildDot(Colors.lightBlueAccent),
                          ],
                        ),
                      );
                    },
                  ),

                  const Spacer(),

                  // Loading indicator at bottom
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      if (state is AuthLoading) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 40.0),
                          child: Column(
                            children: [
                              SizedBox(
                                width: 30,
                                height: 30,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.lightBlueAccent,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Checking authentication...',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return const SizedBox(height: 80);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDot(Color color) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.5),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
    );
  }
}
