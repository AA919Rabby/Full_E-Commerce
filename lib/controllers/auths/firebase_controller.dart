import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:social_media/models/product_model.dart';
import '../selection_controller.dart';
import 'auth_controller.dart';
import 'package:flutter/material.dart';



class FirebaseController extends GetxController {
  SelectionController selectionController = Get.put(SelectionController());
  AuthController authController = Get.put(AuthController());
  //var cartList=[].obs;
  var isLoading = false.obs;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

 //from cart order
  final cartKey=GlobalKey<FormState>();
  TextEditingController cartCity=TextEditingController();
  TextEditingController cartRoad=TextEditingController();
  TextEditingController CartNum=TextEditingController();
  TextEditingController cartTransition=TextEditingController();

  //from checkout order
  final checkKey=GlobalKey<FormState>();
  TextEditingController checkCity=TextEditingController();
  TextEditingController checkRoad=TextEditingController();
  TextEditingController CheckNum=TextEditingController();
  TextEditingController checkTransition=TextEditingController();




  addCart(Products product) async {
    try {
      isLoading.value = true;


      String? uid = FirebaseAuth.instance.currentUser?.uid;

      if (uid == null) {
        Get.snackbar("Error", "You must be logged in to add items.");
        return;
      }


      await firestore
          .collection('carts')
          .doc(uid)
          .collection('items')
          .add({
        'productId': product.id,
        'title': product.title,
        'price': product.price,
        'thumbnail': product.thumbnail,
        'quantity': 1,
        'addedAt': Timestamp.now(),
        'stock':product.stock,
        'category':product.category,
      });

      Get.snackbar("Success", "${product.title} added to cart!");
    } catch (e) {
      Get.snackbar("Error", e.toString());
      print("Firestore Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  removeFromCart(String docId) async {
    try {
      String? uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        await firestore
            .collection('carts')
            .doc(uid)
            .collection('items')
            .doc(docId)
            .delete();

        Get.snackbar("Removed", "Item removed from cart",);
      }
    } catch (e) {
      Get.snackbar("Error", "Could not remove item");
    }
  }




  addFav(Products product)async {
    try {
      isLoading.value=true;
      String? uid=FirebaseAuth.instance.currentUser?.uid;
      if(uid==null){
        Get.snackbar("Error", "You must be logged in to add items.");
        return;
      }
      await firestore.collection('favourites').doc(uid).collection('favItems').add({
        'productId': product.id,
        'title': product.title,
        'price': product.price,
        'thumbnail': product.thumbnail,
        'quantity': 1,
        'addedAt': Timestamp.now(),
        'stock':product.stock,
        'category':product.category,
      });
    } catch (e) {
      Get.snackbar("Error", e.toString());
      print("Firestore Error: $e");
    }finally{
      isLoading.value=false;
    }
  }



  removeFromFav(String docId) async {
    try {
      String? uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        await firestore
            .collection('favourites')
            .doc(uid)
            .collection('favItems')
            .doc(docId)
            .delete();

        Get.snackbar("Removed", "Item removed from cart",);
      }
    } catch (e) {
      Get.snackbar("Error", "Could not remove item");
    }
  }


  cartPaymentDetails(Products products, int quantity) async {
    try {
      String? email = FirebaseAuth.instance.currentUser?.email;
      String currentPayment = selectionController.paymentMethod.value == 'cod'
          ? 'Cash on Delivery'
          : 'Prepaid (${selectionController.selectedProvider.value})';

      await FirebaseFirestore.instance.collection('orders').add({
        'userId': FirebaseAuth.instance.currentUser?.uid,
        'email': email ?? 'No Email',
        'title': products.title,
        'price': products.price,
        'totalPrice': (products.price! * quantity).toStringAsFixed(2),
        'thumbnail': products.thumbnail,
        'quantity': quantity,
        'status': 'pending',
        'payment': currentPayment,
        'city': cartCity.text,
        'road': cartRoad.text,
        'phone': CartNum.text,
        'transactionId': cartTransition.text,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }



  allPayment() async {
    try {
      String? email = FirebaseAuth.instance.currentUser?.email;
      var cartItems = await FirebaseFirestore.instance
          .collection('carts')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('items')
          .get();

      String currentPayment = selectionController.paymentMethod.value == 'cod'
          ? 'Cash on Delivery'
          : 'Prepaid (${selectionController.selectedProvider.value})';

      for (var doc in cartItems.docs) {
        await FirebaseFirestore.instance.collection('orders').add({
          'userId': FirebaseAuth.instance.currentUser?.uid,
          'email': email ?? 'No Email',
          'title': doc['title'],
          'price': doc['price'],
          'totalPrice': (doc['price'] ?? 0).toStringAsFixed(2),
          'thumbnail': doc['thumbnail'],
          'quantity': doc['quantity'] ?? 1,
          'status': 'pending',
          'payment': currentPayment,
          'city': checkCity.text,
          'road': checkRoad.text,
          'phone': CheckNum.text,
          'transactionId': checkTransition.text,
          'createdAt': FieldValue.serverTimestamp(),
        });
        await doc.reference.delete();
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }


}