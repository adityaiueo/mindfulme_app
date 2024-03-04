// Import package
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mindfulme_app/common/color_extension.dart';
import 'package:mindfulme_app/common_widget/round_button.dart';

class TwentyPage extends StatefulWidget {
  const TwentyPage({super.key});

  @override
  TwentyPageState createState() => TwentyPageState();
}

class TwentyPageState extends State<TwentyPage>
    with SingleTickerProviderStateMixin {
  int _countdownSeconds = 20;
  bool _isCountdownFinished = false;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_fadeController);
    _fadeController.forward();
    startCountdown();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void startCountdown() {
    Timer(const Duration(seconds: 2), () {
      Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_countdownSeconds > 0) {
            _countdownSeconds--;
          } else {
            _isCountdownFinished = true;
            timer.cancel();
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('20-20-20 Rule'),
        backgroundColor: Tcolor.primary, // Warna dominan
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
                padding: const EdgeInsets.all(20),
                color: Tcolor.secondary, // Warna sekunder
                child: Text(
                  'Kamu sudah menatap layar selama 20 menit, ayo istirahatkan matamu selama 20 detik.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Tcolor.primaryTextW,
                    fontFamily: 'Helvetica',
                    fontWeight:
                        FontWeight.w700, // Warna teks utama di atas warna gelap
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _isCountdownFinished
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$_countdownSeconds detik',
                        style: TextStyle(
                          fontSize: 40,
                          color: Tcolor
                              .primaryTextW, // Warna teks utama di atas warna gelap
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Gunakan RoundButton untuk tombol "Lanjut"
                      RoundButton(
                        title: 'Continue',
                        type: RoundButtonType
                            .primary, // Sesuaikan dengan tipe tombol yang diinginkan
                        onPressed: () {
                          // Implement your action here to handle button tap
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  )
                : const SizedBox(),
          ],
        ),
      ),
      backgroundColor: Tcolor.txtBG, // Warna latar belakang teks
    );
  }
}
