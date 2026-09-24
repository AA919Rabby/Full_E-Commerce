import 'package:get/get.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import '../config/stripe_config.dart';

class StripePaymentService {
  static Future<void> pay({required double amount}) async {
    if (!StripeConfig.isEnabled) {
      Get.snackbar(
        'Stripe not configured',
        'Add your Stripe publishable key and backend PaymentIntent endpoint before enabling live checkout.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      Get.snackbar(
        'Stripe ready',
        'Stripe checkout is enabled. Connect this with your backend PaymentIntent API to complete the real transaction.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar('Stripe error', e.toString());
    }
  }
}

