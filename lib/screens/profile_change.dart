import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media/controllers/auths/auth_controller.dart';
import 'package:social_media/widgets/custom_auth.dart';
import '../controllers/auths/pick_controller.dart';


class ProfileChange extends StatefulWidget {
  const ProfileChange({super.key});

  @override
  State<ProfileChange> createState() => _ProfileChangeState();
}

class _ProfileChangeState extends State<ProfileChange> {
  final PickController pickController = Get.put(PickController());
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: InkWell(
            onTap: () => Get.back(),
            child: const Icon(Icons.arrow_back, color: Colors.black, size: 25)),
        title: Text('Change Profile',
            style: GoogleFonts.nunito(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 45),
              Center(
                child: Obx(() {
                  ImageProvider provider;
                  if (pickController.selectedImagePath.value.isNotEmpty) {
                    provider = FileImage(File(pickController.selectedImagePath.value));
                  } else if (authController.displayUserImage.value.isNotEmpty) {
                    provider = MemoryImage(base64Decode(authController.displayUserImage.value));
                  } else {
                    provider = const AssetImage('assets/images/ani.png');
                  }

                  return Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.blue, width: 4),
                      shape: BoxShape.circle,
                      image: DecorationImage(image: provider, fit: BoxFit.cover),
                    ),
                    child: InkWell(
                      onTap: () {
                        Get.bottomSheet(
                          Container(
                            color: Colors.white,
                            child: Wrap(
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.photo_library),
                                  title: const Text('Gallery'),
                                  onTap: () {
                                    pickController.pickImage(ImageSource.gallery);
                                    Get.back();
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.camera_alt),
                                  title: const Text('Camera'),
                                  onTap: () {
                                    pickController.pickImage(ImageSource.camera);
                                    Get.back();
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      child: const Align(
                        alignment: Alignment.bottomRight,
                        child: CircleAvatar(
                          backgroundColor: Colors.blue,
                          radius: 18,
                          child: Icon(Icons.add, color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 26),
              CustomAuth(
                controller: authController.changeFirstName,
                validator: (value) => (value == null || value.isEmpty) ? 'Please enter first name' : null,
                labelText: 'First name',
                hintText: 'First name',
                prefixIcon: Image.asset('assets/images/person.png'),
              ),
              const SizedBox(height: 12),
              CustomAuth(
                controller: authController.changeLastName,
                validator: (value) => (value == null || value.isEmpty) ? 'Please enter last name' : null,
                labelText: 'Last name',
                hintText: 'Last name',
                prefixIcon: Image.asset('assets/images/person.png'),
              ),
              const SizedBox(height: 60),
              Obx(() => authController.isLoading.value
                  ? const CircularProgressIndicator()
                  : InkWell(
                onTap: () async {
                  authController.isLoading.value = true;
                  try {

                    await authController.updateProfileName();


                    if (pickController.selectedImagePath.value.isNotEmpty) {
                      await authController.syncProfileImageToFirestore(pickController.selectedImagePath.value);

                      pickController.selectedImagePath.value = '';
                    }

                    await authController.fetchUserData();

                    Get.back();
                    Get.snackbar("Success", "Profile Updated");
                  } catch (e) {
                    print("Save error: $e");
                  } finally {
                    authController.isLoading.value = false;
                  }
                },
                child: Container(
                  width: 318,
                  height: 48,
                  decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(10)),
                  child: Center(child: Text('Save',
                      style: GoogleFonts.nunito(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 17))),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}