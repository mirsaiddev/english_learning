import 'package:english_learning/screens/Home/home_screen.dart';
import 'package:english_learning/services/auth_service.dart';
import 'package:english_learning/theme/my_colors.dart';
import 'package:english_learning/widgets/my_button.dart';
import 'package:english_learning/widgets/my_snackbar.dart';
import 'package:english_learning/widgets/my_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController nameController = TextEditingController(text: 'mirsaid');
  TextEditingController emailController = TextEditingController(text: 'mirsaid@gmail.com');
  TextEditingController passwordController = TextEditingController(text: '123456');
  TextEditingController passwordAgainController = TextEditingController(text: '123456');
  final formKey = GlobalKey<FormState>();

  Future<void> register() async {
    if (!formKey.currentState!.validate()) {
      MySnackbar.show(context, message: 'Lütfen tüm alanları doldurunuz');
      return;
    }
    if (passwordController.text != passwordAgainController.text) {
      MySnackbar.show(context, message: 'Şifreler uyuşmuyor');
      return;
    }

    /// AuthService kullanılarak register işlemi yapılıyor, email ve password parametreleri gönderilir, geriye User veya FirebaseAuthException döner
    var reuslt = await AuthService().userRegister(email: emailController.text, password: passwordController.text);
    if (reuslt == true) {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomeScreen()), (route) => false);
    } else {
      MySnackbar.show(context, message: (reuslt as FirebaseAuthException).message.toString());
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
          SafeArea(
            bottom: false,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                ),
                padding: EdgeInsets.all(20),
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        MyTextfield(
                          text: 'Ad soyad',
                          controller: nameController,
                          keyboardType: TextInputType.name,
                          validator: (text) {
                            if (text!.isEmpty) {
                              return 'Ad soyad boş bırakılamaz';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        MyTextfield(
                          text: 'E-posta',
                          controller: emailController,
                          validator: (text) {
                            if (text!.isEmpty) {
                              return 'E-posta boş bırakılamaz';
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
                        SizedBox(height: 10),
                        MyTextfield(
                          obscureText: true,
                          text: 'Şifre Tekrar',
                          controller: passwordAgainController,
                          validator: (text) {
                            if (text!.isEmpty) {
                              return 'Şifre boş bırakılamaz';
                            }
                            if (text.length < 6) {
                              return 'Şifre en az 6 karakter olmalıdır';
                            }
                            if (text != passwordController.text) {
                              return 'Şifreler uyuşmuyor';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        MyButton(
                          text: 'Kayıt Ol',
                          onPressed: register,
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Hesabın var mı?'),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Giriş Yap',
                                style: TextStyle(color: MyColors.red),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
