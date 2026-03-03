import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media/screens/cart_screen.dart';
import 'package:social_media/screens/favourite_screen.dart';
import 'package:social_media/screens/home_screen.dart';
import 'package:social_media/screens/profile_screen.dart';

class BottomController extends GetxController {

  var selectedIndex = 0.obs;

  List<Widget> screens = [
    HomeScreen(),
    CartScreen(),
    FavouriteScreen(),
    ProfileScreen(),
  ];

  //image list
  final List<String> icons = [
    'assets/images/menu.png',
    'assets/images/cart.png',
    'assets/images/fav.png',
    'assets/images/person.png',
  ];

   changeIndex(int index) {
    selectedIndex.value = index;
  }
}