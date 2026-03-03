import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';


class CustomButton extends StatelessWidget {
  String label;
  Color color;
  Color ?labelColor;
  VoidCallback? onTap;
  VoidCallback? onPressed;
  CustomButton({
    required this.color,
    required this.label,
    this.onTap,
    this.onPressed,
    this.labelColor,

  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed ?? onTap,
      child: Container(
        height: 46,
        width: 318,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            label,style: GoogleFonts.nunito(
            color: labelColor,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          ),
        ),
      ),
    );
  }
}

