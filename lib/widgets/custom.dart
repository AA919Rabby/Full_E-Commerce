import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';



class Custom extends StatelessWidget {
  final String hintText;
  final Icon? prefixIcon;
  final String labelText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const Custom({
    super.key,
    required this.hintText,
    this.prefixIcon,
    required this.labelText,
    this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      width: 160,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        controller: controller,
        validator: validator,
        style: GoogleFonts.nunito(
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: GoogleFonts.nunito(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
          prefixIcon: prefixIcon,
          hintText: hintText,
          hintStyle: GoogleFonts.nunito(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.grey, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.black, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.red, width: 1),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}