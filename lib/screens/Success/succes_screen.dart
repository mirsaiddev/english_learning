import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({Key? key}) : super(key: key);

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  ConfettiController confettiController = ConfettiController(duration: const Duration(seconds: 3000));

  @override
  void initState() {
    super.initState();
    play();
  }

  void play() {
    confettiController.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topRight,
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Tebrikler Seviye Atladınız', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Positioned(
            top: 40,
            left: MediaQuery.of(context).size.width,
            child: SafeArea(
              child: ConfettiWidget(confettiController: confettiController),
            ),
          ),
        ],
      ),
    );
  }
}
