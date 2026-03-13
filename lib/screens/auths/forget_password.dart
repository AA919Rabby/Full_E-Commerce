import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:social_media/controllers/auths/auth_controller.dart';
import 'package:social_media/screens/auths/passwordreset.dart';
import 'package:social_media/widgets/custom_auth.dart';
import 'package:social_media/widgets/custom_button.dart';


class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}
AuthController authController=Get.put(AuthController());
class _ForgetPasswordState extends State<ForgetPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        backgroundColor:  Colors.grey.shade300,
        scrolledUnderElevation: 0,
        elevation: 0,
        leading: InkWell(
          onTap: (){
            Get.back();
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 23,top: 17),
            child: Icon(Icons.arrow_back,color: Colors.black,),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 23,right: 23,
        ),
        child: Form(
          key: authController.resetKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 37,),
              Text('Forget Password',style: GoogleFonts.nunito(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.black,
              ),),
              Text('No worries! Enter your registered email address,\nand we’ll help you reset your password',style: GoogleFonts.nunito(
                fontWeight: FontWeight.w400,
                fontSize: 12,
                color: Colors.grey,
              ),),
              const SizedBox(height: 37,),
              CustomAuth(
                controller: authController.resetPasswordEmail,
                validator: (value){
                  if(value!.isEmpty){
                    return 'Enter your email';
                  }if(!GetUtils.isEmail(value)){
                    return 'Enter a valid email';
                  }
                },
                labelText: 'Email', hintText: 'example@gmail.com',
              prefixIcon: Image.asset('assets/images/email.png',height: 20,width: 20,),
              ),
              const SizedBox(height: 25,),
              Center(child: CustomButton(
                onTap: (){
                 if(authController.resetKey.currentState!.validate()){
                   authController.resetPassword();
                   Get.to(()=>Passwordreset());
                 }
                },
                color: Colors.blue, label:'Submit',labelColor: Colors.white,)),
            ],
          ),
        ),
      ),
    );
  }
}
