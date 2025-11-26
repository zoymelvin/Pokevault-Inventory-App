import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. AMBIL USER & CEK NULL (PERBAIKAN KEAMANAN)
    final User? user = FirebaseAuth.instance.currentUser;

    // Jika user sedang proses logout (null), tampilkan loading agar tidak error
    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final String email = user.email ?? "trainer@email.com";
    
    // Safety: Cek panjang UID sebelum substring agar tidak crash
    final String uid = user.uid.length >= 5 
        ? user.uid.substring(0, 5).toUpperCase() 
        : user.uid.toUpperCase();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // --- HEADER PROFILE ---
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 100, height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[900],
                        border: Border.all(color: Colors.grey.shade200, width: 4),
                      ),
                      child: const Center(
                        child: Text("JM", style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text("Joy Melvin", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    Text("Trainer ID #$uid", style: TextStyle(color: Colors.grey[500], fontSize: 14)),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: Colors.amber.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
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

              // --- STATS ROW (BAGIAN YANG MENGHITUNG FAVORIT) ---
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // A. Total Stored
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('pokemon_inventory')
                          .where('uid', isEqualTo: user.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        String count = "0";
                        if (snapshot.hasData) count = snapshot.data!.docs.length.toString();
                        return _buildStatItem(Icons.folder, "Stored", count);
                      },
                    ),

                    // B. Favorites (INI YANG PERLU DIGANTI AGAR BERTAMBAH OTOMATIS)
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('pokemon_inventory')
                          .where('uid', isEqualTo: user.uid)
                          .where('is_favorite', isEqualTo: true) // Filter Data Favorit
                          .snapshots(),
                      builder: (context, snapshot) {
                        String favCount = "0";
                        // Ambil jumlah dokumen yang favorite-nya true
                        if (snapshot.hasData) favCount = snapshot.data!.docs.length.toString();
                        return _buildStatItem(Icons.star, "Favorites", favCount);
                      },
                    ),

                    // C. Badges (Dummy)
                    _buildStatItem(Icons.verified, "Badges", "3"),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // --- ACCOUNT DETAILS ---
              const Align(alignment: Alignment.centerLeft, child: Text("Account Details", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [BoxShadow(color: Colors.grey.shade100, blurRadius: 10, offset: const Offset(0, 5))],
                ),
                child: Column(
                  children: [
                    _buildDetailRow("Email", email),
                    const Divider(height: 24),
                    _buildDetailRow("Gender", "Male"),
                    const Divider(height: 24),
                    _buildDetailRow("Age", "21 years"),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // --- ACHIEVEMENTS ---
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Achievements", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ),
              const SizedBox(height: 12),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                childAspectRatio: 1.2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: const [
                  _AchievementCard(icon: Icons.catching_pokemon, label: "First Catch", color: Colors.redAccent),
                  _AchievementCard(icon: Icons.wb_incandescent, label: "Electric Fan", color: Colors.amber),
                  _AchievementCard(icon: Icons.nightlight_round, label: "Night Owl", color: Colors.purple),
                ],
              ),

              const SizedBox(height: 40),

              // --- LOGOUT BUTTON ---
              SizedBox(
                width: double.infinity, height: 50,
                child: ElevatedButton(
                  onPressed: () async => await AuthService().signOut(),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF2E54), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: const Text("Logout", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 14)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }

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