import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/pokemon_model.dart';

class DetailScreen extends StatefulWidget {
  final PokemonModel pokemon;
  final String trainerName;

  const DetailScreen({
    super.key,
    required this.pokemon,
    this.trainerName = "Trainer",
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool isFav = false;
  int _activeTab = 0;

  Color _getTypeBaseColor(String type) {
    switch (type.toLowerCase()) {
      case 'fire':
        return Colors.orange;
      case 'water':
        return Colors.lightBlue;
      case 'grass':
        return Colors.green;
      case 'electric':
        return Colors.amber;
      case 'poison':
        return Colors.purple;
      case 'ghost':
        return Colors.deepPurple;
      case 'psychic':
        return Colors.pink;
      case 'fighting':
        return Colors.redAccent;
      case 'steel':
        return Colors.blueGrey;
      case 'flying':
        return Colors.indigo;
      case 'rock':
        return Colors.brown;
      case 'ice':
        return Colors.cyan;
      case 'dragon':
        return Colors.purpleAccent;
      case 'dark':
        return Colors.black54;
      case 'fairy':
        return Colors.pinkAccent;
      default:
        return Colors.grey;
    }
  }

  String _primaryType(String type) {
    return type.split("/").first.trim().split(" ").first.trim();
  }

  List<String> _splitTypes(String type) {
    return type
        .split("/")
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  String _formatMonthYear(Timestamp? ts) {
    if (ts == null) return "—";
    final d = ts.toDate();
    const months = [
      "Jan","Feb","Mar","Apr","May","Jun",
      "Jul","Aug","Sep","Oct","Nov","Dec"
    ];
    return "${months[d.month - 1]} ${d.year}";
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.pokemon;
    final primary = _primaryType(p.type);
    final baseColor = _getTypeBaseColor(primary);

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 240,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          baseColor.withOpacity(0.35),
                          baseColor.withOpacity(0.15),
                          Colors.white,
                        ],
                      ),
                    ),
                  ),

                  Positioned.fill(
                    child: Hero(
                      tag: p.id,
                      child: Image.network(
                        p.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (c, o, s) => Container(
                          color: Colors.black12,
                          child: const Center(
                            child: Icon(Icons.broken_image, size: 100, color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Positioned.fill(
                    child: Container(
                      color: Colors.white.withOpacity(0.08),
                    ),
                  ),

                  // back button pill
                  Positioned(
                    left: 16,
                    top: 12,
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(999),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: Colors.black12),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            )
                          ],
                        ),
                        child: const Icon(
                          Icons.arrow_back
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            p.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () => setState(() => isFav = !isFav),
                          borderRadius: BorderRadius.circular(999),
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.black12),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6,
                                  offset: Offset(0, 2),
                                )
                              ],
                            ),
                            child: Icon(
                              Icons.star,
                              color: isFav ? Colors.amber : Colors.black26,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    // type badges
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: _splitTypes(p.type).map((t) {
                        final c = _getTypeBaseColor(t);
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: c.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(color: c.withOpacity(0.35)),
                          ),
                          child: Text(
                            t,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: c,
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 14),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatItem("Level", p.level.toString(), Icons.bar_chart, Colors.green,),
                        _buildStatItem("CP", p.cp.toString(), Icons.bolt, Colors.orangeAccent),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // Entry Info title
                    const Text(
                      "Entry Info",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 8),

                    Row(
                      children: [
                        Expanded(
                          child: _InfoPill(
                            label: "Captured",
                            value: _formatMonthYear(p.createdAt),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _InfoPill(
                            label: "Pokemon ID",
                            value: "#${p.id.substring(0, p.id.length >= 4 ? 4 : p.id.length)}",
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.black12),
                      ),
                      child: Text(
                        "Owner: ${widget.trainerName}\n"
                        "This entry stores your captured Pokémon in PokeVault. "
                        "Level and CP can be updated anytime as it grows stronger.",
                        style: const TextStyle(fontSize: 12, color: Colors.black54, height: 1.4),
                      ),
                    ),

                    const SizedBox(height: 108),

                    // Release button only
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Release clicked")),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFEF2F2),
                          foregroundColor: const Color(0xFFBE123C),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                            side: const BorderSide(color: Color(0xFFFECACA)),
                          ),
                        ),
                        child: const Text(
                          "Release",
                          style: TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }

  // stat item mirip punyamu
  Widget _buildStatItem(
  String label,
  String value,
  IconData icon,
  Color iconColor,
  ) {
    return Column(
      children: [
        Icon(icon, color: iconColor),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.grey[500])),
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class _InfoPill extends StatelessWidget {
  final String label;
  final String value;

  const _InfoPill({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 1)),
        ],
      ),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.black45)),
          const Spacer(),
          Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}
