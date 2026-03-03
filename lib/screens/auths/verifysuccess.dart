import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_media/controllers/auths/auth_controller.dart';
import 'package:social_media/screens/auths/login.dart';

import '../../widgets/custom_button.dart';


class Verifysuccess extends StatefulWidget {
  const Verifysuccess({super.key});

  @override
  State<Verifysuccess> createState() => _VerifysuccessState();
}
AuthController authController=Get.put(AuthController());
class _VerifysuccessState extends State<Verifysuccess> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 150,),
              const SizedBox(height: 30,),
              Text('Your account successfully \ncreated',
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.black,
              ),),
              const SizedBox(height:7,),
           Obx(()=>Text(authController.displayUserEmail.value,style: GoogleFonts.nunito(
             fontWeight: FontWeight.w400,
             fontSize: 14,
             color: Colors.black.withOpacity(.9),
           ),),),
              const SizedBox(height:7,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  'Congratulations! Your account has been\n successfully created. You can now explore all the \namazing features, start personalizing your \nexperience, and enjoy seamless access to our\n services. Let’s get started!',
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
                  Get.offAll(()=>Login());
                },
                color: Colors.blue, label: 'Done',labelColor: Colors.white,),
              const SizedBox(height: 15,),
            ],
          ),
        ),
      ),
    );
  }
}
