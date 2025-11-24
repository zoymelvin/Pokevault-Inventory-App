import 'package:cloud_firestore/cloud_firestore.dart';

class PokemonModel {
  final String id;   
  final String name;
  final String type;
  final int level;
  final int cp;
  final String imageUrl;
  final String uid;
  final Timestamp? createdAt;

  PokemonModel({
    this.id = '',
    required this.name,
    required this.type,
    required this.level,
    required this.cp,
    required this.imageUrl,
    required this.uid,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type,
      'level': level,
      'cp': cp,
      'image_url': imageUrl,
      'uid': uid,
      'created_at': createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  factory PokemonModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return PokemonModel(
      id: doc.id,
      name: data['name'] ?? 'Unknown',
      type: data['type'] ?? 'Normal',
      level: data['level'] ?? 0,
      cp: data['cp'] ?? 0,
      imageUrl: data['image_url'] ?? '',
      uid: data['uid'] ?? '',
      createdAt: data['created_at'] as Timestamp?,
    );
  }
}