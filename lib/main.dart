import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:social_media/controllers/auths/auth_controller.dart';
import 'package:social_media/screens/auths/emailverify.dart';
import 'package:social_media/screens/auths/forget_password.dart';
import 'package:social_media/screens/auths/login.dart';
import 'package:social_media/screens/auths/passwordreset.dart';
import 'package:social_media/screens/auths/register.dart';
import 'package:social_media/screens/auths/verifysuccess.dart';
import 'package:social_media/screens/bottomnav_screen.dart';
import 'package:social_media/screens/details.dart';
import 'package:social_media/screens/home_screen.dart';
import 'package:get/get.dart';
import 'package:social_media/screens/new_ad.dart';
import 'package:social_media/screens/onboarding_screen.dart';
import 'package:social_media/screens/product_details.dart';
import 'package:social_media/screens/profile_ad.dart';
import 'package:social_media/screens/profile_change.dart';
import 'package:social_media/screens/profile_screen.dart';
import 'package:social_media/screens/profile_zoom.dart';
import 'controllers/auths/firebase_controller.dart';
import 'firebase_options.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(AuthController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return BottomnavScreen();
        }
        return  OnboardingScreen();
      },
    );
  }
}
