import 'package:flutter/material.dart';
import '../models/pokemon_model.dart';

class PokemonCard extends StatelessWidget {
  final PokemonModel pokemon;
  final VoidCallback onDelete; // Fungsi yang dipanggil saat tombol hapus ditekan

  const PokemonCard({
    super.key,
    required this.pokemon,
    required this.onDelete,
  });

  // Helper: Menentukan warna chip berdasarkan Tipe
  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'fire': return Colors.orangeAccent;
      case 'water': return Colors.blueAccent;
      case 'grass': return Colors.green;
      case 'electric': return Colors.amber;
      case 'poison': return Colors.purpleAccent;
      case 'ghost': return Colors.deepPurple;
      case 'psychic': return Colors.pinkAccent;
      case 'fighting': return Colors.red;
      case 'steel': return Colors.blueGrey;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20), // Sudut membulat
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. FOTO POKEMON
          Expanded(
            flex: 3,
            child: SizedBox(
              width: double.infinity,
              child:  SizedBox(
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: Image.network(
                    pokemon.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, eror, StackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        child: const Center(
                          child: Icon(Icons.broken_image, color: Colors.grey)),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                          :null,
                          strokeWidth: 2,
                        ),
                      );
                    }
                  ),
                )
              ),
            )
          ),

          // 2. INFORMASI
          Expanded(
            flex: 2, // Proporsi area teks
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 8, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Baris Nama & Tombol Delete
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          pokemon.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Tombol Release (Delete)
                      InkWell(
                        onTap: onDelete,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.redAccent),
                          ),
                          child: const Icon(
                            Icons.delete_outline, // Atau Icons.close
                            size: 16,
                            color: Colors.redAccent,
                          ),
                        ),
                      )
                    ],
                  ),

                  // Type Chip (Kapsul Warna)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getTypeColor(pokemon.type).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _getTypeColor(pokemon.type).withOpacity(0.5),
                        width: 0.5
                      )
                    ),
                    child: Text(
                      pokemon.type,
                      style: TextStyle(
                        color: _getTypeColor(pokemon.type).withAlpha(255), // Warna teks lebih pekat
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Level & CP
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Lv ${pokemon.level}",
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      Text(
                        "CP ${pokemon.cp}",
                        style: const TextStyle(
                          color: Colors.black87, 
                          fontWeight: FontWeight.bold, 
                          fontSize: 12
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}