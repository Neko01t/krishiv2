import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Google Sign-In method
  Future<UserCredential?> signInWithGoogle() async {
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
      return userCredential;
    } catch (e) {
      print("🔥 Google Sign-In Error: $e");
      return null;
    }
  }

  // Sign out method
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    print("🚪 User signed out successfully");
  }
}
