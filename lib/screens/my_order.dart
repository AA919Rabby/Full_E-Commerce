import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';



class MyOrder extends StatelessWidget {
  MyOrder({super.key});

  @override
  Widget build(BuildContext context) {
    String? uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: Text(
          'My Orders',
          style: GoogleFonts.nunito(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('userId', isEqualTo: uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text("No orders yet!",
                  style: GoogleFonts.nunito(fontSize: 23, color: Colors.black,fontWeight: FontWeight.w500)),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            padding: const EdgeInsets.all(15),
            itemBuilder: (context, index) {
              var data = snapshot.data!.docs[index].data() as Map<String, dynamic>;
              String docId = snapshot.data!.docs[index].id;

              // Date handling
              String date = "N/A";
              if (data['createdAt'] != null) {
                date = DateFormat('dd MMM yyyy, hh:mm a')
                    .format((data['createdAt'] as Timestamp).toDate());
              }

              return Dismissible(
                key: Key(docId),
                direction: DismissDirection.endToStart,
                confirmDismiss: (direction) async {
                  return await Get.defaultDialog(
                    title: "Delete Order?",
                    titleStyle: GoogleFonts.nunito(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black,
                    ),
                    radius: 0,
                    middleText: "Are you sure you want to remove this order from your list?",
                    middleTextStyle: GoogleFonts.nunito(),
                    textConfirm: "Yes",
                    textCancel: "No",
                    confirmTextColor: Colors.white,
                    buttonColor: Colors.red,
                    onConfirm: () {
                      Get.back(result: true);
                    },
                    onCancel: () {
                      Get.back(result: false);
                    },
                  );
                },


                onDismissed: (_) {
                  FirebaseFirestore.instance.collection('orders').doc(docId).delete();
                  Get.snackbar(
                    'Deleted',
                    'Order has been removed successfully',
                  );
                },
                background: Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [const BoxShadow(color: Colors.black12, blurRadius: 4)],
                  ),
                  child: Row(
                    children: [
                      // Product Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          data['thumbnail'] ?? '',
                          height: 70, width: 70, fit: BoxFit.cover,
                          // to show a icons if it fail to load image
                          errorBuilder: (_, __, ___) => const Icon(Icons.image, size: 70),
                        ),
                      ),
                      const SizedBox(width: 15),
                      // Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data['title'] ?? 'Product',
                                style: GoogleFonts.nunito(fontWeight: FontWeight.bold, fontSize: 16)),
                            Text("Qty: ${data['quantity']} | \$${data['totalPrice']}",
                                style: GoogleFonts.nunito(fontSize: 14)),
                            Text("Status: ${data['status']}",
                                style: GoogleFonts.nunito(fontSize: 13,
                                    color: data['status'] == 'pending' ? Colors.green : Colors.blue)),
                            Text("Payment: ${data['payment']}",
                                style: GoogleFonts.nunito(fontSize: 13, color: Colors.grey)),
                          ],
                        ),
                      ),
                      Text(date, style: GoogleFonts.nunito(fontSize: 10, color: Colors.grey)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}