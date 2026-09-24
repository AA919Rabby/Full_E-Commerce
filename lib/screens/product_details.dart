import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_media/models/product_model.dart';
import 'package:social_media/screens/bottomnav_screen.dart';
import 'package:social_media/screens/product_zoom.dart';
import 'package:social_media/widgets/custom.dart';
import 'package:social_media/widgets/custom_auth.dart';
import 'package:social_media/widgets/custom_button.dart';
import '../controllers/api_controllers/sszpayment_controller.dart';
import '../controllers/auths/firebase_controller.dart';
import '../controllers/selection_controller.dart';



class ProductDetails extends StatefulWidget {
  const ProductDetails({super.key});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  late Products products;
  final sszpaymentController=Get.put(SszpaymentController());
  SelectionController selectionController = Get.put(SelectionController());
  FirebaseController firebaseController = Get.put(FirebaseController());
  //final stripeController=Get.put(StripeController());
  @override
  void initState() {
    super.initState();
    products = Get.arguments;
    selectionController.total.value = 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: null,
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        elevation: 12,
        child: InkWell(
          onTap: () {
            showOrderSheet();
          },
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF0056D2),
                  const Color(0xFF0070E8),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        '\$',
                        style: GoogleFonts.nunito(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        products.price?.toString() ?? '!',
                        style: GoogleFonts.nunito(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                  Text(
                    'Order now',
                    style: GoogleFonts.nunito(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            )
                          ],
                        ),
                        child: const Icon(Icons.arrow_back,
                            color: Colors.black, size: 24),
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          firebaseController.addFav(products);
                          Get.snackbar('Success',
                              '${products.title} added to favourites',
                              backgroundColor: const Color(0xFF0056D2),
                              colorText: Colors.white);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              )
                            ],
                          ),
                          child: Icon(
                            Icons.favorite_outline_rounded,
                            color: Colors.red,
                            size: 24,
                          ),
                        ))
                  ],
                ),
              ),

               // Product Images
               Container(
                 color: Colors.white,
                 child: Center(
                   child: SizedBox(
                     height: 260,
                     child: ListView.builder(
                       scrollDirection: Axis.horizontal,
                       itemCount: products.images?.length ?? 0,
                       itemBuilder: (context, index) {
                         return GestureDetector(
                           onTap: () =>
                               Get.to(() => ProductZoom(), arguments: products),
                           child: Container(
                             width: MediaQuery.of(context).size.width,
                             color: const Color(0xFFF5F7FA),
                             child: Image.network(products.images![index],
                                 fit: BoxFit.contain),
                           ),
                         );
                       },
                     ),
                   ),
                 ),
               ),

               const SizedBox(height: 24),
               Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 20),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text(
                       products.title ?? "!",
                       style: GoogleFonts.nunito(
                           fontSize: 24,
                           fontWeight: FontWeight.bold,
                           color: Colors.black),
                     ),
                     const SizedBox(height: 16),

                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Container(
                           padding: const EdgeInsets.symmetric(
                               horizontal: 14, vertical: 8),
                           decoration: BoxDecoration(
                             color: const Color(0xFF0056D2).withOpacity(0.1),
                             borderRadius: BorderRadius.circular(10),
                           ),
                           child: Text(
                             products.category ?? '!',
                             style: GoogleFonts.nunito(
                                 fontSize: 13,
                                 fontWeight: FontWeight.w600,
                                 color: const Color(0xFF0056D2)),
                           ),
                         ),
                         Container(
                           padding: const EdgeInsets.symmetric(
                               horizontal: 12, vertical: 6),
                           decoration: BoxDecoration(
                             color: const Color(0xFF1CB127).withOpacity(0.1),
                             borderRadius: BorderRadius.circular(8),
                           ),
                           child: Row(
                             children: [
                               const Icon(Icons.check_circle,
                                   size: 14,
                                   color: Color(0xFF1CB127)),
                               const SizedBox(width: 4),
                               Text('Stock: ${products.stock ?? 0}',
                                   style: GoogleFonts.nunito(
                                       fontSize: 13,
                                       fontWeight: FontWeight.w600,
                                       color: const Color(0xFF1CB127))),
                             ],
                           ),
                         )
                       ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                 ),


            ],
          ),
        ),
      ),
    );
  }

  showOrderSheet() {
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
          key: firebaseController.cartKey,
          child: Column(
            children: [
              const SizedBox(height: 16),
              Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(30))),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 24, left: 20, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                InkWell(
                                    onTap: () =>
                                        selectionController.decrement(),
                                    child: const Icon(Icons.remove,
                                        color: Colors.red)),
                                const SizedBox(width: 12),
                                Obx(() => Text(
                                    selectionController.total.value.toString(),
                                    style: GoogleFonts.nunito(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w500))),
                                const SizedBox(width: 12),
                                InkWell(
                                    onTap: () =>
                                        selectionController.increment(),
                                    child: const Icon(Icons.add,
                                        color: Colors.blue)),
                              ],
                            ),
                            Row(
                              children: [
                                Text('Total: ',
                                    style: GoogleFonts.nunito(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                Obx(() => Text(
                                    '\$${(selectionController.total.value * (products.price ?? 0)).toStringAsFixed(2)}',
                                    style: GoogleFonts.nunito(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green))),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                                width: MediaQuery.of(Get.context!).size.width *
                                    0.4,
                                child: Custom(
                                    controller: firebaseController.cartCity,
                                    validator: (v) =>
                                        v!.isEmpty ? 'Required' : null,
                                    hintText: 'City',
                                    labelText: 'City',
                                    prefixIcon: const Icon(Icons.location_city,
                                        color: Colors.grey))),
                            SizedBox(
                                width: MediaQuery.of(Get.context!).size.width *
                                    0.4,
                                child: Custom(
                                    controller: firebaseController.cartRoad,
                                    validator: (v) =>
                                        v!.isEmpty ? 'Required' : null,
                                    hintText: 'Road No',
                                    labelText: 'Road No',
                                    prefixIcon: const Icon(Icons.add_road,
                                        color: Colors.grey))),
                          ],
                        ),
                        const SizedBox(height: 10),
                        CustomAuth(
                            controller: firebaseController.CartNum,
                            validator: (v) => v!.isEmpty ? 'Required' : null,
                            labelText: 'Phone Number',
                            hintText: 'Phone Number',
                            prefixIcon: Image.asset('assets/images/cell.png',
                                height: 20, width: 20, color: Colors.grey)),
                        const SizedBox(height: 15),

                        /// PAYMENT LOGIC
                        /// Binance payment
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
                        //TODO Binance payoneer
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
                        //                   firebaseController.cartTransition,
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
                onTap: () async {
                  // 1. Validate Form (City, Road, Phone)
                  if (firebaseController.cartKey.currentState!.validate()) {

                    // 2. Calculate Total Price
                    double unitPrice = (products.price ?? 0.0).toDouble();
                    int quantity = selectionController.total.value;
                    double finalTotalPrice = unitPrice * quantity;

                    if (finalTotalPrice > 0) {
                      // 3. Close the bottom sheet immediately
                      Get.back();

                      // 4. Trigger Stripe Payment
                      // We multiply by 100 because Stripe expects Cents (e.g. $20.00 = 2000)
                      int amountInCents = (finalTotalPrice * 100).toInt();

                      sszpaymentController.initiatePayment(finalTotalPrice);


                      // await stripeController.makePayment(
                      //     amount: amountInCents.toString(),
                      //     currency: "USD"
                      // );

                      // 5. Optional: If payment is successful, save to Firebase
                      // You can call this inside your Controller after presentPaymentSheet succeeds
                      // firebaseController.cartPaymentDetails(products, quantity);
                    } else {
                      Get.snackbar("Error", "Total amount must be greater than 0");
                    }
                  }
                },
                color: Colors.blue,
                label: 'Confirm & Pay',
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
