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
      backgroundColor: const Color(0xFFF5F7FA),
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
          style: GoogleFonts.nunito(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 22),
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
                    radius: 16,
                    backgroundColor: Colors.white,
                    middleText: "Are you sure you want to remove this order?",
                    middleTextStyle: GoogleFonts.nunito(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    textConfirm: "Delete",
                    textCancel: "Cancel",
                    confirmTextColor: Colors.white,
                    buttonColor: Colors.red,
                    cancelTextColor: const Color(0xFF0056D2),
                   ) ??
                       false;
                },

                onDismissed: (_) {
                  FirebaseFirestore.instance.collection('orders').doc(docId).delete();
                  Get.snackbar(
                    'Deleted',
                    'Order has been removed successfully',
                    backgroundColor: const Color(0xFF0056D2),
                    colorText: Colors.white,
                  );
                },
                background: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade500,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white, size: 26),
                ),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          data['thumbnail'] ?? '',
                          height: 80, width: 80, fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 80,
                            height: 80,
                            color: const Color(0xFFF5F7FA),
                            child: const Icon(Icons.image, size: 40, color: Color(0xFF818191)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data['title'] ?? 'Product',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: GoogleFonts.nunito(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black)),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Text("Qty: ${data['quantity']} ",
                                    style: GoogleFonts.nunito(fontSize: 13, color: const Color(0xFF818191))),
                                Container(
                                  height: 4,
                                  width: 4,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF818191),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                Text("  \$${data['totalPrice']}",
                                    style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF1CB127))),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getStatusColor(data['status']).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                "Status: ${data['status']}",
                                style: GoogleFonts.nunito(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: _getStatusColor(data['status']),
                                ),
                              ),
                            ),
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

  Color _getStatusColor(String status) {
    final lowerStatus = status.toString().toLowerCase();
    if (lowerStatus == 'accepted') return const Color(0xFF1CB127);
    if (lowerStatus == 'pending') return const Color(0xFFFFC107);
    return const Color(0xFFFF5252);
  }
}