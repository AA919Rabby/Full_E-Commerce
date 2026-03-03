import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_media/models/onboarding_model.dart';

class OnboardingController extends GetxController {
  var selectedPage = 0.obs;

  List<OnboardingModel> onboardingPages = [
    OnboardingModel(
      imagesAsset:'assets/images/intro1.png',
      title:'Welcome to UP Store',
      description:'Your one-stop destination for effortless and enjoyable shopping.',
    ),
    OnboardingModel(
      imagesAsset: 'assets/images/intro2.png',
      title: 'Shop Everything You Love!',
      description: 'Discover top-quality products at the best prices with a seamless experience.',
    ),
    OnboardingModel(
      imagesAsset: 'assets/images/intro3.png',
      title: 'Fast & Reliable Delivery!',
      description: 'Get your favorite items delivered to your doorstep, anytime, anywhere.',
    ),
  ];


}
