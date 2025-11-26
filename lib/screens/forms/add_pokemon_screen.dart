import 'dart:math'; // Untuk fitur Random Number
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/pokemon_model.dart';
import '../../services/database_service.dart';

class AddPokemonScreen extends StatefulWidget {
  const AddPokemonScreen({super.key});

  @override
  State<AddPokemonScreen> createState() => _AddPokemonScreenState();
}

class _AddPokemonScreenState extends State<AddPokemonScreen> {
  // 1. Controller untuk Input
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  // 2. State Variables
  bool _isLoading = false;
  String _selectedType = 'Fire'; // Default Value

  // List Tipe Pokemon
  final List<String> _types = [
    'Fire', 'Water', 'Grass', 'Electric', 'Psychic', 
    'Ice', 'Dragon', 'Dark', 'Fairy', 'Normal', 
    'Fighting', 'Flying', 'Poison', 'Ground', 'Rock', 
    'Ghost', 'Bug', 'Steel'
  ];

  // Helper: Warna Chip kecil di sebelah dropdown (Opsional visual)
  Color _getTypeColor(String type) {
    switch (type) {
      case 'Fire': return Colors.orange;
      case 'Water': return Colors.blue;
      case 'Grass': return Colors.green;
      case 'Electric': return Colors.amber;
      default: return Colors.grey;
    }
  }

  // --- FUNGSI UTAMA: CATCH & SAVE ---
  void _catchPokemon() async {
    // Validasi: Nama & Gambar wajib diisi
    if (_nameController.text.isEmpty || _imageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nama dan URL Gambar wajib diisi!")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1. LOGIKA RANDOM STATS
      final random = Random();
      int randomLevel = random.nextInt(100) + 1; // Level 1 - 100
      int randomCP = random.nextInt(1900) + 1000; // CP 100 - 2000

      // 2. Ambil UID User yang sedang login
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("User tidak ditemukan!");

      // 3. Bungkus Data ke Model
      PokemonModel newPokemon = PokemonModel(
        name: _nameController.text.trim(),
        type: _selectedType,
        level: randomLevel,
        cp: randomCP,
        imageUrl: _imageController.text.trim(),
        uid: user.uid,
      );

      // 4. Kirim ke Firestore
      await DatabaseService().addPokemon(newPokemon);

      // 5. Sukses! Reset Form
      _nameController.clear();
      _imageController.clear();
      setState(() => _selectedType = 'Fire');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Gotcha! ${newPokemon.name} (Lv $randomLevel) tertangkap!"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal: $e"), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Fungsi Cancel: Bersihkan form
  void _onCancel() {
    _nameController.clear();
    _imageController.clear();
    FocusScope.of(context).unfocus(); // Tutup keyboard
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- HEADER (Sesuai Desain) ---
              Row(
                children: [
                  const Icon(Icons.catching_pokemon, size: 48, color: Colors.redAccent),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Catch New Pokemon", 
                        style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                      const Text("Register New Catch", 
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 30),

              // --- FORM: NAMA POKEMON ---
              const Text("Nama Pokemon", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 8),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: "Pikachu",
                  hintStyle: TextStyle(color: Colors.grey[300]),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // --- FORM: TIPE ELEMEN ---
              const Text("Tipe Elemen", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedType,
                          icon: const Icon(Icons.arrow_drop_down),
                          items: _types.map((String type) {
                            return DropdownMenuItem<String>(
                              value: type,
                              child: Text(type),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() => _selectedType = newValue!);
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Visual Chip Kecil (Mirip desain "Fire" di kanan)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                      color: _getTypeColor(_selectedType).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _selectedType,
                      style: TextStyle(
                        color: _getTypeColor(_selectedType),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),

              // --- FORM: GAMBAR POKEMON (URL) ---
              const Text("Gambar Pokemon", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 8),
              
              // Input URL (Menggantikan tombol Upload tapi tampilan mirip)
              TextField(
                controller: _imageController,
                onChanged: (v) => setState(() {}), // Refresh preview saat ketik
                decoration: InputDecoration(
                  hintText: "Paste URL Image here...",
                  prefixIcon: const Icon(Icons.image, color: Colors.orangeAccent),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(style: BorderStyle.solid),
                  ),
                  enabledBorder: OutlineInputBorder( // Efek garis putus-putus ala "Upload"
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // --- PREVIEW IMAGE BOX ---
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F3F8), // Warna abu muda kebiruan
                  borderRadius: BorderRadius.circular(16),
                ),
                child: _imageController.text.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          _imageController.text,
                          fit: BoxFit.contain,
                          errorBuilder: (c, o, s) => const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.broken_image, color: Colors.grey),
                              Text("Link Error", style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("No image selected", 
                            style: TextStyle(color: Colors.blueGrey[200], fontSize: 14)),
                        ],
                      ),
              ),
              
              const SizedBox(height: 40),

              // --- ACTION BUTTONS ---
              Row(
                children: [
                  // Tombol Cancel
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _onCancel,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Cancel", 
                        style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // Tombol Catch
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _catchPokemon,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.redAccent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white))
                        : const Text("Catch!", 
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
              
              // Area Tip (Hint) DIHAPUS sesuai request
            ],
          ),
        ),
      ),
    );
  }
}