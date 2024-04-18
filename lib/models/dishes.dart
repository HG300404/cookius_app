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
        required this.imageURL,
        required this.g_p_l,

      });

  // Dishes.fromJson(Map<String, Object?> json) :
  //       this(dishID: json['dishID']! as String? ?? 'default-dishID',
  //       name: json['name']! as String ? ?? 'default-dishID',
  //       type: json['type']! as String? ?? 'default-dishID',
  //       description: json['description']! as String? ?? 'default-dishID',
  //       time: json['time']! as String? ?? 'default-dishID',
  //       level: json['level']! as String? ?? 'default-dishID',
  //       calo: json['calo']! as String? ?? 'default-dishID',
  //       ingradient: json['ingradient']! as String? ?? 'default-dishID',
  //       recipe: json['recipe']! as String? ?? 'default-dishID',
  //       createdAt: json['createdAt']! as Timestamp,
  //       imageURL: json['imageURL']! as String? ?? 'default-dishID',
  //       g_p_l: json['g_p_l']! as String? ?? 'default-dishID'
  //     );
  factory Dishes.fromJson(Map<String, dynamic> json, String id) {
    return Dishes(
      dishID: id,
      name: json['name']! as String ? ?? 'default-dishID',
            type: json['type']! as String? ?? 'default-dishID',
            description: json['description']! as String? ?? 'default-dishID',
            time: json['time']! as String? ?? 'default-dishID',
            level: json['level']! as String? ?? 'default-dishID',
            calo: json['calo']! as String? ?? 'default-dishID',
            ingradient: json['ingradient']! as String? ?? 'default-dishID',
            recipe: json['recipe']! as String? ?? 'default-dishID',
            createdAt: json['createdAt']! as Timestamp,
            imageURL: json['imageURL']! as String? ?? 'default-dishID',
            g_p_l: json['g_p_l']! as String? ?? 'default-dishID'
    );
  }
  Dishes copyWith({
    String? dishID,
    String? name,
    String? type,
    String? description,
    String? time,
    String? level,
    String? calo,
    String? ingradient,
    String? recipe,
    Timestamp? createdAt,
    String? imageURL,
    String? g_p_l,
}) {
    return Dishes(dishID: dishID ?? this.dishID,
        name: name ?? this.name,
        type: type ?? this.type,
        description: description ?? this.description,
        time: time ?? this.time,
        level: level ?? this.level,
        calo: calo ?? this.calo,
        ingradient: ingradient ?? this.ingradient,
        recipe: recipe ?? this.recipe,
        createdAt: createdAt ?? this.createdAt,
        imageURL: imageURL ?? this.imageURL,
        g_p_l: g_p_l ?? this.g_p_l);
  }

  // Map<String,Object?> toJson(){
  //   return{
  //     'dishID': dishID,
  //     'name': name,
  //     'type': type ,
  //     'description': description ,
  //     'time': time ,
  //     'level': level ,
  //     'calo': calo ,
  //     'ingradient': ingradient,
  //     'recipe': recipe ,
  //     'createdAt': createdAt ,
  //     'imageURL': imageURL ,
  //     'g_p_l': g_p_l,
  //   };
  // }
  // Map<String,object?> toJson(){
  //   return{
  //     'dishID': dishID,
  //     'name': name,
  //     'type': type ,
  //     'description': description ,
  //     'time': time ,
  //     'level': level ,
  //     'calo': calo ,
  //     'ingradient': ingradient,
  //     'recipe': recipe ,
  //     'createdAt': createdAt ,
  //     'imageURL': imageURL ,
  //     'g_p_l': g_p_l,
  //   };
  // }
}