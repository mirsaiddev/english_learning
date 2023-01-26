import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  Future<dynamic> userRegister({required String email, required String password}) async {
    try {
      /// Firebase ile register işlemi yapılıyor, email ve password parametreleri gönderilir, geriye UserCredential döner
      await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      return e;
    }
  }

  Future<dynamic> login({required String email, required String password}) async {
    try {
      /// Firebase ile login işlemi yapılıyor, email ve password parametreleri gönderilir, geriye UserCredential döner
      UserCredential userCredential = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } catch (e) {
      return e;
    }
  }
}
