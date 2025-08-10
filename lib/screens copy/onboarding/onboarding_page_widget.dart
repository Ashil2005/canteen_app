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
        Image.asset(model.image, height: 300),
        const SizedBox(height: 40),
        Text(
          model.title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFFB9375D),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            model.description,
            style: const TextStyle(fontSize: 16, color: AppColors.textColor),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
