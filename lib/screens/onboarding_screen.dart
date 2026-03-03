import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_media/screens/splash/unified_splash.dart';
import '../controllers/auths/auth_controller.dart';
import '../controllers/onboarding_controller.dart';


class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({super.key});

  //final authController = Get.put(AuthController());

  final OnboardingController _controller = Get.put(OnboardingController());

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    //Future.microtask(() => authController.checkUser());
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              onPageChanged: _controller.selectedPage,
              itemCount: _controller.onboardingPages.length,
              itemBuilder: (context, index) {
                var page = _controller.onboardingPages[index];
                return Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 100),
                      Image.asset(page.imagesAsset, height: 250),
                      const SizedBox(height: 20),

                      Text(
                        page.title,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.nunito(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 5),

                      Text(
                        page.description,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          color: Colors.black.withOpacity(.6),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            // Skip Button
            Positioned(
              top: 20,
              right: 20,
              child: Obx(() {
                bool isLastPage = _controller.selectedPage.value ==
                    _controller.onboardingPages.length - 1;
                return isLastPage
                    ? const SizedBox.shrink()
                    : TextButton(
                  onPressed: () {
                    _pageController.jumpToPage(
                        _controller.onboardingPages.length - 1);
                  },
                  child: Text(
                    'Skip',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w400,
                      color: Colors.blue,
                      fontSize: 14,
                    ),
                  ),
                );
              }),
            ),

            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Column(
                children: [

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _controller.onboardingPages.length,
                          (index) => Obx(() => Container(
                        margin: const EdgeInsets.all(4),
                        width: _controller.selectedPage.value == index ? 37 : 16,
                        height: 6,
                        decoration: BoxDecoration(
                          color: _controller.selectedPage.value == index
                              ? Colors.blue
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      )),
                    ),
                  ),
                  const SizedBox(height: 150),
                  // Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_controller.selectedPage.value ==
                            _controller.onboardingPages.length - 1) {
                          Get.offAll(()=>UnifiedSplash());
                        } else {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInQuad,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0056D2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Obx(() => Text(
                        _controller.selectedPage.value ==
                            _controller.onboardingPages.length - 1
                            ? "Get Started"
                            : "Next",
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}