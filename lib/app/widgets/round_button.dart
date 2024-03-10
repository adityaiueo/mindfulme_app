import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mindfulme_app/app/common/color_extension.dart';

enum RoundButtonType { primary, secondary }

class RoundButton extends StatefulWidget {
  final String title;
  final RoundButtonType type;
  final VoidCallback onPressed;

  const RoundButton({
    super.key,
    required this.title,
    this.type = RoundButtonType.primary,
    required this.onPressed,
  });

  @override
  State<RoundButton> createState() => _RoundButtonState();
}

class _RoundButtonState extends State<RoundButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: MaterialButton(
        onPressed: widget.onPressed,
        minWidth: double.maxFinite,
        elevation: 0,
        color: widget.type == RoundButtonType.primary
            ? Tcolor
                .primary // Change TColor to Colors.blue or whatever color you intend to use
            : Tcolor
                .tertiary, // Change TColor to Colors.red or whatever color you intend to use
        height: 60,
        shape: RoundedRectangleBorder(
          side: BorderSide.none,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          widget.title,
          style: GoogleFonts.manrope(
            color: widget.type == RoundButtonType.secondary
                ? Tcolor
                    .primaryText // Change TColor to Colors.white or whatever color you intend to use
                : Tcolor
                    .primaryText, // Change TColor to Colors.black or whatever color you intend to use
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
