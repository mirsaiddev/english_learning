import 'package:english_learning/screens/Register/register.dart';
import 'package:english_learning/services/auth_service.dart';
import 'package:english_learning/theme/my_colors.dart';
import 'package:english_learning/widgets/my_button.dart';
import 'package:english_learning/widgets/my_snackbar.dart';
import 'package:english_learning/widgets/my_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../Home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = kDebugMode ? TextEditingController(text: 'mu@sin.com') : TextEditingController();
  TextEditingController passwordController = kDebugMode ? TextEditingController(text: '123456') : TextEditingController();
  final formKey = GlobalKey<FormState>();

  Future<void> login() async {
    if (!formKey.currentState!.validate()) {
      MySnackbar.show(context, message: 'Lütfen tüm alanları doldurunuz');
      return;
    }

    /// AuthService kullanılarak login işlemi yapılıyor, email ve password parametreleri gönderilir, geriye User veya FirebaseAuthException döner
    var respunse = await AuthService().login(email: emailController.text, password: passwordController.text);
    if (respunse.runtimeType == User) {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomeScreen()), (route) => false);
    } else {
      MySnackbar.show(context, message: (respunse as FirebaseAuthException).message.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              // image: DecorationImage(
              //   image: AssetImage("lib/assets/bg.jpg"),
              //   fit: BoxFit.cover,
              // ),
              gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [MyColors.red2, MyColors.orange]),
            ),
            child: SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: height * 0.2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 20,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'English Learning',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              ),
              padding: EdgeInsets.only(top: 10, left: 20, right: 20),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MyTextfield(
                      text: 'E-posta',
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (text) {
                        if (text!.contains(' ')) {
                          return 'Lütfen Boşluk Bırakmayın';
                        }

                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    MyTextfield(
                      text: 'Şifre',
                      obscureText: true,
                      controller: passwordController,
                      validator: (text) {
                        if (text!.isEmpty) {
                          return 'Şifre boş bırakılamaz';
                        }
                        if (text.length < 6) {
                          return 'Şifre en az 6 karakter olmalıdır';
                        }

                        return null;
                      },
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          'Şifremi Unuttum',
                          style: TextStyle(color: MyColors.red),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    MyButton(
                      text: 'Giriş Yap',
                      onPressed: login,
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Hesabın yok mu?'),
                        TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()));
                          },
                          child: Text(
                            'Kayıt Ol',
                            style: TextStyle(color: MyColors.red),
                          ),
                        ),
                      ],
                    ),
                    // Wrap(
                    //   children: [
                    //     TextButton(
                    //       onPressed: () {
                    //         // Navigator.push(context, MaterialPageRoute(builder: (context) => OwnerLoginScreen()));
                    //       },
                    //       child: Text(
                    //         'Mekan Sahibi Girişi',
                    //         style: TextStyle(color: MyColors.red),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
