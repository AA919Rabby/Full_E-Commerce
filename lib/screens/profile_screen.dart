import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/auths/auth_controller.dart';
import '../controllers/auths/firebase_controller.dart';
import '../controllers/auths/pick_controller.dart';
import 'cart_screen.dart';
import 'my_order.dart';
import 'profile_zoom.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final PickController pickController = Get.put(PickController());
  final AuthController authController = Get.find<AuthController>();
  final firebaseController = Get.put(FirebaseController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF0056D2),
                        const Color(0xFF0070E8),
                      ],
                    ),
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.elliptical(300, 100),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: -50,
                  child: Obx(() {
                    ImageProvider provider;

                    if (pickController.selectedImagePath.value.isNotEmpty) {
                      provider = FileImage(
                        File(pickController.selectedImagePath.value),
                      );
                    } else if (authController.displayUserImage.value.isNotEmpty) {
                      provider = MemoryImage(
                        base64Decode(authController.displayUserImage.value),
                      );
                    } else {
                      provider = const AssetImage('assets/images/ani.png');
                    }

                    return Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 5),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF0056D2).withValues(alpha: 0.2),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ],
                        image: DecorationImage(
                          image: provider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
            const SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(
                            () => Text(
                          authController.displayUserName.value,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.nunito(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Obx(
                            () => Text(
                          authController.displayUserEmail.value,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            color: const Color(0xFF818191),
                          ),
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => Get.to(() => const ProfileZoom()),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color(0xFF0056D2),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: Color(0xFF0056D2),
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Account Settings',
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 14),
                  ProfileMenuItem(
                    icon: 'assets/images/carts.png',
                    title: 'My Cart',
                    subtitle: 'Add, remove products and move to checkout',
                    onTap: () {
                      firebaseController.clearBadge();
                      Get.to(() => CartScreen());
                    },
                  ),
                  const SizedBox(height: 8),
                  ProfileMenuItem(
                    icon: 'assets/images/order.png',
                    title: 'My Orders',
                    subtitle: 'In-progress and Completed Orders',
                    onTap: () => Get.to(() => MyOrder()),
                  ),
                  const SizedBox(height: 40),
                  GestureDetector(
                    onTap: () {
                      Get.defaultDialog(
                        barrierDismissible: false,
                        title: 'Logout?',
                        middleText: 'Are you sure you want to logout?',
                        middleTextStyle: GoogleFonts.nunito(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                        titleStyle: GoogleFonts.nunito(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        radius: 16,
                        backgroundColor: Colors.white,
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                              onPressed: () => Get.back(),
                              child: Text(
                                'Cancel',
                                style: GoogleFonts.nunito(
                                  color: const Color(0xFF0056D2),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                authController.logout();
                              },
                              child: Text(
                                'Logout',
                                style: GoogleFonts.nunito(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.red, width: 1.5),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'Logout',
                          style: GoogleFonts.nunito(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileMenuItem extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF0056D2).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset(
                icon,
                color: const Color(0xFF0056D2),
                height: 24,
                width: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                      color: const Color(0xFF818191),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}