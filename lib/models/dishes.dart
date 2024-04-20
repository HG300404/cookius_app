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


  Dishes(
      { required this.dishID,
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

      });

  factory Dishes.fromJson(Map<String, dynamic> json, String id) {
    return Dishes(
      dishID: id,
      name: (json['name'] as String?) ?? 'default-value',
      type: (json['type'] as String?) ?? 'default-value',
      description: (json['description'] as String?) ?? 'default-value',
      time: (json['time'] as String?) ?? 'default-value',
      level: (json['level'] as String?) ?? 'default-value',
      calo: (json['calo'] as String?) ?? 'default-value',
      ingradient: (json['ingradient'] as String?) ?? 'default-value',
      recipe: (json['recipe'] as String?) ?? 'default-value',
      createdAt: json['createdAt'] as Timestamp? ?? Timestamp.now(),
      updatedAt: json['updatedAt'] as Timestamp? ?? Timestamp.now(),
      imageURL: (json['imageURL'] as String?) ?? 'default-value',
      g_p_l: (json['g_p_l'] as String?) ?? 'default-value',
    );
  }

  Map<String,dynamic> toJson(){
    return{
      'dishID': dishID,
      'name': name,
      'type': type ,
      'description': description ,
      'time': time ,
      'level': level ,
      'calo': calo ,
      'ingradient': ingradient,
      'recipe': recipe ,
      'createdAt': createdAt ,
      'updatedAt': updatedAt ,
      'imageURL': imageURL ,
      'g_p_l': g_p_l,
    };
  }
}