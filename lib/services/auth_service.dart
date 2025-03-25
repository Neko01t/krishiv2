import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:krishi/screens/home_screen.dart';  // Import your home screen
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // ✅ Google Sign-In method
  Future<UserCredential?> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print("⚠️ Google Sign-In canceled");
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      print("✅ Google Sign-In Successful: ${userCredential.user?.displayName}");

      // ✅ Navigate to home screen upon successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );

      return userCredential;
    } catch (e) {
      print("🔥 Google Sign-In Error: $e");
      return null;
    }
  }

  // ✅ Facebook Sign-In method
  Future<UserCredential?> signInWithFacebook(BuildContext context) async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final AccessToken? accessToken = result.accessToken;
        final AuthCredential credential = FacebookAuthProvider.credential(accessToken!.tokenString);

        UserCredential userCredential = await _auth.signInWithCredential(credential);
        print("✅ Facebook Sign-In Successful: ${userCredential.user?.displayName}");

        // ✅ Navigate to home screen upon successful login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );

        return userCredential;
      } else {
        print("⚠️ Facebook Sign-In canceled");
        return null;
      }
    } catch (e) {
      print("🔥 Facebook Sign-In Error: $e");
      return null;
    }
  }

  // ✅ Sign out method (Works for both Google & Facebook)
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await FacebookAuth.instance.logOut();
    await _auth.signOut();
    print("🚪 User signed out successfully");
  }
}
