import 'package:get/get.dart';
import '../screens/auths/login.dart';



class SplashController extends GetxController {
  var isSecondPhase = false.obs;

  @override
  void onInit() {
    super.onInit();
    startSplashSequence();
  }

  void startSplashSequence() async {
    // Phase 1
    await Future.delayed(const Duration(seconds: 2));
    isSecondPhase.value = true;

    // Phase 2
    await Future.delayed(const Duration(seconds: 2));
    Get.offAll(() =>  Login());
  }
}