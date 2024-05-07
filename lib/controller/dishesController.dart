import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookius_app/models/dishes.dart';
import 'package:flutter/material.dart';

class dishesController {
  final _firestore = FirebaseFirestore.instance;
  late final CollectionReference dishesRef;

  dishesController(){
    dishesRef = _firestore.collection('dishes');
  }

  Stream<QuerySnapshot> getAll(){
    return dishesRef.snapshots();
  }

  Future<DocumentSnapshot> getID(String id){
    return dishesRef.doc(id).get();
  }

  void addDish(Dishes dish) async {
    await dishesRef.add(dish.toJson());
  }

  Future<bool> updateDish(Dishes dish, String id) async{
    try {
      await dishesRef.doc(id).update(dish.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteDishById(String dishId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      await firestore.collection('dishes').doc(dishId).delete();
      return true;
    } catch (e) {
      return true;
    }
  }
  Stream<QuerySnapshot> getDishesByType(String type) {
    return dishesRef.where('type', isEqualTo: type).snapshots();
  }

  Future<void> toggleFavoriteStatus(String dishId, bool isCurrentlyFavorited) async {
    // Truy cập đến document của món ăn bằng dishId
    DocumentReference dishRef = _firestore.collection('dishes').doc(dishId);
    return await dishRef.update({
      'isFavorited': !isCurrentlyFavorited,
    });
  }

}
