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
      backgroundColor: Colors.grey.shade300,
      body: Column(
        children: [
          Container(
            height:220,
            width: double.infinity,
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                  spreadRadius: 3,
                )
              ],
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [

                Positioned(
                  top: -60,
                  right: -60,
                  child: Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.15),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  right: -120,
                  child: Container(
                    height: 300,
                    width: 300,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.1),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),

                Positioned(
                  top: 17,
                  left: 25,
                  right: 25,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Obx(()=>  Text(authController.displayUserName.value,
                             overflow: TextOverflow.ellipsis,
                             style: GoogleFonts.nunito(
                               color: Colors.white,
                               fontSize: 16,
                               fontWeight: FontWeight.bold,
                             )),),
                         Obx(() {
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
                             width: 70,
                             height: 80,
                             decoration: BoxDecoration(
                               color: Colors.white,
                               shape: BoxShape.circle,
                               border: Border.all(color: Colors.blue, width: 4),
                               image:
                               DecorationImage(image: provider, fit: BoxFit.cover),
                             ),
                           );
                         }),
                       ],
                     ),
                      Text('Popular Categories',
                          style: GoogleFonts.nunito(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          )),
                      const SizedBox(height: 10),
                      Obx(() {

                        if (productController.isLoading.value) {
                          return const SizedBox(
                            height: 47,
                            child: Center(
                              child: SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            ),
                          );
                        }

                        return SizedBox(
                          height: 47,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: productController.allCategory.length,
                              itemBuilder: (context, index) {
                                var category = productController.allCategory[index];
                               return Obx((){
                                  bool isSelected=productController.selectedCategory.value==category;
                                 return GestureDetector(
                                   onTap: (){
                                     productController.filterByCategory(category);
                                   },
                                   child:Container(
                                     margin: const EdgeInsets.only(right: 7),
                                     padding: const EdgeInsets.symmetric(horizontal: 10),
                                     decoration: BoxDecoration(
                                         color: isSelected?Colors.blue[900]:Colors.white,
                                         borderRadius: BorderRadius.circular(20),
                                         border: Border.all(color:isSelected?Colors.black:Colors.grey)),
                                     child: Center(
                                       child: Text(
                                         category,
                                         style: GoogleFonts.nunito(
                                           color:isSelected?Colors.white:Colors.black,
                                           fontSize: 14,
                                           fontWeight: FontWeight.w400,
                                         ),
                                       ),
                                     ),
                                   ),
                                 );
                               });
                              }),
                        );
                      }),
                    ],
                  ),
                ),

                Positioned(
                  bottom: -30,
                  left: 25,
                  right: 25,
                  child: Card(
                    color: Colors.white,
                    elevation: 3,
                    shadowColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                        onChanged: (value){
                         mysearchController.searchByFilter(value);
                        },
                        style: GoogleFonts.nunito(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(top: 9),
                          hintText: 'Search...',
                          prefixIcon: const Icon(CupertinoIcons.search, color: Colors.black),
                          hintStyle: GoogleFonts.nunito(
                            color: Colors.grey,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),
          CarouselSlider.builder(
            itemCount: controller.onboarding.length,
            carouselController: controller.carouseloController,
            itemBuilder: (context, index, realIndex) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 7),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(image: NetworkImage(
                    controller.onboarding[index],
                  ),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
            options: CarouselOptions(
              autoPlay: true,
               height: 130,

              viewportFraction: 0.7,
              onPageChanged: (index, reason) {
                controller.selectedPage.value = index;
              },
            ),
          ),
          const SizedBox(height: 17,),
          //dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              controller.onboarding.length,
                  (index) => Obx(
                    () => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: controller.selectedPage.value == index ? 37 : 16,
                  height: 6,
                  decoration: BoxDecoration(
                    color: controller.selectedPage.value == index
                        ? Colors.blue
                        : Colors.grey,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ),
         // const SizedBox(height: 7,),
          Expanded(child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Obx ((){

              if(productController.isLoading.value)
                return const Center(child: CircularProgressIndicator());

                if(productController.allProducts.isEmpty){
                 return Center(child:Text('No product found!',style: GoogleFonts.nunito(
                   fontWeight: FontWeight.w500,
                 ),));
               }

              return  GridView.builder(
                  itemCount: productController.allProducts.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.55,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10
                  ), itemBuilder: (context,index){
                var product=productController.allProducts[index];
                return Card(
                  color: Colors.white.withOpacity(.9),
                  child: Column(
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: GestureDetector(
                            onTap: (){
                              Get.to(()=>ProductDetails(),arguments:product);
                            },
                            child: Image.network(product.thumbnail??'!',height: 150,width: double.infinity,
                              fit: BoxFit.contain,),
                          )),
                      const SizedBox(height: 5,),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(product.title??'',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: GoogleFonts.nunito(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontSize: 17,
                            ),),
                        ),
                      ),
                      const SizedBox(height: 3,),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Row(
                          children: [
                            Text('\$',
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.nunito(
                                fontWeight: FontWeight.w500,
                                color: Colors.green,
                                fontSize: 17,
                              ),
                            ),
                            const SizedBox(width: 6,),
                            Text(product.price?.toString()??'!',
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.nunito(
                                fontWeight: FontWeight.w500,
                                color: Colors.blue,
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5,),
                      Center(
                        child: Text(product.category??"!",
                          style: GoogleFonts.nunito(
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6,),
                      //const SizedBox(height: 17,),
                      InkWell(
                        onTap: () {
                          firebaseController.addCart(product);
                        },
                        child: Container(
                          height: 46,
                          width: 160,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black),
                          ),
                          child: Center(
                            child: Text(
                              'Add to cart',
                              style: GoogleFonts.nunito(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              });


            })
          )),
        ],
      ),
    );
  }
}