import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_media/controllers/auths/auth_controller.dart';
import 'package:social_media/widgets/custom_auth.dart';
import '../../controllers/login_controller.dart';
import '../../widgets/custom_button.dart';
import '../bottomnav_screen.dart';
import 'emailverify.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthController authController = Get.put(AuthController());
  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.grey.shade300,
      appBar: AppBar(
        backgroundColor:Colors.grey.shade300,
        scrolledUnderElevation: 0,
        elevation: 0,
        leading: InkWell(
          onTap: () => Get.back(),
          child: const Padding(
            padding: EdgeInsets.only(left: 23, top: 17),
            child: Icon(Icons.arrow_back, color: Colors.black),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Form(
            key: authController.registerKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 37),
                Text('Let’s Get You Registered',
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.bold,
                      fontSize: 27,
                    )),
                const SizedBox(height: 26),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        height: 65,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextFormField(
                          controller: authController.firstName,
                          style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w500),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            hintText: 'First Name',
                            prefixIcon: const Icon(Icons.person_outline, size: 20),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        height: 65,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextFormField(
                          controller: authController.lastName,
                          style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w500),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            hintText: 'Last Name',
                            prefixIcon: const Icon(Icons.person_outline, size: 20),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                CustomAuth(
                  controller: authController.registerEmail,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please enter your email';
                    if (!GetUtils.isEmail(value)) return 'Please enter a valid email';
                    return null;
                  },
                  labelText: 'Email',
                  hintText: 'Email',
                  prefixIcon: Image.asset('assets/images/email.png', height: 20, width: 20),
                ),
                const SizedBox(height: 16),
                CustomAuth(
                  controller: authController.numberController,
                  labelText: 'Phone Number',
                  hintText: 'Phone Number',
                  prefixIcon: Image.asset('assets/images/cell.png', height: 20, width: 20),
                ),
                const SizedBox(height: 16),
                CustomAuth(
                  controller: authController.registerPassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please enter your password';
                    if (value.length < 8) return 'Password must be 8+ characters';
                    return null;
                  },
                  labelText: 'Password',
                  hintText: 'Password',
                  prefixIcon: Image.asset('assets/images/password.png', height: 20, width: 20),
                ),
                const SizedBox(height: 16),

                // Terms Checkbox
                FormField<bool>(
                  initialValue: false,
                  validator: (value) {
                    if (controller.isRemember.value == false) return 'You must agree to the terms & conditions';
                    return null;
                  },
                  builder: (state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Obx(() => Checkbox(
                              activeColor: Colors.blue,
                              value: controller.isRemember.value,
                              onChanged: (val) {
                                controller.onChanged(val);
                                state.didChange(val);
                              },
                            )),
                            Text('I agree to ', style: GoogleFonts.nunito(fontSize: 12)),
                            const SizedBox(width: 3,),
                            Text('Terms', style: GoogleFonts.nunito(fontSize: 12,color: Colors.blue)),
                            const SizedBox(width: 3,),
                            Text('&', style: GoogleFonts.nunito(fontSize: 12)),
                            const SizedBox(width: 3,),
                            Text('Privacy', style: GoogleFonts.nunito(fontSize: 12,color: Colors.blue)),
                          ],
                        ),
                        if (state.hasError)
                          Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: Text(state.errorText!, style: const TextStyle(color: Colors.red, fontSize: 12)),
                          ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 20),

                // Submit Button
                Obx(() => authController.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : Center(
                  child: CustomButton(
                    onTap: () async {
                      if (authController.registerKey.currentState!.validate()) {
                        bool success = await authController.register();
                        if (success) {
                          Get.offAll(() => const Emailverify());
                        }
                      }
                    },
                    color: Colors.blue,
                    label: 'Register Now',
                    labelColor: Colors.white,
                  ),
                )),

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
    );
  }
}