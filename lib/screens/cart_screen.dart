import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_media/controllers/api_controllers/sszpayment_controller.dart';
import '../controllers/auths/firebase_controller.dart';
import '../controllers/selection_controller.dart';
import '../widgets/custom.dart';
import '../widgets/custom_auth.dart';
import '../widgets/custom_button.dart';
import 'bottomnav_screen.dart';



class CartScreen extends StatelessWidget {
  CartScreen({super.key});
  SelectionController selectionController = Get.put(SelectionController());
  // selectionController.total.value = 1;
  final FirebaseController firebaseController = Get.put(FirebaseController());
  final sszpaymentController=Get.put(SszpaymentController());
  //final stripeController=Get.put(StripeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.grey.shade300,
        elevation: 0,
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
              child: Text("Cart is empty!",
                  style: GoogleFonts.nunito(fontSize: 23, color: Colors.black)),
            );
          }
          double exchangeRate = 110.0; // Example: 1 USD = 110 BDT
          double usdPrice = totalPrice / exchangeRate;
          // Calculate total price
          // double totalPrice = 0;
          // if (snapshot.hasData) {
          //   for (var doc in snapshot.data!.docs) {
          //     // Calculate total inside this scope
          //     totalPrice += (doc['price'] ?? 0).toDouble();
          //   }
          // }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var doc = snapshot.data!.docs[index];
                    Map<String, dynamic> data =
                        doc.data() as Map<String, dynamic>;
                    String docId = doc.id;

                    return Dismissible(
                      key: Key(docId),
                      direction: DismissDirection.endToStart,
                      background: Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, bottom: 10),
                        child: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.delete,
                              color: Colors.white, size: 30),
                        ),
                      ),
                      onDismissed: (direction) {
                        firebaseController.removeFromCart(docId);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          height: 100,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.06),
                                  spreadRadius: 3,
                                  blurRadius: 3,
                                  offset: const Offset(0, 3),
                                )
                              ]),
                          child: Center(
                            child: ListTile(
                              leading: Image.network(
                                data['thumbnail'] ?? '',
                                width: 60,
                                height: 60,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.image_not_supported),
                              ),
                              title: Text(data['title'] ?? 'Product',
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.nunito(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  )),
                              subtitle: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("\$${data['price']}"),
                                  Text(
                                    data['stock'] != null
                                        ? "Stock: ${data['stock']}"
                                        : "Stock: 0",
                                    style: GoogleFonts.nunito(
                                        color: Colors.grey, fontSize: 14),
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
              const SizedBox(height: 30),
              /// TODO: show order option
              InkWell(
                onTap: () =>  showOrderSheet(totalPrice),
                    //showOrderSheet(totalPrice),
                child: Container(
                  height: 55,
                  width: 318,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$${totalPrice.toStringAsFixed(2)}',
                            style: GoogleFonts.nunito(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Check out',
                            style: GoogleFonts.nunito(
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 16,
              )
            ],
          );
        },
      ),
    );
  }

  //bottomsheet
  showOrderSheet(double cartTotal) {
    Get.bottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      Container(
        width: double.infinity,
        height: 350,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        ),
        child: Form(
          key: firebaseController.checkKey,
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(30))),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: Column(
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text('Total: ',
                                  style: GoogleFonts.nunito(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              Text('\$${cartTotal.toStringAsFixed(2)}',
                                  style: GoogleFonts.nunito(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green)),
                            ]),
                        const SizedBox(height: 25),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                  width:
                                      MediaQuery.of(Get.context!).size.width *
                                          0.4,
                                  child: Custom(
                                      controller: firebaseController.checkCity,
                                      validator: (v) =>
                                          v!.isEmpty ? 'Required' : null,
                                      hintText: 'City',
                                      labelText: 'City',
                                      prefixIcon: const Icon(
                                          Icons.location_city,
                                          color: Colors.grey))),
                              SizedBox(
                                  width:
                                      MediaQuery.of(Get.context!).size.width *
                                          0.4,
                                  child: Custom(
                                      controller: firebaseController.checkRoad,
                                      validator: (v) =>
                                          v!.isEmpty ? 'Required' : null,
                                      hintText: 'Road No',
                                      labelText: 'Road No',
                                      prefixIcon: const Icon(Icons.add_road,
                                          color: Colors.grey))),
                            ]),
                        const SizedBox(height: 10),
                        CustomAuth(
                            controller: firebaseController.CheckNum,
                            validator: (v) => v!.isEmpty ? 'Required' : null,
                            labelText: 'Phone Number',
                            hintText: 'Phone Number',
                            prefixIcon: Image.asset('assets/images/cell.png',
                                height: 20, width: 20, color: Colors.grey)),
                        const SizedBox(height: 15),

                        // InkWell(
                        //  onTap: (){
                        //    sszpaymentController.initiatePayment(cartTotal);
                        //  },
                        // ),
                        // Obx(() => Row(
                        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //       children: [
                        //         RadioMenuButton<String>(
                        //             value: 'cod',
                        //             groupValue:
                        //                 selectionController.paymentMethod.value,
                        //             onChanged: (v) =>
                        //                 selectionController.changePayment(v!),
                        //             child: const Text('Cash on Delivery')),
                        //         RadioMenuButton<String>(
                        //             value: 'prepaid',
                        //             groupValue:
                        //                 selectionController.paymentMethod.value,
                        //             onChanged: (v) =>
                        //                 selectionController.changePayment(v!),
                        //             child: const Text('Prepaid Delivery')),
                        //       ],
                        //     )),

                        ///

                        // Obx(() => selectionController.paymentMethod.value ==
                        //         'prepaid'
                        //     ? Column(
                        //         children: [
                        //           const SizedBox(height: 15),
                        //           Row(
                        //               mainAxisAlignment:
                        //                   MainAxisAlignment.center,
                        //               children: [
                        //                 GestureDetector(
                        //                     onTap: () => selectionController
                        //                         .selectProvider('Paypal'),
                        //                     child: Container(
                        //                         height: 50,
                        //                         width: 60,
                        //                         decoration: BoxDecoration(
                        //                             color: Colors.blue,
                        //                             borderRadius:
                        //                                 BorderRadius.circular(
                        //                                     10),
                        //                             border: selectionController
                        //                                         .selectedProvider
                        //                                         .value ==
                        //                                     'Paypal'
                        //                                 ? Border.all(
                        //                                     color: Colors.black,
                        //                                     width: 2)
                        //                                 : null),
                        //                         child: const Icon(Icons.paypal,
                        //                             color: Colors.white))),
                        //                 const SizedBox(width: 70),
                        //                 GestureDetector(
                        //                     onTap: () => selectionController
                        //                         .selectProvider('Binance'),
                        //                     child: Container(
                        //                         height: 50,
                        //                         width: 60,
                        //                         decoration: BoxDecoration(
                        //                             color: Colors.orange,
                        //                             borderRadius:
                        //                                 BorderRadius.circular(
                        //                                     10),
                        //                             border: selectionController
                        //                                         .selectedProvider
                        //                                         .value ==
                        //                                     'Binance'
                        //                                 ? Border.all(
                        //                                     color: Colors.black,
                        //                                     width: 2)
                        //                                 : null),
                        //                         child: const Icon(
                        //                             Icons.currency_bitcoin,
                        //                             color: Colors.white))),
                        //               ]),
                        //           const SizedBox(height: 15),
                        //           Container(
                        //               width: double.infinity,
                        //               padding: const EdgeInsets.all(12),
                        //               decoration: BoxDecoration(
                        //                   color: Colors.green,
                        //                   borderRadius:
                        //                       BorderRadius.circular(10)),
                        //               child: Text(
                        //                   "Account ID: ${selectionController.transactionId.value}",
                        //                   style: GoogleFonts.nunito(
                        //                       fontWeight: FontWeight.w600,
                        //                       color: Colors.white))),
                        //           const SizedBox(height: 15),
                        //           CustomAuth(
                        //               controller:
                        //                   firebaseController.checkTransition,
                        //               validator: (v) =>
                        //                   v!.isEmpty ? 'Required' : null,
                        //               labelText: 'Transition Id',
                        //               hintText: 'Transition Id',
                        //               prefixIcon: const Icon(
                        //                   Icons.monetization_on_outlined,
                        //                   color: Colors.grey)),
                        //         ],
                        //       )
                        //     : const SizedBox.shrink()),
                      ],
                    ),
                  ),
                ),
              ),
              CustomButton(
                onTap: () {
                  if (firebaseController.checkKey.currentState!.validate()) {
                    // 1. Trigger the real payment first
                    sszpaymentController.initiatePayment(cartTotal);

                   // int amountInCents = (cartTotal * 100).toInt();

                  //  if (amountInCents > 0) {
                      // 2. Close the sheet first so the user sees the Stripe overlay clearly
                      Get.back();

                      // 3. Trigger the Stripe payment with the actual cart total
                      //stripeController.makePayment(
                       // amount: amountInCents.toString(),
                       // currency: 'USD',
                     // );

                 //   }

                    // stripeController.makePayment(amount: amountInCents.toString(), currency:'USD');
                    // 2. Then save order to firebase
                    //firebaseController.allPayment();
                    Get.back(); // Close the sheet
                  }
                },
                color: Colors.blue,
                label: 'Confirm & Pay', // Changed label to be clear
                labelColor: Colors.white,
              ),
              const SizedBox(height: 20)
            ],
          ),
        ),
      ),
    );
  }

}
