import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Ambil Data User yang sedang Login
    final User? user = FirebaseAuth.instance.currentUser;
    final String email = user?.email ?? "trainer@email.com";
    final String uid = user?.uid.substring(0, 5).toUpperCase() ?? "0000"; 

    return Scaffold(
      backgroundColor: Colors.white, // Revisi: Background Putih Polos
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // --- 1. PROFILE HEADER (AVATAR JM) ---
              Center(
                child: Column(
                  children: [
                    // Avatar Bulat "JM"
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[900], // Warna Gelap biar keren
                        border: Border.all(color: Colors.grey.shade200, width: 4),
                      ),
                      child: const Center(
                        child: Text(
                          "JM",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Nama & ID
                    const Text(
                      "Joy Melvin",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Trainer ID #$uid",
                      style: TextStyle(color: Colors.grey[500], fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    // Chip Favorite Element
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.bolt, color: Colors.amber, size: 16),
                          SizedBox(width: 4),
                          Text("Electric Favorite", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // --- 2. STATS ROW (STORED - FAVORITES - BADGES) ---
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // A. REAL DATA: Jumlah Stored Pokemon
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('pokemon_inventory')
                          .where('uid', isEqualTo: user?.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        // Hitung jumlah dokumen
                        String count = "0";
                        if (snapshot.hasData) {
                          count = snapshot.data!.docs.length.toString();
                        }
                        return _buildStatItem(Icons.folder, "Stored", count);
                      },
                    ),
                    // B. DUMMY DATA (Sesuai UI)
                    _buildStatItem(Icons.star, "Favorites", "2"),
                    _buildStatItem(Icons.verified, "Badges", "3"),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // --- 3. ACCOUNT DETAILS CARD ---
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Account Details", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(color: Colors.grey.shade100, blurRadius: 10, offset: const Offset(0, 5)),
                  ],
                ),
                child: Column(
                  children: [
                    _buildDetailRow("Email", email), // Real Data
                    const Divider(height: 24),
                    _buildDetailRow("Gender", "Male"), // Static (Sesuai Gambar)
                    const Divider(height: 24),
                    _buildDetailRow("Age", "21 years"), // Static (Sesuai Gambar)
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // --- 4. ACHIEVEMENTS GRID (Visual Only) ---
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Achievements", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ),
              const SizedBox(height: 12),
              
              // Grid Menu Kecil
              GridView.count(
                shrinkWrap: true, // Agar tidak error di dalam ScrollView
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3, // 3 Kotak per baris
                childAspectRatio: 1.2, // Rasio Lebar : Tinggi
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: const [
                  _AchievementCard(icon: Icons.catching_pokemon, label: "First Catch", color: Colors.redAccent),
                  _AchievementCard(icon: Icons.wb_incandescent, label: "Electric Fan", color: Colors.amber),
                  _AchievementCard(icon: Icons.nightlight_round, label: "Night Owl", color: Colors.purple),
                ],
              ),

              const SizedBox(height: 40),

              // --- 5. LOGOUT BUTTON ---
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    // Panggil fungsi Logout
                    await AuthService().signOut();
                    // Wrapper akan otomatis mendeteksi dan melempar ke Login Page
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF2E54), // Warna Merah Pink cerah
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    "Logout",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET KECIL (HELPER) ---

  // Widget untuk baris Email, Gender, Age
  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 14)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }

  // Widget untuk Stats (Stored, Favorite, Badges)
  Widget _buildStatItem(IconData icon, String label, String count) {
    return Column(
      children: [
        Icon(icon, color: Colors.amber, size: 28),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
        const SizedBox(height: 4),
        Text(count, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      ],
    );
  }
}

// Widget Khusus Card Achievement
class _AchievementCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _AchievementCard({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}