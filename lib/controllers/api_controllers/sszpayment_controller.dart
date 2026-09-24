import 'dart:convert';

import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SszpaymentController extends GetxController {
  var isLoading = false.obs;

  final String stripeBackendUrl = const String.fromEnvironment(
    'STRIPE_BACKEND_URL',
    defaultValue: '',
  );

  final String stripePublishableKey = const String.fromEnvironment(
    'STRIPE_PUBLISHABLE_KEY',
    defaultValue: '',
  );

  Future<void> initiatePayment(double amount) async {
    if (stripePublishableKey.isNotEmpty) {
      await initiateInAppStripePayment(amount);
      return;
    }

    await initiateSslPayment(amount);
  }

  Future<void> initiateInAppStripePayment(double amount) async {
    if (stripeBackendUrl.isEmpty) {
      Get.snackbar(
        'Stripe setup needed',
        'Set STRIPE_BACKEND_URL in your environment and create a backend PaymentIntent endpoint.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse('$stripeBackendUrl/create-payment-intent'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'amount': (amount * 100).toInt(),
          'currency': 'usd',
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Unable to create Stripe PaymentIntent');
      }

      final data = jsonDecode(response.body);

      final clientSecret = data['clientSecret'];
      if (clientSecret == null || clientSecret.toString().isEmpty) {
        throw Exception(data['error'] ?? 'Missing client secret');
      }

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Your Store',
          customerId: data['customerId'],
          customerEphemeralKeySecret: data['ephemeralKey'],
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      Get.snackbar(
        'Payment successful',
        'Your payment was completed inside the app.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Payment failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> initiateSslPayment(double amount) async {
    isLoading.value = true;

    try {
      Get.snackbar(
        'SSL payment flow',
        'Payment is using the previous gateway flow.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}