
import 'package:flutter_stripe/flutter_stripe.dart';

class StripeConfig {
  static String get publishableKey => const String.fromEnvironment(
    'STRIPE_PUBLISHABLE_KEY',
    defaultValue: '',
  );

  static bool get isEnabled {
    final key = publishableKey.trim();
    return key.isNotEmpty && key != 'pk_test_placeholder';
  }

  static Future<void> initialize() async {
    if (isEnabled) {
      Stripe.publishableKey = publishableKey;
    }
  }
}