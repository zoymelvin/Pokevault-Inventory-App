import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

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

  // 2. LOGIN (Masuk) -> Pastikan bagian ini ada!
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