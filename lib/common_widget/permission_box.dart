import 'package:flutter/material.dart';
import 'package:mindfulme_app/common/color_extension.dart';
import 'package:mindfulme_app/common_widget/custom_snackbar.dart';

class PermissionBox extends StatelessWidget {
  final String imagePath;
  final String message;
  final Function onContinuePressed;

  const PermissionBox({
    super.key,
    required this.imagePath,
    required this.message,
    required this.onContinuePressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 200,
      child: Stack(
        children: [
          // Background Container with Half Purple and Half White
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Tcolor.secondary
                        .withOpacity(0.5), // Purple color with opacity
                    Colors.white, // White color
                  ],
                ),
              ),
            ),
          ),
          // Image Container
          Positioned(
            top: 10,
            left: 10,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Tcolor.secondary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset(
                imagePath,
                width: 100,
                height: 100,
              ),
            ),
          ),
          // Text and Button Container
          Positioned(
            top: 10,
            right: 10,
            bottom: 10,
            left: 10,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 16,
                    color: Tcolor.primaryText,
                    fontFamily: 'Helvetica',
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        CustomSnackBar.show(
                          success: false,
                          context,
                          title: 'Warning',
                          message:
                              'Apabila kamu tidak memberi izin, mungkin akan ada beberapa fitur yang bermasalah',
                        );
                      },
                      child: Text(
                        'Not Now',
                        style: TextStyle(
                          fontSize: 16,
                          color: Tcolor.primaryText,
                          fontFamily: 'Helvetica',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Handle "Continue" button press
                        onContinuePressed();
                      },
                      child: Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 16,
                          color: Tcolor.primaryTextW,
                          fontFamily: 'Helvetica',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
