import 'package:flutter/material.dart';
import 'dart:async';
import '../../../core/constants/app_colors.dart';
import 'onboarding.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    // Configuration des animations
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Animation de scale (zoom in)
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    // Animation de fade (apparition)
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.8, curve: Curves.easeIn),
      ),
    );

    // Animation de rotation Bitcoin
    _rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Démarrer l'animation
    _controller.forward();

    // Navigation après 3 secondes
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const SplashOnboardingScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
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
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryBlue,
              AppColors.primaryBlue.withValues(alpha: 0.8),
              AppColors.bitcoinOrange.withValues(alpha: 0.3),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Particules animées en arrière-plan
            ...List.generate(
              20,
              (index) => _AnimatedParticle(
                delay: index * 0.1,
                duration: 3.0 + (index % 5),
              ),
            ),

            // Contenu principal
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo avec animation
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: RotationTransition(
                      turns: _rotationAnimation,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.bitcoinOrange.withValues(alpha: 0.5),
                              blurRadius: 30,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.storefront_rounded,
                          size: 60,
                          color: AppColors.bitcoinOrange,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Nom de l'app avec fade
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: const Column(
                      children: [
                        Text(
                          'ShopVerse',
                          style: TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 2,
                            shadows: [
                              Shadow(
                                color: Colors.black26,
                                offset: Offset(2, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.currency_bitcoin,
                              color: AppColors.bitcoinOrange,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Bitcoin Marketplace',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 60),

                  // Indicateur de chargement
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.bitcoinOrange,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Version en bas
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: const Text(
                  'v1.0.0',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget pour les particules animées
class _AnimatedParticle extends StatefulWidget {
  final double delay;
  final double duration;

  const _AnimatedParticle({
    required this.delay,
    required this.duration,
  });

  @override
  State<_AnimatedParticle> createState() => _AnimatedParticleState();
}

class _AnimatedParticleState extends State<_AnimatedParticle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  late double leftPosition;
  late double size;

  @override
  void initState() {
    super.initState();

    // Position aléatoire
    leftPosition = (widget.delay * 50) % 100;
    size = 4 + (widget.delay * 2) % 6;

    _controller = AnimationController(
      duration: Duration(milliseconds: (widget.duration * 1000).toInt()),
      vsync: this,
    );

    _animation = Tween<Offset>(
      begin: const Offset(0, -0.1),
      end: const Offset(0, 1.5),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));

    // Délai avant de démarrer
    Future.delayed(Duration(milliseconds: (widget.delay * 100).toInt()), () {
      if (mounted) {
        _controller.repeat();
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
    return SlideTransition(
      position: _animation,
      child: Align(
        alignment: Alignment(
          (leftPosition - 50) / 50,
          -1,
        ),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.3),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
