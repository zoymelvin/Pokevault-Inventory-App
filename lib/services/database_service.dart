import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pokevault/models/pokemon_model.dart';

class DatabaseService {
  final CollectionReference _pokemonRef =
  FirebaseFirestore.instance.collection('pokemon_inventory');

  Future<void> addPokemon(PokemonModel pokemon) async {
    try {
      await _pokemonRef.add(pokemon.toMap());
    } catch (e) {
      print("Gagal menambhkan pokemon: $e");
      rethrow;
    }
  }

  // Mengambil data
  Stream<List<PokemonModel>> getPokemonStream(String uid){
    return _pokemonRef
      .where('uid', isEqualTo: uid)
      //.orderBy('created_at', descending: true)
      .snapshots()
      .map((snapshot){
    return snapshot.docs.map((doc) {
        return PokemonModel.fromSnapshot(
            doc as DocumentSnapshot<Map<String, dynamic>>);
      }).toList();
    });
  }

  // delete data
  Future<void> deletePokemon (String docId) async {
    try {
      await _pokemonRef.doc(docId).delete();
    }catch (e){
      print("Gagal melepas: $e");
      rethrow;
    }
  }

  // Fungsi menambhkan Pokemon ke favorite

  Future <void> togglefavorite(String docId, bool currentStatus) async {
    try {
      await _pokemonRef.doc(docId).update({
        'is_favorite': !currentStatus,
      });
    } catch (e) {
      print("Gagal menambhkan pokemon ke favorite");
      rethrow;
    }
  }
}