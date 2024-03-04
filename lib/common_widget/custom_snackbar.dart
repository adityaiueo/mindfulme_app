import 'package:flutter/material.dart';
import 'package:mindfulme_app/common/color_extension.dart';

class CustomSnackBar {
  static show(
    BuildContext context, {
    required String title,
    required String message,
    bool success = false,
  }) {
    // Pilih snackbar yang sesuai berdasarkan parameter 'success'
    SnackBar snackBar = success
        ? reminderSuccessMessage(context, title, message)
        : reminderMessage(context, title, message);

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static SnackBar reminderMessage(
      BuildContext context, String title, String message) {
    return SnackBar(
      content: Container(
        width: double.infinity,
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.orange.withAlpha(90), width: 2),
          color: Colors.orange.withAlpha(20),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.orangeAccent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.error, color: Colors.white),
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        fontFamily: 'Helvetica',
                      ),
                    ),
                    Text(
                      message,
                      style: TextStyle(
                        color: Colors.black.withOpacity(.5),
                        fontSize: 12,
                        fontFamily: 'Helvetica',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
              child: SizedBox(
                width: 40,
                height: 40,
                child: Icon(Icons.close, color: Colors.black.withOpacity(.8)),
              ),
            ),
          ],
        ),
      ),
      margin: const EdgeInsets.symmetric(vertical: 16),
      duration: const Duration(seconds: 3),
      elevation: 0,
      backgroundColor: Colors.transparent,
      behavior: SnackBarBehavior.floating,
    );
  }

  static SnackBar reminderSuccessMessage(
      BuildContext context, String title, String message) {
    return SnackBar(
      content: Container(
        width: double.infinity,
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Tcolor.secondary.withAlpha(90), width: 2),
          color: Tcolor.primary.withAlpha(20),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Tcolor.tertiary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.error, color: Colors.white),
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        fontFamily: 'Helvetica',
                      ),
                    ),
                    Text(
                      message,
                      style: TextStyle(
                        color: Colors.black.withOpacity(.5),
                        fontSize: 12,
                        fontFamily: 'Helvetica',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
              child: SizedBox(
                width: 40,
                height: 40,
                child: Icon(Icons.close, color: Colors.black.withOpacity(.8)),
              ),
            ),
          ],
        ),
      ),
      margin: const EdgeInsets.symmetric(vertical: 16),
      duration: const Duration(seconds: 3),
      elevation: 0,
      backgroundColor: Colors.transparent,
      behavior: SnackBarBehavior.floating,
    );
  }
}
