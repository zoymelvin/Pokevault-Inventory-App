import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Google Sign-In instance (v7.2.0)
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  final String clientId =
      '471254723758-99t11odsgn0u0p8qri9rebln1ag121ab.apps.googleusercontent.com';
  final String serverClientId =
      '471254723758-i5aasgnuas0bl8t8132ark22npeva33p.apps.googleusercontent.com';

  // Stream untuk memantau status login (PENTING untuk Wrapper)
  Stream<User?> get user => _auth.authStateChanges();

  // 1. REGISTER (Daftar)
  Future<User?> registerWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print("Error Register: $e");
      rethrow;
    }
  }

  // 2. LOGIN EMAIL/PASSWORD
  Future<User?> loginWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print("Error Login: $e");
      rethrow;
    }
  }

  // 2b. LOGIN DENGAN GOOGLE (refleksi dari AuthHelper lamamu)
  Future<User?> signInWithGoogle() async {
    try {
      // Inisialisasi GoogleSignIn (v7.2.0)
      // Sama konsep dengan AuthHelper:
      //   googleSignIn.initialize(clientId: ..., serverClientId: ...)
      unawaited(
        _googleSignIn.initialize(
          clientId: clientId,
          serverClientId: serverClientId,
        ),
      );

      // Trigger pilih akun Google
      final GoogleSignInAccount googleUser =
          await _googleSignIn.authenticate();

      // Ambil token dari akun Google
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      if (googleAuth.idToken == null) {
        print('Google Sign-In: idToken null, tidak bisa login Firebase');
        return null;
      }

      // Buat credential Firebase dari idToken Google
      final OAuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // Login ke Firebase
      final UserCredential userCred =
          await _auth.signInWithCredential(credential);

      return userCred.user;
    } catch (e) {
      print('Error signInWithGoogle: $e');
      return null;
    }
  }

  // 3. LOGOUT (Keluar) – sekalian logout Google
   // 3. LOGOUT (Keluar)
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print("Error Logout: $e");
    }
  }

  // Ambil user saat ini
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}