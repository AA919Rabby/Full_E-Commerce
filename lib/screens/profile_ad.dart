// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:get/get.dart';
// import 'package:social_media/screens/new_ad.dart';
//
//
// class ProfileAd extends StatefulWidget {
//   const ProfileAd({super.key});
//
//   @override
//   State<ProfileAd> createState() => _ProfileAdState();
// }
//
// class _ProfileAdState extends State<ProfileAd> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.white,
//         scrolledUnderElevation: 0,
//         leading: InkWell(
//             onTap: (){
//               Get.back();
//             },
//             child: Icon (Icons.arrow_back,color: Colors.black,size: 25,)),
//         title: Text('Addresses',style: GoogleFonts.nunito(
//           fontWeight: FontWeight.bold,
//           fontSize: 20,
//           color: Colors.black,
//         ),),
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.blue,
//           child: Icon(Icons.add,color: Colors.white,),
//           onPressed: (){
//           Get.to(()=>NewAd());
//           }),
//     floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
//     );
//   }
// }
