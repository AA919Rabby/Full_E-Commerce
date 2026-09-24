import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/api_controllers/sszpayment_controller.dart';
import '../controllers/auths/firebase_controller.dart';
import '../controllers/selection_controller.dart';
import '../widgets/custom.dart';
import '../widgets/custom_auth.dart';
import '../widgets/custom_button.dart';

class CartScreen extends StatelessWidget {
  CartScreen({super.key});

  final SelectionController selectionController = Get.put(SelectionController());
  final FirebaseController firebaseController = Get.put(FirebaseController());
  final SszpaymentController sszpaymentController = Get.put(SszpaymentController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Shopping Cart',
          style: GoogleFonts.nunito(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('carts')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .collection('items')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          double totalPrice = 0;
          if (snapshot.hasData) {
            for (var doc in snapshot.data!.docs) {
              totalPrice += (doc['price'] ?? 0).toDouble();
            }
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'Cart is empty!',
                style: GoogleFonts.nunito(
                  fontSize: 23,
                  color: Colors.black,
                ),
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final doc = snapshot.data!.docs[index];
                    final data = doc.data() as Map<String, dynamic>;
                    final docId = doc.id;

                    return Dismissible(
                      key: Key(docId),
                      direction: DismissDirection.endToStart,
                      background: Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          bottom: 10,
                        ),
                        child: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                      onDismissed: (_) {
                        firebaseController.removeFromCart(docId);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.06),
                                spreadRadius: 2,
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: ListTile(
                              leading: Image.network(
                                data['thumbnail'] ?? '',
                                width: 60,
                                height: 60,
                                errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.image_not_supported),
                              ),
                              title: Text(
                                data['title'] ?? 'Product',
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.nunito(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('\$${data['price']}'),
                                  Text(
                                    data['stock'] != null
                                        ? 'Stock: ${data['stock']}'
                                        : 'Stock: 0',
                                    style: GoogleFonts.nunito(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 40),
              InkWell(
                onTap: () => showOrderSheet(totalPrice),
                child: Container(
                  height: 60,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0056D2),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0056D2).withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$${totalPrice.toStringAsFixed(2)}',
                            style: GoogleFonts.nunito(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Checkout',
                            style: GoogleFonts.nunito(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }

  void showOrderSheet(double cartTotal) {
    Get.bottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
        ),
        child: Form(
          key: firebaseController.checkKey,
          child: Column(
            children: [
              const SizedBox(height: 16),
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 24,
                      left: 20,
                      right: 20,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Order Summary',
                              style: GoogleFonts.nunito(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '\$${cartTotal.toStringAsFixed(2)}',
                              style: GoogleFonts.nunito(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF1CB127),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width:
                              MediaQuery.of(Get.context!).size.width * 0.4,
                              child: Custom(
                                controller: firebaseController.checkCity,
                                validator: (v) =>
                                v!.isEmpty ? 'Required' : null,
                                hintText: 'City',
                                labelText: 'City',
                                prefixIcon: const Icon(
                                  Icons.location_city,
                                  color: Color(0xFF818191),
                                ),
                              ),
                            ),
                            SizedBox(
                              width:
                              MediaQuery.of(Get.context!).size.width * 0.4,
                              child: Custom(
                                controller: firebaseController.checkRoad,
                                validator: (v) =>
                                v!.isEmpty ? 'Required' : null,
                                hintText: 'Road No',
                                labelText: 'Road No',
                                prefixIcon: const Icon(
                                  Icons.add_road,
                                  color: Color(0xFF818191),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        CustomAuth(
                          controller: firebaseController.CheckNum,
                          validator: (v) => v!.isEmpty ? 'Required' : null,
                          labelText: 'Phone Number',
                          hintText: 'Phone Number',
                          prefixIcon: Image.asset(
                            'assets/images/cell.png',
                            height: 20,
                            width: 20,
                            color: const Color(0xFF818191),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: CustomButton(
                  onTap: () {
                    if (firebaseController.checkKey.currentState!.validate()) {
                      Get.back();
                      sszpaymentController.initiatePayment(cartTotal);
                    }
                  },
                  color: const Color(0xFF0056D2),
                  label: 'Confirm & Pay',
                  labelColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}