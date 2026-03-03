import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_media/screens/auths/forget_password.dart';
import 'package:social_media/screens/auths/login.dart';
import 'package:social_media/widgets/custom_button.dart';


class Passwordreset extends StatefulWidget {
  const Passwordreset({super.key});

  @override
  State<Passwordreset> createState() => _PasswordresetState();
}

class _PasswordresetState extends State<Passwordreset> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){
            Get.to(()=>Login());
          }, icon: Padding(
            padding: const EdgeInsets.only(right: 20,top: 17),
            child: Icon (Icons.close),
          ),color: Colors.black,),
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
            Text('Password Reset Email Sent',style: GoogleFonts.nunito(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.black,
            ),),
            const SizedBox(height:7,),
            Text('unknownpro@gmail.com',style: GoogleFonts.nunito(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: Colors.black.withOpacity(.9),
            ),),
            const SizedBox(height:7,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'We’ve sent a password reset link to your email.\n Please check your inbox and follow the\n instructions to reset your password',
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
                Get.to(()=>Login());
              },
              color: Colors.blue, label: 'Done',labelColor: Colors.white,),
            const SizedBox(height: 15,),
            InkWell(
              onTap: (){
                Get.to(()=>ForgetPassword());
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
