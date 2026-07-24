import "package:bloco_na_rua/routing/routes.dart";
import "package:bloco_na_rua/ui/core/widgets/buttons/app_button.dart";
import "package:bloco_na_rua/ui/core/tokens/app_colors.dart";
import "package:bloco_na_rua/ui/core/tokens/app_spacing.dart";
import "package:bloco_na_rua/ui/core/tokens/app_typography.dart";
import "package:bloco_na_rua/ui/onboarding/screens/onboarding_1_screen.dart";
import "package:bloco_na_rua/ui/onboarding/screens/onboarding_2_screen.dart";
import "package:bloco_na_rua/ui/onboarding/screens/onboarding_3_screen.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

class OnboardingWrapper extends StatefulWidget {
  const OnboardingWrapper({super.key});

  @override
  State<OnboardingWrapper> createState() => _OnboardingWrapperState();
}

class _OnboardingWrapperState extends State<OnboardingWrapper> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Widget> _pages = const [
    Onboarding1Screen(),
    Onboarding2Screen(),
    Onboarding3Screen(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  void _completeOnboarding() {
    // Onboarding completed - navigation to home
    context.go(Routes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(Spacing.space_sm),
                child: TextButton(
                  onPressed: _skipOnboarding,
                  child: Text(
                    "Pular",
                    style: AppTypography.labelLarge.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ),
            // Page content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) => _pages[index],
              ),
            ),
            // Dots indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (index) => _buildDot(index),
              ),
            ),
            const SizedBox(height: Spacing.space_lg),
            // Next/Start button
            Padding(
              padding: const EdgeInsets.all(Spacing.pagePaddingMobile),
              child: AppButton(
                label: _currentPage == _pages.length - 1
                    ? "Começar"
                    : "Próximo",
                onPressed: _nextPage,
                isFullWidth: true,
                variant: AppButtonVariant.accent,
              ),
            ),
            const SizedBox(height: Spacing.space_md),
          ],
        ),
      ),
    );
  }

  Widget _buildDot(int index) {
    final isActive = index == _currentPage;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: Spacing.space_2xs),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: isActive ? AppColors.primary : AppColors.borderLight,
      ),
    );
  }
}
