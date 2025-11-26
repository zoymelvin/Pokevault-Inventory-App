import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pokevault/screens/auth/login_screen.dart';
import 'firebase_options.dart';

// Import Wrapper (Polisi Lalu Lintas Login/Logout)
import 'screens/wrapper.dart';

void main() async {
  // 1. Pastikan binding Flutter siap
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Inisialisasi Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 3. Jalankan Aplikasi (Jangan lupa baris ini!)
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Menghilangkan pita "Debug" di pojok kanan atas
      title: 'PokeVault',
      
      // Tema Global Aplikasi
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.redAccent, // Warna dasar merah
          primary: Colors.redAccent,
        ),
        scaffoldBackgroundColor: Colors.white, // Default background putih sesuai request
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white, // Biar tidak berubah warna saat scroll
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black87),
          titleTextStyle: TextStyle(
            color: Colors.black87, 
            fontSize: 20, 
            fontWeight: FontWeight.bold
          ),
        ),
      ),

      // --- TITIK MULAI APLIKASI ---
      // Kita arahkan ke Wrapper.
      // Wrapper akan mengecek:
      // - Kalau belum login -> Tampilkan LoginScreen
      // - Kalau sudah login -> Tampilkan MainNav (Home)
      home: const Wrapper(), 
    );
  }
}