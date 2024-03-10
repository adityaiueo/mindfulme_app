import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mindfulme_app/app/common/color_extension.dart';
import 'package:mindfulme_app/app/widgets/round_button.dart';

class MindfulPage extends StatefulWidget {
  const MindfulPage({super.key});

  @override
  State<MindfulPage> createState() => _MindfulPageState();
}

class _MindfulPageState extends State<MindfulPage>
    with SingleTickerProviderStateMixin {
  late Timer _timer;
  String _breathingStatus = '';
  bool _isBreathingDone = false;
  int maxSeconds = 10; // Total time for one breathing cycle
  int currentTime = 0;


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startBreathingSequence() {
    currentTime = 0;
    setState(() {
      _breathingStatus = 'Inhale...';
      _isBreathingDone = false;
    });

    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_breathingStatus == 'Inhale...') {
          if (currentTime < maxSeconds) {
            setState(() {
              currentTime++;
            });
          } else {
            setState(() {
              _breathingStatus = 'Exhale...';
              currentTime = maxSeconds - 1;
            });
          }
        } else if (_breathingStatus == 'Exhale...') {
          if (currentTime > 0) {
            setState(() {
              currentTime--;
            });
          } else {
            timer.cancel();
            setState(() {
              _isBreathingDone = true;
              _breathingStatus = '';
            });
          }
        }
      },
    );
  }

  bool _isButtonTapped = false; // Correctly declare _isButtonTapped as a bool

  void _handleTap() {
    setState(() {
      _isButtonTapped = true; // Set the state to true when the button is tapped
    });
    _startBreathingSequence(); // Call the method to start the breathing sequence
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff8E97FD),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Image.asset(
            "assets/img/medi.png",
            width: context.width,
            fit: BoxFit.fitWidth,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Mindful Breathing Session",
                    style: GoogleFonts.manrope(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Text(
                    "Are You Still Aware?",
                    style: GoogleFonts.manrope(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text("don't Get Trapped",
                      style: GoogleFonts.manrope(
                          color: Colors.white,
                          fontSize: 27,
                          fontWeight: FontWeight.w400)),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Let's do mindful breathing session. Getting back your awareness and clarity",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.manrope(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w300),
                  ),
                  const Spacer(),
                  Text(
                    _breathingStatus != ''
                        ? '$_breathingStatus ${currentTime > 0 ? '$currentTime..' : ''}'
                        : '',
                    style: GoogleFonts.manrope(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 25,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  AnimatedOpacity(
                    // Opasitas bergantung pada state _isButtonTapped dan _isBreathingDone
                    opacity:
                        _isBreathingDone ? 1.0 : (_isButtonTapped ? 0.0 : 1.0),
                    duration: const Duration(milliseconds: 500),
                    child: RoundButton(
                      // Teks bergantung pada state _isBreathingDone
                      title: _isBreathingDone
                          ? "CONTINUE"
                          : "START MINDFUL BREATHING",
                      onPressed: () {
                        if (!_isButtonTapped && !_isBreathingDone) {
                          // Jika tombol belum ditekan dan _isBreathingDone false
                          setState(() {
                            _isButtonTapped = true; // Tombol telah ditekan
                          });
                          _handleTap(); // Memulai mindful breath
                        } else if (_isBreathingDone) {
                          Navigator.pop(context);
                        }
                      },
                      type: RoundButtonType.secondary,
                    ),
                  ),
                  const SizedBox(
                    height: 80,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
