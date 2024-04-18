import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';

class Users {
  final String userID;
  final String username;
  final String ? passwordHash;
  final String ? phone;
  final String ? email;
  final String ? createdAt;
  final String userType;
  final String ? imageURL;

  const Users(
      { required this.userID,
        required this.username,
        this.passwordHash,
        this.phone,
        this.email,
        this.createdAt,
        required this.userType,
        this.imageURL
      });
}