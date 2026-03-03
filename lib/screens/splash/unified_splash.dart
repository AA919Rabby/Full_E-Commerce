import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/splash_controller.dart';


class UnifiedSplash extends StatelessWidget {
  const UnifiedSplash({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SplashController());

    return Obx(() => Scaffold(
      //animation
      backgroundColor: controller.isSecondPhase.value ? Colors.black : Colors.white,
      body: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: controller.isSecondPhase.value
              ? Image.asset('assets/images/white.png', key: const ValueKey(1))
              : Image.asset('assets/images/black.png', key: const ValueKey(2)),
        ),
      ),
    ));
  }
}