import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/auths/firebase_controller.dart';
import '../controllers/bottom_controller.dart';


class BottomnavScreen extends StatelessWidget {
  BottomnavScreen({super.key});

  final controller = Get.put(BottomController());
  final firebaseController = Get.put(FirebaseController());

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        body: controller.screens[controller.selectedIndex.value],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 12,
              )
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: controller.selectedIndex.value,
            onTap: controller.changeIndex,
            type: BottomNavigationBarType.fixed,
            elevation: 20,
            backgroundColor: Colors.white,
            selectedItemColor: const Color(0xFF0056D2),
            unselectedItemColor: const Color(0xFFC4CACE),
            selectedLabelStyle: GoogleFonts.nunito(
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            unselectedLabelStyle: GoogleFonts.nunito(
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
            items: List.generate(
              controller.icons.length,
                  (index) {
                Widget iconWidget = Image.asset(
                  controller.icons[index],
                  width: 24,
                  height: 24,
                  color: controller.selectedIndex.value == index
                      ? const Color(0xFF0056D2)
                      : const Color(0xFFC4CACE),
                );
                if (index == 1) {
                  iconWidget = Badge(
                    label: Text(firebaseController.cartBadgeCount.value.toString(),
                      style: GoogleFonts.nunito(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    isLabelVisible: firebaseController.cartBadgeCount.value > 0,
                    backgroundColor: Colors.red,
                    child: iconWidget,
                  );
                }

                return BottomNavigationBarItem(
                  icon: iconWidget,
                  label: "",
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}