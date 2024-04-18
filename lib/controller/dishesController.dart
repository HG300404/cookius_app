import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookius_app/models/dishes.dart';
import 'package:flutter/material.dart';

class dishesController {
  final _firestore = FirebaseFirestore.instance;
  late final CollectionReference dishesRef;

  // dishesController(){
  //   dishesRef = _firestore.collection('dishes').withConverter<Dishes>(
  //       fromFirestore: (snapshots, _) => Dishes.fromJson(
  //         snapshots.data()!,
  //       ),
  //       toFirestore: (dish, _) => dish.toJson());
  // }
  dishesController(){
    dishesRef = _firestore.collection('dishes');
  }

  Stream<QuerySnapshot> getAll(){
    return dishesRef.snapshots();
  }

  void addDish(Dishes dish) async {
    await dishesRef.add(dish.toJson());
  }

  void updateDish(Dishes dish, String id) async{
    await dishesRef.doc(id).update(dish.toJson());
  }
}
