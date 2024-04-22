import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';

class Users {
  final String userID;
  final String userName;
  final String ? password;
  final String ? phone;
  final String ? email;
  final Timestamp ? createdAt;
  final Timestamp ? updatedAt;
  final String userType;
  final String ? imageURL;

  const Users(
      { required this.userID,
        required this.userName,
        this.password,
        this.phone,
        this.email,
        this.createdAt,
        this.updatedAt,
        required this.userType,
        this.imageURL
      });
  factory Users.fromJson(Map<String, dynamic> json, String id) {
    return Users(
      userID: id,
      userName: (json['userName'] as String?) ?? 'default-value',
      password: (json['passwordHash'] as String?) ?? 'default-value',
      phone: (json['phone'] as String?) ?? 'default-value',
      email: (json['email'] as String?) ?? 'default-value',
      createdAt: json['createdAt'] as Timestamp? ?? Timestamp.now(),
      updatedAt: json['updatedAt'] as Timestamp? ?? Timestamp.now(),
      userType: (json['userType'] as String?) ?? 'default-value',
      imageURL: (json['imageURL'] as String?) ?? 'default-value',
    );
  }

  Map<String,dynamic> toJson(){
    return{
      'userID': userID,
      'userName': userName,
      'passwordHash': password ,
      'phone': phone ,
      'email': email ,
      'createdAt': createdAt ,
      'updatedAt': updatedAt ,
      'userType': userType,
      'imageURL': imageURL ,
    };
  }
}