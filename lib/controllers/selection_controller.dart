import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';


class SelectionController extends GetxController{

  var total=1.obs;
  var paymentMethod = 'cod'.obs;
  var transactionId = ''.obs;
  var selectedProvider = 'paypal'.obs;


  //
  increment(){
    total.value++;
  }
  //
  decrement(){
    if(total.value>1){
      total.value--;
    }
  }

  changePayment(String value) {
    paymentMethod.value = value;
    if (value == 'prepaid') {
      transactionId.value = DateTime.now().millisecondsSinceEpoch.toString();
    } else {
      transactionId.value = '';
    }
  }
  //
  selectProvider(String provider) {
    selectedProvider.value = provider;
  }



}