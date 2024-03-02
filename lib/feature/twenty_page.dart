// Import package
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mindfulme_app/common_widget/round_button.dart';

class TwentyPage extends StatefulWidget {
  const TwentyPage({super.key});

  @override
  _TwentyPageState createState() => _TwentyPageState();
}

class _TwentyPageState extends State<TwentyPage>
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
        title: const Text('Twenty Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedOpacity(
              opacity: _fadeAnimation.value,
              duration: const Duration(seconds: 2),
              child: const Text(
                'Kamu sudah menatap layar selama 20 menit, ayo istirahatkan matamu selama 20 detik.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 20),
            _isCountdownFinished
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$_countdownSeconds detik',
                        style: const TextStyle(fontSize: 40),
                      ),
                      const SizedBox(height: 20),
                      // Gunakan RoundButton untuk tombol "Lanjut"
                      RoundButton(
                        title: 'Lanjut',
                        onPressed: () {
                          // Implement your action here to close the page
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
