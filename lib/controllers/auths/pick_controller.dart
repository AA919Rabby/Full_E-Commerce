import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';



class PickController extends GetxController {

  var selectedImagePath = ''.obs;
  var base64Image = ''.obs;
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(
      source: source,
      imageQuality: 25,
      maxWidth: 400,
    );

    if (image != null) {
      selectedImagePath.value = image.path;

      File file = File(image.path);
      List<int> imageBytes = await file.readAsBytes();
      base64Image.value = base64Encode(imageBytes);
    }
  }

   clear() {
    selectedImagePath.value = '';
    base64Image.value = '';
  }


}