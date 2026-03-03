import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:social_media/screens/bottomnav_screen.dart';
import 'package:social_media/screens/onboarding_screen.dart';
import 'dart:convert';   // For base64 encoding
import 'dart:io';        // For File handling
import '../../screens/auths/verifysuccess.dart';

class AuthController extends GetxController {
  // first name and last name

  TextEditingController changeFirstName = TextEditingController();
  TextEditingController changeLastName = TextEditingController();



  //exiesting
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController resetPasswordEmail = TextEditingController();
  TextEditingController registerEmail = TextEditingController();
  TextEditingController registerPassword = TextEditingController();

  final formKey = GlobalKey<FormState>();
  final resetKey = GlobalKey<FormState>();
  final registerKey = GlobalKey<FormState>();

  var isLoading = false.obs;
  var displayUserName = 'Unknown Pro'.obs;
  var displayUserEmail = 'unknownpro@gmail.com'.obs;
  var displayUserPhone = '688533214'.obs;
  var displayUserImage = ''.obs;


  FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }


  //getting the data from firebasde
  fetchUserData() async {
    User? currentUser = auth.currentUser;
    if (currentUser != null) {
      try {
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(currentUser.uid).get();
        if (userDoc.exists && userDoc.data() != null) {
          Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;

          displayUserName.value = data.containsKey('name') ? data['name'] : 'User';
          displayUserEmail.value = data.containsKey('email') ? data['email'] : '';

          displayUserPhone.value = data.containsKey('phone') ? data['phone'] : 'No Phone';

          // This loads image
          displayUserImage.value = data.containsKey('profilePic') ? data['profilePic'] : '';
        }
      } catch (e) {
        print("Error fetching user data: $e");
      }
    }
  }



  //Converts image to Base64 and saves to Firestore
  syncProfileImageToFirestore(String filePath) async {
    try {
      isLoading.value = true;
      String? uid = auth.currentUser?.uid;

      if (uid != null && filePath.isNotEmpty) {
        // Convert the image file to bytes then to a Base64 string
        File file = File(filePath);
        List<int> imageBytes = await file.readAsBytes();
        String base64String = base64Encode(imageBytes);

        await _firestore.collection('users').doc(uid).update({
          'profilePic': base64String,
        });

        displayUserImage.value = base64String;
      }
    } catch (e) {
      Get.snackbar("Error", "Could not sync image: $e");
    } finally {
      isLoading.value = false;
    }
  }




  //image uploading and name changing
  updateProfileName() async {
    try {
      isLoading.value = true;
      String? uid = auth.currentUser?.uid;

      if (uid != null) {
        String newFullName = "${changeFirstName.text.trim()} ${changeLastName.text.trim()}".trim();
        if (newFullName.isEmpty) return;

        await _firestore.collection('users').doc(uid).update({
          'name': newFullName,
          'updatedAt': FieldValue.serverTimestamp(),
        });


        displayUserName.value = newFullName;
      }
    } catch (e) {
      Get.snackbar("Error", "Could not update name: $e");
    } finally {
      isLoading.value = false;
    }
  }



  signInWithGoogle() async {
    try {
      isLoading.value = true;
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        isLoading.value = false;
        return false;
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await auth.signInWithCredential(credential);
      String uid = userCredential.user!.uid;


      DocumentSnapshot userDoc = await _firestore.collection('users').doc(uid).get();

      if (!userDoc.exists) {
        await auth.signOut();
        await googleSignIn.signOut();

        Get.snackbar(
            "Account Not Found",
            "Please go to the Register page and create an account first.",
        );
        return false;
      }

      String googleName = googleUser.displayName ?? "Unknown Pro";

      await _firestore.collection('users').doc(uid).set({
        'name': googleName,
        'email': googleUser.email,
        'uid': uid,
      }, SetOptions(merge: true));

      displayUserName.value = googleName;
      return true;
    } catch (e) {
      Get.snackbar("Google Sign-In Failed", e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  login() async {
    try {
      isLoading.value = true;
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (userCredential.user != null && !userCredential.user!.emailVerified) {
        await auth.signOut();
        Get.snackbar("Access Denied", "Please verify your email address.");
        return false;
      }

      await fetchUserData();
      emailController.clear();
      passwordController.clear();
      return true;
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.message ?? "Login Failed");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  resetPassword() async {
    try {
      isLoading.value = true;
      await auth.sendPasswordResetEmail(email: resetPasswordEmail.text.trim());
      resetPasswordEmail.clear();
      Get.snackbar('Success', 'Reset link sent to your email');
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message ?? "Reset Failed");
    } finally {
      isLoading.value = false;
    }
  }

  register() async {
    try {
      isLoading.value = true;

      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: registerEmail.text.trim(),
        password: registerPassword.text.trim(),
      );


      String fullName = "${firstName.text.trim()} ${lastName.text.trim()}".trim();
      if (fullName.isEmpty) fullName = "Unknown Pro";


      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': fullName,
        'email': registerEmail.text.trim(),
        'uid': userCredential.user!.uid,
        'phone': numberController.text.trim(),
        'createdAt': DateTime.now(),
      });

      displayUserName.value = fullName;


      if (userCredential.user != null) {
        await userCredential.user!.sendEmailVerification();
      }


      registerEmail.clear();
      registerPassword.clear();
      firstName.clear();
      lastName.clear();

      return true;
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message ?? "Registration Failed");
      return false;
    } catch (e) {
      Get.snackbar('Error', e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  checkEmailVerified() async {
    await auth.currentUser?.reload();
    if (auth.currentUser?.emailVerified == true) {
      await fetchUserData();
      Get.snackbar("Success", "Email Verified!");
      Get.offAll(() => const Verifysuccess());
    } else {
      Get.snackbar("Error", "Email not verified yet.");
    }
  }



    logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Get.offAll(()=>OnboardingScreen());
    } catch (e) {
      print("Logout Error: $e");
    }
  }



}