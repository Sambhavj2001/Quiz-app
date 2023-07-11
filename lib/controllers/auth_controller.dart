import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quiz_app/firebase_ref/refrences.dart';
import 'package:quiz_app/screens/home/home_screen.dart';

import '../screens/home/login_screen.dart';
import '../utils/app_logger.dart';
import '../widgets/dialog.dart';

class AuthController extends GetxController {
  @override
  void onReady() {
    initAuth();
    super.onReady();
  }

  late FirebaseAuth _auth;
  final _user = Rxn<User>();
  late Stream<User?> _authStateChanges;

  void initAuth() async {
    await Future.delayed(Duration(seconds: 2));
    _auth = FirebaseAuth.instance;
    _authStateChanges = _auth.authStateChanges();
    _authStateChanges.listen((User? user) {
      _user.value = user;
    });
    navigatorToIntroduction();
  }

  signInWithGoogle() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    try {
      GoogleSignInAccount? account = await _googleSignIn.signIn();

      if (account != null) {
        final _authAccount = await account.authentication;
        final _credential = GoogleAuthProvider.credential(
            idToken: _authAccount.idToken,
            accessToken: _authAccount.accessToken);
        await _auth.signInWithCredential(_credential);

        await saveUser(account);

        navigateToHomePage();
      }
    } on Exception catch (error) {
      AppLogger.e(error);
    }
  }

  User? getUser() {
    _user.value = _auth.currentUser;
    return _user.value;
  }

  saveUser(GoogleSignInAccount account) {
    userRf.doc(account.email).set({
      "email": account.email,
      "name": account.displayName,
      "propfilepic": account.photoUrl
    });
  }

  Future<void> signOut() async {
    AppLogger.d('Sign out');
    try {
      await _auth.signOut();
      navigateToHomePage();
    } on FirebaseException catch (e) {
      AppLogger.e(e);
    }
  }

  void navigatorToIntroduction() {
    Get.offAllNamed("/introduction");
  }

  navigateToHomePage() {
    Get.offAllNamed(HomeScreen.routeName);
  }

  void showLoginAlertDialogue() {
    Get.dialog(
      Dialogs.questionStartDialogue(onTap: () {
        Get.back();
        navigateToLoginPage();
      }),
      barrierDismissible: false,
    );
  }

  void navigateToLoginPage() {
    Get.toNamed(LoginScreen.routeName);
  }

  bool isLoggedIn() {
    return _auth.currentUser != null;
  }
}
