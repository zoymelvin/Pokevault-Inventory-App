import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pokevault/screens/home/detail_screen.dart';
import '../../models/pokemon_model.dart';
import '../../services/database_service.dart';
import '../../widgets/pokemon_card.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ambil ID user yang sedang login
    final user = FirebaseAuth.instance.currentUser;
    final String uid = user?.uid ?? '';

    // CEK UKURAN LAYAR (RESPONSIVE LOGIC)
    // Jika lebar layar > 600, anggap Tablet (3 kolom), selain itu HP (2 kolom)
    final double screenWidth = MediaQuery.of(context).size.width;
    final int crossAxisCount = screenWidth > 600 ? 3 : 2;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FA), // Background agak abu muda biar kartu pop-up
      body: SafeArea(
        child: Column(
          children: [
            // --- HEADER & SEARCH BAR (Visual Saja) ---
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("PokeVault", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      // ID User kecil di pojok kanan
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            color: Colors.white, borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          children: [
                            const Icon(Icons.bolt, color: Colors.orange, size: 16),
                            const SizedBox(width: 4),
                            Text("ID #${uid.substring(0, 4)}", // Tampilkan 4 huruf ID saja
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Search Bar (Visual)
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Search Pokemon...",
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    ),
                  ),
                ],
              ),
            ),

            // --- LIST INVENTORY (STREAM BUILDER) ---
            Expanded(
              child: StreamBuilder<List<PokemonModel>>(
                // Memanggil fungsi 'getPokemonStream' dari DatabaseService
                stream: DatabaseService().getPokemonStream(uid),
                builder: (context, snapshot) {
                  // 1. Loading State
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // 2. Error State
                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }

                  // 3. Data Kosong
                  final pokemonList = snapshot.data ?? [];
                  if (pokemonList.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inbox_outlined, size: 60, color: Colors.grey[300]),
                          const SizedBox(height: 10),
                          Text("PC Box is Empty", style: TextStyle(color: Colors.grey[400])),
                        ],
                      ),
                    );
                  }

                  // 4. Data Ada -> Tampilkan Grid
                  return GridView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    // LOGIKA GRID: 2 Baris (HP) atau 3 Baris (Tablet)
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount, 
                      childAspectRatio: 0.70, // Rasio Lebar : Tinggi kartu (0.7 agak tinggi)
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: pokemonList.length,
                    itemBuilder: (context, index) {
                      final pokemon = pokemonList[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailScreen(pokemon: pokemon),
                              ),
                            );
                        },
                        child: PokemonCard(
                          pokemon: pokemon,
                        onDelete: () {
                          
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Release Pokemon?"),
                              content: Text("Are you sure you want to release ${pokemon.name}?"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    Navigator.pop(context); // Tutup dialog
                                    // Panggil fungsi hapus database
                                    await DatabaseService().deletePokemon(pokemon.id);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Bye bye, ${pokemon.name}!")),
                                    );
                                  },
                                  child: const Text("Release", style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          );
                        },
                        )
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}