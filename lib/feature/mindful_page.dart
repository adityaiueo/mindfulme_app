import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MindfulPage extends StatefulWidget {
  const MindfulPage({Key? key}) : super(key: key);

  @override
  _MindfulPageState createState() => _MindfulPageState();
}

class _MindfulPageState extends State<MindfulPage>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
      reverseDuration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mindful Breathing'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Container(
                  width: 100,
                  height: 100 * _controller.value,
                  color: Colors.blue,
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Tutup aplikasi
                SystemNavigator.pop();
              },
              child: const Text('Continue?'),
            ),
          ],
        ),
      ),
    );
  }
}
