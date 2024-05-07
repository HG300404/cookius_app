import 'package:cloud_firestore/cloud_firestore.dart';

class Favorite {
  final String favoriteID;
  final String userID;
  final String dishID;
  final Timestamp? createdAt;
  final Timestamp? updatedAt;

  const Favorite({
    required this.favoriteID,
    required this.userID,
    required this.dishID,
    this.createdAt,
     this.updatedAt,
  });

  factory Favorite.fromJson(Map<String, dynamic> json, String id) {
    return Favorite(
      favoriteID: id,
      userID: (json['userID'] as String?) ?? 'default-userID',
      dishID: (json['dishID'] as String?) ?? 'default-dishID',
      createdAt: json['createdAt'] as Timestamp? ?? Timestamp.now(),
      updatedAt: json['updatedAt'] as Timestamp? ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'favoriteID': favoriteID,
      'userID': userID,
      'dishID': dishID,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}