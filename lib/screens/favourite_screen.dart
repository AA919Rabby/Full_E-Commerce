import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/auths/firebase_controller.dart';

class FavouriteScreen extends StatelessWidget {
  FavouriteScreen({super.key});
  final FirebaseController firebaseController = Get.find<FirebaseController>();

  @override
  Widget build(BuildContext context) {
    String? uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        elevation: 0,
        title: null,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('favourites')
            .doc(uid)
            .collection('favItems')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text("No favourites yet!",
                  style: GoogleFonts.nunito(fontSize: 23, color: Colors.black)),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var doc = snapshot.data!.docs[index];
                    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                    String docId = doc.id;

                    return Dismissible(
                      key: Key(docId),
                      direction: DismissDirection.endToStart,
                      background: Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                        child: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.delete, color: Colors.white, size: 30),
                        ),
                      ),
                      onDismissed: (direction) {
                        firebaseController.removeFromFav(docId);
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
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("\$${data['price']}"),
                                  Text(
                                    data['stock'] != null ? "Stock: ${data['stock']}" : "Stock: 0",
                                    style: GoogleFonts.nunito(color: Colors.grey, fontSize: 14),
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
              const SizedBox(height: 16,)
            ],
          );
        },
      ),
    );
  }
}