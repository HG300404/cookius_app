import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';

class Dishes {
  final String dishID;
  final String name;
  final String type;
  final String description;
  final String time;
  final String level;
  final String calo;
  final String ingradient;
  final String recipe;
  final Timestamp createdAt;
  final Timestamp updatedAt;
  final String imageURL;
  final String g_p_l;
  bool isSelected;
  bool isFavorited;

  Dishes({
    required this.dishID,
    required this.name,
    required this.type,
    required this.description,
    required this.time,
    required this.level,
    required this.calo,
    required this.ingradient,
    required this.recipe,
    required this.createdAt,
    required this.updatedAt,
    required this.imageURL,
    required this.g_p_l,
    this.isFavorited = false, // Assigned default value
    this.isSelected = false,  // Assigned default value
  });

  factory Dishes.fromJson(Map<String, dynamic> json, String id) {
    return Dishes(
      dishID: id,
      name: json['name'] ?? 'default-value',
      type: json['type'] ?? 'default-value',
      description: json['description'] ?? 'default-value',
      time: json['time'] ?? 'default-value',
      level: json['level'] ?? 'default-value',
      calo: json['calo'] ?? 'default-value',
      ingradient: json['ingradient'] ?? 'default-value',
      recipe: json['recipe'] ?? 'default-value',
      createdAt: json['createdAt'] ?? Timestamp.now(),
      updatedAt: json['updatedAt'] ?? Timestamp.now(),
      imageURL: json['imageURL'] ?? 'default-value',
      g_p_l: json['g_p_l'] ?? 'default-value',
      isFavorited: json['isFavorited'] ?? false,
      isSelected: json['isSelected'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dishID': dishID,
      'name': name,
      'type': type,
      'description': description,
      'time': time,
      'level': level,
      'calo': calo,
      'ingradient': ingradient,
      'recipe': recipe,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'imageURL': imageURL,
      'g_p_l': g_p_l,
      'isFavorited': isFavorited,
      'isSelected': isSelected,
    };
  }
}