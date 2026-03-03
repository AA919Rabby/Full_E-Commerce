import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:social_media/controllers/auths/auth_controller.dart';
import 'package:social_media/screens/profile_change.dart';
import 'package:flutter/services.dart';
import '../controllers/auths/pick_controller.dart';


class ProfileZoom extends StatefulWidget {
  const ProfileZoom({super.key});

  @override
  State<ProfileZoom> createState() => _ProfileZoomState();
}

class _ProfileZoomState extends State<ProfileZoom> {
  final PickController pickController = Get.find<PickController>();
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        leading: InkWell(
            onTap: () => Get.back(),
            child: const Icon(Icons.arrow_back, color: Colors.black, size: 25)),
        title: Text('Edit Profile',
            style:
                GoogleFonts.nunito(fontWeight: FontWeight.bold, fontSize: 20)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Obx(() {
                  ImageProvider provider;
                  if (authController.displayUserImage.value.isNotEmpty) {
                    provider = MemoryImage(
                        base64Decode(authController.displayUserImage.value));
                  } else if (pickController
                      .selectedImagePath.value.isNotEmpty) {
                    provider =
                        FileImage(File(pickController.selectedImagePath.value));
                  } else {
                    provider = const AssetImage('assets/images/ani.png');
                  }

                  return Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.blue, width: 4),
                      image:
                          DecorationImage(image: provider, fit: BoxFit.cover),
                    ),
                    child: Center(
                      child: InkWell(
                        onTap: () => Get.to(() => const ProfileChange()),
                        child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: Colors.black)),
                            child: const Icon(Icons.edit,
                                color: Colors.black, size: 20)),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),
              const Divider(color: Colors.grey, thickness: 0.50),
              const SizedBox(height: 15),
              Text('Account Settings',
                  style: GoogleFonts.nunito(
                      fontWeight: FontWeight.bold, fontSize: 22)),
              const SizedBox(height: 7),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Username',
                      style: GoogleFonts.nunito(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.grey)),
                  Obx(() => Text(authController.displayUserName.value,
                      style: GoogleFonts.nunito(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.grey))),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Phone Number',
                      style: GoogleFonts.nunito(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.grey)),
                  Obx(() => Text(authController.displayUserPhone.value,
                      style: GoogleFonts.nunito(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.grey))),
                ],
              ),
              const SizedBox(height: 8),
              const Divider(color: Colors.grey, thickness: 0.50),
              const SizedBox(height: 8),
              Text('Profile Settings',
                  style: GoogleFonts.nunito(
                      fontWeight: FontWeight.bold, fontSize: 22)),
              const SizedBox(height: 7),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('User Id',
                      style: GoogleFonts.nunito(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.grey)),
                  Row(
                    children: [
                      Text('749263943',
                          style: GoogleFonts.nunito(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.grey)),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () async {
                          await Clipboard.setData(
                              const ClipboardData(text: '749263943'));
                          Get.snackbar("Copied", "ID copied successfully");
                        },
                        child: const Icon(Icons.copy,
                            color: Colors.black, size: 20),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Email',
                      style: GoogleFonts.nunito(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.grey)),
                  Obx(() => Text(authController.displayUserEmail.value,
                      style: GoogleFonts.nunito(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.grey))),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
