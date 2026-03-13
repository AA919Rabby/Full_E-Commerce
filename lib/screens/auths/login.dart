import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_media/controllers/auths/auth_controller.dart';
import 'package:social_media/screens/auths/register.dart';
import 'package:social_media/screens/bottomnav_screen.dart';
import 'package:social_media/screens/home_screen.dart';
import 'package:social_media/widgets/custom_auth.dart';
import 'package:get/get.dart';
import 'package:social_media/widgets/custom_button.dart';
import '../../controllers/login_controller.dart';
import 'forget_password.dart';


class Login extends StatefulWidget {
   const Login({super.key});
  @override
  State<Login> createState() => _LoginState();
}
bool isPasswordVisible = false;
AuthController authController=Get.put(AuthController());
LoginController controller=Get.put(LoginController());
class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 15,right: 15),
          child: SingleChildScrollView (
            child: Form(
              key: authController.formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 120,),
                  Text('Shop Smarter',style: GoogleFonts.nunito(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),),
                  const SizedBox(height: 6,),
                  Text('Log in to Access Exclusive Deals and Simplify Your Shopping Experience',style: GoogleFonts.nunito(
                    fontSize: 14,
                    color: Colors.grey,
                  ),),
                  const SizedBox(height: 23),
                  CustomAuth(
                    controller: authController.emailController,
                    validator: (value){
                      if(value!.isEmpty){
                        return 'Please enter your email';
                      }
                      return null;
                    },
                    labelText: 'Email', hintText:'Email',
                    prefixIcon:Image.asset('assets/images/email.png',height: 20,width: 20,),),
                  const SizedBox(height: 17),
                  Obx(() => CustomAuth(
                    controller: authController.passwordController,
                    validator: (value){
                      if(value!.isEmpty){
                        return 'Please enter your password';
                      }
                      return null;
                    },
                    labelText: 'Password',
                    hintText: 'Password',
                    obscureText: !controller.isPasswordVisible.value,
                    prefixIcon: Image.asset('assets/images/password.png',height: 20,width: 20,),
                    suffixIcon: Icon(
                        controller.isPasswordVisible.value
                            ? Icons.visibility
                            : Icons.visibility_off
                    ),
                    onSuffixTap: () {
                      controller.toggleVisibility();
                    },
                  )),
                  const SizedBox(height: 10),
                 //remember me section
                 Row(
                   children: [
                     Obx(()=>Checkbox(
                         checkColor: Colors.white,
                         activeColor: Colors.blue,
                         value: controller.isRemember.value,
                         onChanged: (bool? value){
                           controller.onChanged(value);
                         }),),
                     const SizedBox(width: 5,),
                     Text('Remember Me',style: GoogleFonts.nunito(
                       fontSize: 12,
                       color: Colors.black,
                       fontWeight: FontWeight.w400,
                     ),),
                     const Spacer(),
                     Padding(
                       padding: const EdgeInsets.only(right: 14),
                       child: InkWell(
                         onTap: (){
                           Get.to(()=>ForgetPassword(),);
                         },
                         child: Text('Forgot Password?',style: GoogleFonts.nunito(
                           fontSize: 10,
                           color: Colors.blue,
                           fontWeight: FontWeight.w400,
                         ),),
                       ),
                     ),
                   ],
                 ),
                  const SizedBox(height: 12),
                 Obx(()=> authController.isLoading.value?Center(child:CircularProgressIndicator(),):
                 Center(child: CustomButton(
                   onTap: ()async{
                     if(authController.formKey.currentState!.validate()){
                       bool success = await authController.login();
                       if (success) {
                         Get.offAll(() => BottomnavScreen());
                       }
                     }
                   },
                   color: Colors.blue, label: 'Sign In',labelColor: Colors.white,)),),
                  const SizedBox(height: 12),
                 //create account section
                 Center (
                   child: InkWell(
                     onTap: (){
                       Get.to(()=>Register(),);
                     },
                     child: Container(
                       height: 46,
                         width: 318,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                             border: Border.all(color: Colors.black),
                          ),
                       child: Center(
                         child: Text('Create Account',style: GoogleFonts.nunito(
                           color: Colors.black,
                           fontSize: 16,
                           fontWeight: FontWeight.w700,
                         ),),
                       ),
                     ),
                   ),
                 ),
                  const SizedBox(height: 18),
                  Padding(
                    padding: const EdgeInsets.only(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Divider(color: Colors.grey,),
                        Text('Or Sign In With',style: GoogleFonts.nunito(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.w400,
                        ),),
                        const Divider(color: Colors.grey),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                            onTap: () async {

                              bool success = await authController.signInWithGoogle();
                              if (success) {
                                Get.offAll(() => BottomnavScreen());
                              }
                            },
                            child: Container (
                              height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.grey),
                                  shape: BoxShape.circle,
                                ),
                                child: Image.asset('assets/images/google.png')),
                          ),
                      const SizedBox(width: 10,),
                      InkWell(
                          onTap: (){},
                          child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.grey),
                                shape: BoxShape.circle,
                              ),
                              child: Image.asset('assets/images/face.png',))),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
