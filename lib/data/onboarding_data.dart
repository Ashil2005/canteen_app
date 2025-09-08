import '../models/onboarding_model.dart';

/// Make sure these filenames exactly match what's inside /assets/images
/// (case-sensitive, especially on web).
final List<OnboardingModel> onboardingData = [
  OnboardingModel(
    image: 'assets/images/pic_1.png',
    title: 'Fresh & Hot Meals',
    description: 'Enjoy freshly prepared meals served at your college canteen.',
  ),
  OnboardingModel(
    image: 'assets/images/pic_2.png',
    title: 'Fast & Easy Ordering',
    description: 'Order in a few taps and pick up without waiting in line.',
  ),
  OnboardingModel(
    image: 'assets/images/pic_3.png',
    title: 'Track & Pay',
    description: 'Keep an eye on your orders and pay securely.',
  ),
];
