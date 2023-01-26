import 'package:english_learning/screens/Home/home_screen.dart';
import 'package:english_learning/screens/Login/login.dart';
import 'package:english_learning/screens/Register/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    check();
  }

  Future<void> check() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      await Future.delayed(Duration(seconds: 2));
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false);
    } else {
      await Future.delayed(Duration(seconds: 2));
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomeScreen()), (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Icon(Icons.language),
      ),
    );
  }
}
