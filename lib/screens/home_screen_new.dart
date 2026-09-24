import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_media/controllers/api_controllers/product_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:social_media/controllers/auths/auth_controller.dart';
import 'package:social_media/controllers/nysearch_controller.dart';
import 'package:social_media/screens/auths/emailverify.dart';
import 'package:social_media/screens/product_details.dart';
import '../controllers/auths/firebase_controller.dart';
import '../controllers/auths/pick_controller.dart';
import '../controllers/carouselo_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseController firebaseController = Get.put(FirebaseController());
  ProductController productController = Get.put(ProductController());
  CarouseloController controller = Get.put(CarouseloController());
  MysearchController mysearchController=Get.put(MysearchController());
  AuthController authController=Get.put(AuthController());
  final pickController=Get.put(PickController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            pinned: true,
            expandedHeight: 320,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF0056D2),
                      const Color(0xFF0070E8),
                    ],
                  ),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      top: -80,
                      right: -80,
                      child: Container(
                        height: 250,
                        width: 250,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.08),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 60,
                      right: -100,
                      child: Container(
                        height: 300,
                        width: 300,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.06),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 20,
                      left: 20,
                      right: 20,
                      child: SafeArea(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Welcome back!',
                                      style: GoogleFonts.nunito(
                                        color: Colors.white70,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Obx(
                                      () => Text(
                                        authController.displayUserName.value,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.nunito(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Obx(() {
                                  ImageProvider provider;
                                  if (pickController.selectedImagePath.value
                                      .isNotEmpty) {
                                    provider = FileImage(File(
                                        pickController
                                            .selectedImagePath.value));
                                  } else if (authController
                                      .displayUserImage.value.isNotEmpty) {
                                    provider = MemoryImage(base64Decode(
                                        authController
                                            .displayUserImage.value));
                                  } else {
                                    provider = const AssetImage(
                                        'assets/images/ani.png');
                                  }

                                  return Container(
                                    width: 55,
                                    height: 55,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.white, width: 2),
                                      image: DecorationImage(
                                          image: provider,
                                          fit: BoxFit.cover),
                                    ),
                                  );
                                }),
                              ],
                            ),
                            const SizedBox(height: 18),
                            Text(
                              'Popular Categories',
                              style: GoogleFonts.nunito(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Obx(() {
                              if (productController.isLoading.value) {
                                return const SizedBox(
                                  height: 50,
                                  child: Center(
                                    child: SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                    ),
                                  ),
                                );
                              }

                              return SizedBox(
                                height: 45,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: productController
                                      .allCategory.length,
                                  itemBuilder: (context, index) {
                                    var category = productController
                                        .allCategory[index];
                                    return Obx(() {
                                      bool isSelected = productController
                                              .selectedCategory.value ==
                                          category;
                                      return GestureDetector(
                                        onTap: () {
                                          productController
                                              .filterByCategory(category);
                                        },
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(right: 10),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 8),
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? Colors.white
                                                : Colors.white
                                                    .withOpacity(0.2),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border: Border.all(
                                              color: isSelected
                                                  ? Colors.transparent
                                                  : Colors.white
                                                      .withOpacity(0.3),
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              category,
                                              style: GoogleFonts.nunito(
                                                color: isSelected
                                                    ? const Color(0xFF0056D2)
                                                    : Colors.white,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                                  },
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(65),
              child: Padding(
                padding:
                    const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 15,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: TextField(
                    onChanged: (value) {
                      mysearchController.searchByFilter(value);
                    },
                    style: GoogleFonts.nunito(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 14),
                      hintText: 'Search products...',
                      prefixIcon: const Icon(CupertinoIcons.search,
                          color: Color(0xFF818191), size: 20),
                      hintStyle: GoogleFonts.nunito(
                        color: const Color(0xFF818191),
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Featured Deals',
                    style: GoogleFonts.nunito(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 160,
                    child: CarouselSlider.builder(
                      itemCount: controller.onboarding.length,
                      carouselController: controller.carouseloController,
                      itemBuilder: (context, index, realIndex) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            image: DecorationImage(
                              image: NetworkImage(
                                controller.onboarding[index],
                              ),
                              fit: BoxFit.cover,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              )
                            ],
                          ),
                        );
                      },
                      options: CarouselOptions(
                        autoPlay: true,
                        height: 160,
                        viewportFraction: 0.85,
                        onPageChanged: (index, reason) {
                          controller.selectedPage.value = index;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      controller.onboarding.length,
                      (index) => Obx(
                        () => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          margin:
                              const EdgeInsets.symmetric(horizontal: 5),
                          width: controller.selectedPage.value == index
                              ? 32
                              : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: controller.selectedPage.value == index
                                ? const Color(0xFF0056D2)
                                : const Color(0xFFE0E4E8),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    'All Products',
                    style: GoogleFonts.nunito(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
          Obx(
            () {
              if (productController.isLoading.value) {
                return SliverFillRemaining(
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (productController.allProducts.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Text(
                      'No products found',
                      style: GoogleFonts.nunito(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: const Color(0xFF818191),
                      ),
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                sliver: SliverGrid(
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.56,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      var product = productController.allProducts[index];
                      return ProductCard(
                        product: product,
                        firebaseController: firebaseController,
                      );
                    },
                    childCount: productController.allProducts.length,
                  ),
                ),
              );
            },
          ),
          const SliverPadding(
            padding: EdgeInsets.only(bottom: 20),
            sliver: SliverToBoxAdapter(
              child: SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final dynamic product;
  final FirebaseController firebaseController;

  const ProductCard({
    required this.product,
    required this.firebaseController,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => ProductDetails(), arguments: product),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: Container(
                height: 150,
                width: double.infinity,
                color: const Color(0xFFF5F7FA),
                child: Image.network(
                  product.thumbnail ?? '',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Center(
                    child: Icon(Icons.image_not_supported,
                        color: Colors.grey.shade400),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title ?? '',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: GoogleFonts.nunito(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0056D2).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        product.category ?? '',
                        style: GoogleFonts.nunito(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF0056D2),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${product.price}',
                          style: GoogleFonts.nunito(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1CB127),
                            fontSize: 16,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => firebaseController.addCart(product),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF0056D2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.all(8),
                            child: const Icon(Icons.add,
                                color: Colors.white, size: 18),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

