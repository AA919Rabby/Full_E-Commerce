import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:social_media/screens/auths/register.dart';
import 'package:social_media/screens/auths/verifysuccess.dart';

import '../../controllers/auths/auth_controller.dart';
import '../../widgets/custom_button.dart';
import 'login.dart';


class Emailverify extends StatefulWidget {
  const Emailverify({super.key});

  @override
  State<Emailverify> createState() => _EmailverifyState();
}
AuthController authController=Get.put(AuthController());
class _EmailverifyState extends State<Emailverify> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.grey.shade300,
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){
            Get.to(()=>Login());
          }, icon: Padding(
            padding: const EdgeInsets.only(right: 20,top: 17),
            child: Icon (Icons.close),
          ),color: Colors.grey.shade300,),
        ],
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(child: Image.asset('assets/images/very.png')),
            const SizedBox(height: 30,),
            Text('Verify your email address!',style: GoogleFonts.nunito(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.black,
            ),),
            const SizedBox(height:7,),
            Text(authController.auth.currentUser?.email ?? 'unknownpro@gmail.com',style: GoogleFonts.nunito(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: Colors.black.withOpacity(.9),
            ),),
            const SizedBox(height:7,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'We’ve sent a verification link to your email. \nPlease check your inbox and click the link to\n verify your account',
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Colors.grey,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 40,),
            CustomButton(
              onTap: (){
                authController.checkEmailVerified();
              },
              color: Colors.blue, label: 'Done',labelColor: Colors.white,),
            const SizedBox(height: 15,),
            InkWell(
              onTap: (){
                Get.to(() =>Register());
              },
              child: Text(
                'Resend Email',
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
