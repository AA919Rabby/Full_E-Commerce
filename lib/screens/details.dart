// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:social_media/controller/details_controller.dart';
// import 'package:get/get.dart';
//
//
//
// class Details extends StatelessWidget {
//   Details({super.key});
//  DetailsController controller=Get.put(DetailsController());
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Column(
//         children: [
//           Container(
//             height: 370,
//             width: double.infinity,
//            decoration: BoxDecoration(
//              color: Colors.white,
//            ),
//             child: Padding(
//               padding: const EdgeInsets.only(top: 5,left: 15,right: 15),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Icon(Icons.arrow_back,color: Colors.black,size: 30,),
//                   const SizedBox(height: 10,),
//                   Text('Running E34',style: GoogleFonts.poppins(
//                     fontWeight: FontWeight.w500,
//                     color: Colors.black,
//                     fontSize: 17,
//                   ),),
//                   const SizedBox(height: 10,),
//                   Center(child: Image.asset('assets/images/run.png',fit: BoxFit.cover,height: 250,width: 250,)),
//                   const Divider(),
//                 ],
//               ),
//             ),
//           ),
//           Expanded(
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//               ),
//               child: SingleChildScrollView (
//                 child: Align(
//                   alignment: Alignment.topLeft,
//                   child: Padding(
//                     padding: const EdgeInsets.only(left: 15,right: 15),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                        Row(
//                          children: [
//                            Text('Color',style: GoogleFonts.poppins(
//                              fontWeight: FontWeight.w400,
//                              color: Colors.black,
//                              fontSize: 17,
//                            ),),
//                            const SizedBox(width: 17,),
//                            colorCircle(Colors.red,0),
//                            const SizedBox(width: 5,),
//                            colorCircle(Colors.blue,1),
//                            const SizedBox(width: 5,),
//                            colorCircle(Colors.grey,2),
//                          ],
//                        ),
//                         const SizedBox(height: 7,),
//                         Row(
//                           children: [
//                             const SizedBox(width: 5,),
//                             Text('Size',style: GoogleFonts.poppins(
//                               fontWeight: FontWeight.w400,
//                               color: Colors.black,
//                               fontSize: 17,
//                             ),),
//                             const SizedBox(width: 10,),
//                             sizeCircle('7',0),
//                             const SizedBox(width: 5,),
//                             sizeCircle('8',1),
//                             const SizedBox(width: 5,),
//                             sizeCircle('9',2),
//                           ],
//                         ),
//                         const SizedBox(height: 17,),
//                         Text('Running E34 is for men.This is perfect for morning walkRunning E34 is for men.This is perfect for morning walk,Running E34 is for men.This is perfect for morning walkRunning E34 is for men.This is perfect for morning walkRunning E34 is for men.This is perfect for morning walkRunning E34 is for men.This is perfect for morning walkvvvRunning E34 is for men.This is perfect for morning walkRunning E34 is for men.This is perfect for morning walk',style: GoogleFonts.poppins(
//                           fontWeight: FontWeight.w400,
//                           color: Colors.black,
//                           fontSize: 14,
//                         ),),
//                         const SizedBox(height: 5,),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         Padding(
//           padding: const EdgeInsets.only(left: 20,right: 20,bottom: 10),
//           child: SizedBox(
//             height: 52,
//             child: TextButton(
//                 style: TextButton.styleFrom(
//                   backgroundColor: Colors.blue,
//                 ),
//                 onPressed:(){}, child:
//             Padding(
//               padding: const EdgeInsets.only(left: 80,right: 80),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text('\$120',style: GoogleFonts.poppins(
//                     fontWeight: FontWeight.w400,
//                     color: Colors.white,
//                     fontSize: 20,
//                   ),),
//                   Text('Add to cart',style: GoogleFonts.poppins(
//                     fontWeight: FontWeight.w400,
//                     color: Colors.white,
//                     fontSize: 20,
//                   ),),
//                 ],
//               ),
//             )),
//           ),
//         ),
//           const SizedBox(height: 17,),
//         ],
//       ),
//     );
//   }
//
//
//
//   //color helper widget
//   colorCircle(Color color,int index){
//  return GestureDetector(
//    onTap: (){
//      controller.changeColor(index);
//    },
//    child: Obx((){
//      bool isSelected=controller.isSelected.value==index;
//      return Container(
//        height: 20,
//        width: 20,
//        decoration: BoxDecoration(
//          color: color,
//          borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: isSelected?Colors.black:color,
//         width: 2,
//         )
//        ),
//      );
//    }),
//  );
// }
//
//   //size helper widget
//   sizeCircle(String sizeText,int index){
//     return GestureDetector(
//       onTap: (){
//         controller.changeSize(index);
//       },
//       child: Obx((){
//         bool isSelected=controller.isSizeSelected.value==index;
//         return Container(
//           height: 22,
//           width: 30,
//           decoration: BoxDecoration(
//             color: Colors.grey,
//             borderRadius: BorderRadius.circular(6),
//             border: Border.all(color: isSelected?Colors.black:Colors.grey,
//                 width: 2,
//             ),
//           ),
//           child: Center(
//             child: Text(sizeText,style: GoogleFonts.poppins(
//               fontWeight: isSelected?FontWeight.w500:FontWeight.w400,
//               color: Colors.black,
//               fontSize: 14,
//             )),
//           ),
//         );
//       }),
//     );
//   }
//
//
// }
