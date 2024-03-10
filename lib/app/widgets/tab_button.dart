import 'package:flutter/material.dart';
import 'package:mindfulme_app/app/common/color_extension.dart';
import 'package:google_fonts/google_fonts.dart';

class TabButton extends StatelessWidget {
  final String icon;
  final String title;
  final bool isSelect;
  final VoidCallback onPressed;

  const TabButton({
    super.key,
    required this.icon,
    required this.title,
    required this.isSelect,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 44,
            height: 35,
            decoration: BoxDecoration(
              color: isSelect ? Tcolor.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(15),
            ),
            alignment: Alignment.center,
            child: Image.asset(
              icon,
              width: 22,
              height: 22,
              color: isSelect ? Colors.white : Tcolor.secondaryText,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            title,
            style: GoogleFonts.manrope(
              textStyle: TextStyle(
                color: isSelect ? Tcolor.primary : Tcolor.secondaryText,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        ],
      ),
    );
  }
}
