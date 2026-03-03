import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_media/widgets/custom.dart';
import 'package:social_media/widgets/custom_auth.dart';



class NewAd extends StatefulWidget {
  const NewAd({super.key});

  @override
  State<NewAd> createState() => _NewAdState();
}

class _NewAdState extends State<NewAd> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: InkWell(
            onTap: (){
              Get.back();
            },
            child: Icon (Icons.arrow_back,color: Colors.black,size: 25,)),
        title: Text('Addresses',style: GoogleFonts.nunito(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.black,
        ),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 25,right: 25),
          child: Column(
            children: [
              const SizedBox(height: 20,),
              CustomAuth(labelText: 'Name', hintText: 'Name',
              prefixIcon: Image.asset('assets/images/person.png'),
              ),
              const SizedBox(height: 16,),
              CustomAuth(labelText: 'Phone Number', hintText: 'Phone Number',
                prefixIcon: Image.asset('assets/images/cell.png'),
              ),
              const SizedBox(height: 16,),
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Custom(hintText: 'Street',
                 labelText: 'Street',
                   prefixIcon: Icon(Icons.streetview,color: Colors.grey,),
                 ),
                 Custom(hintText: 'Post Code',
                   labelText: 'Post Code',
                   prefixIcon: Icon(Icons.post_add_outlined,color: Colors.grey,),
                 ),
               ],
             ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Custom(hintText: 'City',
                    labelText: 'City',
                    prefixIcon: Icon(Icons.location_city,color: Colors.grey,),
                  ),
                  Custom(hintText: 'State',
                    labelText: 'State',
                    prefixIcon: Icon(Icons.stacked_bar_chart,color: Colors.grey,),
                  ),
                ],
              ),
              const SizedBox(height: 16,),
              CustomAuth(labelText: 'Country', hintText: 'Country',
                prefixIcon:Icon(Icons.flag,color: Colors.grey,),
              ),
              const SizedBox(height:40,),
              Center(
                child: Container(
                  width: 318,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(child: Text('Save',style: GoogleFonts.nunito(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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
