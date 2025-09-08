import 'package:flutter/material.dart';
import '../../models/onboarding_model.dart';
import '../../constants/colors.dart';

class OnboardingPageWidget extends StatelessWidget {
  final OnboardingModel model;
  const OnboardingPageWidget({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          model.image,
          height: 300,
          fit: BoxFit.contain,
          gaplessPlayback: true,
          // Helpful guard during dev if a filename is wrong
          errorBuilder: (_, __, ___) => const Icon(
            Icons.image_not_supported,
            size: 120,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 40),
        Text(
          model.title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            model.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textColor,
            ),
          ),
        ),
      ],
    );
  }
}
