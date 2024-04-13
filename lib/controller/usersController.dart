import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookius_app/models/users.dart';
import 'package:crypto/crypto.dart';

class usersController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  //Add new user
  void addUser(Users user) async {
    // Tạo một Document mới với ID tự động sinh ra.
    DocumentReference docRef = await firestore.collection('users').add({
      'username': user.username,
      'passwordHash': hashPassword(user.passwordHash),
      'phone': user.phone,
      'email': user.email,
      'userType': user.userType,
      'createdAt': FieldValue.serverTimestamp(),
    });

    // ID tự động được tạo ra cho document này là docRef.id, bạn có thể lưu lại nếu cần
    print("User added with ID: ${docRef.id}");
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