import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/bottom_controller.dart';


class BottomnavScreen extends StatelessWidget {
  BottomnavScreen({super.key});

  final controller = Get.put(BottomController());

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Scaffold(
        backgroundColor: Colors.white,
        body: controller.screens[controller.selectedIndex.value],

        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.selectedIndex.value,
          onTap: controller.changeIndex,
          type: BottomNavigationBarType.fixed,

          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.black,

          items: List.generate(
            controller.icons.length,
                (index) => BottomNavigationBarItem(
              icon: Image.asset(
                controller.icons[index],
                width: 24,
                height: 24,
                color: controller.selectedIndex.value == index
                    ? Colors.black
                    : Colors.grey,
              ),
              label: "",
            ),
          ),
        ),
      ),
    );
  }
}