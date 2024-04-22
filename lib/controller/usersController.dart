import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookius_app/models/users.dart';
import 'package:crypto/crypto.dart';

class usersController {
  final _firestore = FirebaseFirestore.instance;
  late final CollectionReference usersRef;

  usersController(){
    usersRef = _firestore.collection('users');
  }

  Stream<QuerySnapshot> getAll(){
    return usersRef.snapshots();
  }

  Future<DocumentSnapshot> getID(String id){
    return usersRef.doc(id).get();
  }

  void addUser(Users user) async {
    await usersRef.add(user.toJson());
  }

  Future<bool> updateUser(Users user, String id) async{
    try {
      await usersRef.doc(id).update(user.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteUserById(String userId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      await firestore.collection('users').doc(userId).delete();
      return true;
    } catch (e) {
      return true;
    }
  }

  String hashPassword(String password) {
    // Convert password string to a list of bytes
    final bytes = utf8.encode(password);

    // Hash the password using SHA-256
    final digest = sha256.convert(bytes);

    // Return the hashed password in hexadecimal format
    return digest.toString();
  }
}