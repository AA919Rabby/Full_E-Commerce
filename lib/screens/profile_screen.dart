import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:social_media/controllers/auths/auth_controller.dart';
import 'package:social_media/screens/auths/login.dart';
import 'package:social_media/screens/cart_screen.dart';
import 'package:social_media/screens/my_order.dart';
import 'package:social_media/screens/profile_zoom.dart';
import '../controllers/auths/pick_controller.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final PickController pickController = Get.put(PickController());
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(backgroundColor: Colors.white, elevation: 0, toolbarHeight: 0),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.vertical(
                        bottom: Radius.elliptical(300, 100)),
                  ),
                ),
                Positioned(
                  bottom: -45,
                  child: Obx(() {
                    ImageProvider provider;

                    if (pickController.selectedImagePath.value.isNotEmpty) {
                      provider = FileImage(
                          File(pickController.selectedImagePath.value));
                    }

                    else if (authController.displayUserImage.value.isNotEmpty) {
                      provider = MemoryImage(
                          base64Decode(authController.displayUserImage.value));
                    }

                    else {
                      provider = const AssetImage('assets/images/ani.png');
                    }

                    return Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.blue, width: 4),
                        image:
                            DecorationImage(image: provider, fit: BoxFit.cover),
                      ),
                    );
                  }),
                ),
              ],
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() => Text(authController.displayUserName.value,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.nunito(
                              fontWeight: FontWeight.bold, fontSize: 20))),
                      const SizedBox(height: 5),
                      Obx(() => Text(authController.displayUserEmail.value,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.nunito(fontSize: 16))),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => Get.to(() => const ProfileZoom()),
                    child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.black)),
                        child: const Icon(Icons.edit,
                            color: Colors.black, size: 22)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Account Settings',
                      style: GoogleFonts.nunito(
                          fontWeight: FontWeight.bold, fontSize: 22)),
                  const SizedBox(height: 12),
                  ListTile(
                    onTap: () => Get.to(() => CartScreen()),
                    leading: Image.asset('assets/images/carts.png',
                        color: Colors.blue, height: 30, width: 40),
                    title: Text('My Cart',
                        style: GoogleFonts.nunito(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                    subtitle: Text('Add, remove products and move to checkout',
                        style: GoogleFonts.nunito(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.grey)),
                  ),
                  const SizedBox(height: 7),
                  ListTile(
                    onTap: () => Get.to(() => MyOrder()),
                    leading: Image.asset('assets/images/order.png',
                        color: Colors.blue, height: 30, width: 40),
                    title: Text('My Orders',
                        style: GoogleFonts.nunito(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                    subtitle: Text('In-progress and Completed Orders',
                        style: GoogleFonts.nunito(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.grey)),
                  ),
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: () {
                      Get.defaultDialog(
                        barrierDismissible: false,
                        title: "Logout?",
                        middleText: 'Do you want to Logout?',
                        titleStyle: GoogleFonts.nunito(
                            fontWeight: FontWeight.bold, fontSize: 20),
                        radius: 0,
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                                onPressed: () => Get.back(),
                                child: Text("No",
                                    style: GoogleFonts.nunito(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold))),
                            TextButton(
                                onPressed: () {
                                  authController.logout();
                                },
                                child: Text("Yes",
                                    style: GoogleFonts.nunito(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold))),
                          ],
                        ),
                      );
                    },
                    child: Center(
                      child: Container(
                        width: 318,
                        height: 48,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                            child: Text('Logout',
                                style: GoogleFonts.nunito(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 17))),
                      ),
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
