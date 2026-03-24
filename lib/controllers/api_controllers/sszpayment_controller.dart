import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../screens/payment_web_view_screen.dart';


class SszpaymentController extends GetxController {

  var isLoading = false.obs;
  final String storeId = "YOUR_STORE_ID";
  final String storePassword = "YOUR_STORE_PASSWORD";

  void initiatePayment(double amount) async {
    isLoading.value = true;
    final String apiUrl = "https://sandbox.sslcommerz.com/gwprocess/v4/api.php";
    String tranId = "test_${DateTime.now().microsecondsSinceEpoch}";

    Map<String, dynamic> body = {
      'store_id': storeId,
      'store_passwd': storePassword,
      'total_amount': amount.toStringAsFixed(2),
      'currency': 'BDT',
      'tran_id': tranId,
      "success_url": "https://sandbox.sslcommerz.com/developer/success.html",
      "fail_url": "https://sandbox.sslcommerz.com/developer/fail.html",
      "cancel_url": "https://sandbox.sslcommerz.com/developer/cancel.html",
      'cus_name': 'rabby khan',
      'cus_email': 'rabbi@gmail.com',
      'cus_add1': 'Dhaka',
      'cus_city': 'Dhaka',
      'cus_postcode': '1212',
      'cus_country': 'Bangladesh',
      'cus_phone': '0140000000',
      'shipping_method': 'NO',
      'num_of_item': '1',
      'product_name': 't-shirt',
      'product_category': 'Clothes',
      'product_profile': 'general',
    };

    try {
      final response = await http.post(Uri.parse(apiUrl), body: body);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == 'SUCCESS' && data['GatewayPageURL'] != null) {

          navigateToWebView(data['GatewayPageURL'].toString());
        } else {
          Get.snackbar('Error', data['failedreason'] ?? 'Init failed');
        }
      }

    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }


  void navigateToWebView(String url) async {
    var result = await Get.to(
            () => const PaymentWebViewScreen(),
        arguments: url,
        //simple animation
        transition: Transition.rightToLeft
    );

    if (result == "success") {
      Get.snackbar("Status", "Payment Successful!");
    } else if (result == "failed") {
      Get.snackbar("Status", "Payment Failed");
    }
  }
}
