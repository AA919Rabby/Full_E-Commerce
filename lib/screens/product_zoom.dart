import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/product_model.dart';


class ProductZoom extends StatefulWidget {
  const ProductZoom({super.key});

  @override
  State<ProductZoom> createState() => _ProductZoomState();
}

class _ProductZoomState extends State<ProductZoom> {
  late Products products;

  @override
  void initState() {
    super.initState();
    // Initialize the data
    products = Get.arguments;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade300,
        automaticallyImplyLeading: false,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 40),
              Center(
                child: SizedBox(
                  height: 330,
                  child: ListView.builder(
                    itemCount: products.images?.length ?? 0,
                    itemBuilder: (context, index) {
                      return Center(
                        child: Container(
                          width: 300,
                          child: Center(
                            child: Image.network(
                              products.images![index],
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 80),
              InkWell(
                onTap: (){
                  Get.back();
                },
                child: Container(
                  width: 318,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(child: Text('Close',style: GoogleFonts.nunito(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 17,
                  ),)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
