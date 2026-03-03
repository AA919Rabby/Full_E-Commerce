import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CarouseloController extends GetxController {

  var selectedPage = 0.obs;

  final CarouselSliderController carouseloController =
  CarouselSliderController();

  final List<String> onboarding = [
    "https://images.unsplash.com/photo-1542291026-7eec264c27ff",
    "https://images.unsplash.com/photo-1505740420928-5e560c06d30e",
    "https://images.unsplash.com/photo-1523275335684-37898b6baf30",
  ];

  void nextPage() {
    carouseloController.nextPage(
      duration: const Duration(milliseconds: 300),
    );
  }
}