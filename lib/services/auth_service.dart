import 'package:firebase_auth/firebase_auth.dart';
import 'package:message_app/helper/helper_funcation.dart';
import 'package:message_app/services/database_service.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // login user

  Future loginUserEmailAndPassword(String email, String password) async {
    try {
      User? user = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;

      if (user != null) {
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

// register user
  Future registerUserEmailAndPassword(
      String email, String password, String fullName) async {
    try {
      User? user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;

      if (user != null) {
        await DatabaseService(uid: user.uid).saveUserData(fullName, email);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

// signout user

  Future signOut() async {
    try {
      await HelperFuncation.saveUserLoggedInStatus(false);
      await HelperFuncation.saveUserEmailStatus("");
      await HelperFuncation.saveUserNameStatus("");
      await firebaseAuth.signOut();
    } on Exception catch (e) {
      return null;
    }
  }
}
