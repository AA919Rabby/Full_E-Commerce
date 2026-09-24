import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

class PaymentWebViewScreen extends StatefulWidget {
  const PaymentWebViewScreen({super.key});

  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  final RxDouble _progress = 0.0.obs;

  @override
  Widget build(BuildContext context) {
    final String? paymentUrl = Get.arguments;

    if (paymentUrl == null || paymentUrl.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('Invalid Payment URL')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri(paymentUrl)),
            initialSettings: InAppWebViewSettings(
              useHybridComposition: true,
              javaScriptEnabled: true,
              supportZoom: false,
            ),
            onProgressChanged: (controller, progress) {
              _progress.value = progress / 100;
            },
            onLoadStop: (controller, url) {
              final currentUrl = url.toString();
              _progress.value = 1.0;

              if (currentUrl.contains('success.html')) {
                Get.back(result: 'success');
                Get.snackbar('Success', 'Payment successful');
              } else if (currentUrl.contains('fail.html') ||
                  currentUrl.contains('cancel.html')) {
                Get.back(result: 'failed');
                Get.snackbar('Error', 'Your payment request failed');
              }
            },
            onReceivedError: (controller, request, error) {
              debugPrint('WebView Error: ${error.description}');
            },
          ),
          Obx(
                () => _progress.value < 1.0
                ? Container(
              color: Colors.white,
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              ),
            )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}