import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
        backgroundColor: Colors.grey,
        body: controller.screens[controller.selectedIndex.value],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.selectedIndex.value,
          onTap: controller.changeIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.black,
          items: List.generate(
            controller.icons.length,
                (index) {
              Widget iconWidget = Image.asset(
                controller.icons[index],
                width: 24,
                height: 24,
                color: controller.selectedIndex.value == index
                    ? Colors.blue
                    : Colors.grey,
              );
              if (index == 1) {
                iconWidget = Badge(
                  label: Text(firebaseController.cartBadgeCount.value.toString()),
                  isLabelVisible: firebaseController.cartBadgeCount.value > 0,
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
    );
  }
}