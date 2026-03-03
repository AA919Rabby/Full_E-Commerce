import 'package:get/get.dart';

class LoginController extends GetxController {

  var isPasswordVisible = false.obs;
  var isRemember=false.obs;

  void onChanged(bool? value) {
    isRemember.value = value??false;
  }


  void toggleVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }


}