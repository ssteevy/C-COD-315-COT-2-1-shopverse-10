import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../wrapper/auth_wrapper.dart';

class SplashOnboardingScreen extends StatefulWidget {
  const SplashOnboardingScreen({super.key});

  @override
  State<SplashOnboardingScreen> createState() =>
      _SplashOnboardingScreenState();
}

class _SplashOnboardingScreenState extends State<SplashOnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      icon: Icons.currency_bitcoin,
      iconColor: AppColors.bitcoinOrange,
      title: 'Prix en Temps Réel',
      description:
          'Les prix évoluent automatiquement selon le cours du Bitcoin toutes les 30 secondes',
      gradient: [AppColors.bitcoinOrange, AppColors.bitcoinOrangeDark],
    ),
    OnboardingPage(
      icon: Icons.store_rounded,
      iconColor: AppColors.primaryBlue,
      title: 'Découvrez des Boutiques',
      description:
          'Explorez des commerces locaux et trouvez des produits uniques près de chez vous',
      gradient: [AppColors.primaryBlue, AppColors.secondaryPurple],
    ),
    OnboardingPage(
      icon: Icons.trending_up_rounded,
      iconColor: AppColors.success,
      title: 'Achetez Malin',
      description:
          'Profitez des variations du marché crypto pour faire les meilleures affaires',
      gradient: [AppColors.success, AppColors.btcStable],
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToAuth() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const AuthWrapper(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // PageView avec les slides
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              return _OnboardingPageWidget(page: _pages[index]);
            },
          ),

          // Indicateurs de page
          Positioned(
            bottom: 120,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 32 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? AppColors.bitcoinOrange
                        : Colors.grey.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),

          // Bouton suivant/commencer
          Positioned(
            bottom: 40,
            left: 24,
            right: 24,
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Bouton "Passer"
                  if (_currentPage < _pages.length - 1)
                    TextButton(
                      onPressed: _navigateToAuth,
                      child: const Text(
                        'Passer',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    )
                  else
                    const SizedBox(width: 80),

                  // Bouton principal
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_currentPage < _pages.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          _navigateToAuth();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.bitcoinOrange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 8,
                        shadowColor: AppColors.bitcoinOrange.withValues(alpha: 0.5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _currentPage < _pages.length - 1
                                ? 'Suivant'
                                : 'Commencer',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward_rounded),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Modèle de page d'onboarding
class OnboardingPage {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;
  final List<Color> gradient;

  OnboardingPage({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
    required this.gradient,
  });
}

// Widget pour afficher une page d'onboarding
class _OnboardingPageWidget extends StatelessWidget {
  final OnboardingPage page;

  const _OnboardingPageWidget({required this.page});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white,
            page.gradient[0].withValues(alpha: 0.05),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Icône avec animation
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 800),
                tween: Tween(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: page.gradient,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: page.iconColor.withValues(alpha: 0.3),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Icon(
                        page.icon,
                        size: 70,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 60),

              // Titre
              Text(
                page.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  height: 1.2,
                ),
              ),

              const SizedBox(height: 24),

              // Description
              Text(
                page.description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),

              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}