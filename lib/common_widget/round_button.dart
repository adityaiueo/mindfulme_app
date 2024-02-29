import 'package:flutter/material.dart';

enum RoundButtonType { primary, secondary }

class RoundButton extends StatefulWidget {
  final String title;
  final RoundButtonType type;
  final VoidCallback onPressed;

  const RoundButton({
    Key? key,
    required this.title,
    this.type = RoundButtonType.primary,
    required this.onPressed,
  }) : super(key: key);

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
            ? Colors
                .blue // Change TColor to Colors.blue or whatever color you intend to use
            : Colors
                .red, // Change TColor to Colors.red or whatever color you intend to use
        height: 60,
        shape: RoundedRectangleBorder(
          side: BorderSide.none,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          widget.title,
          style: TextStyle(
            color: widget.type == RoundButtonType.primary
                ? Colors
                    .white // Change TColor to Colors.white or whatever color you intend to use
                : Colors
                    .black, // Change TColor to Colors.black or whatever color you intend to use
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
