import 'package:flutter/cupertino.dart';

class Title {
  int id;
  String technical_name;
  int creator_id;
  String created_at;
  String updated_at;

  Title({
    required this.id,
    required this.technical_name,
    required this.creator_id,
    required this.created_at,
    required this.updated_at,
  });

  factory Title.fromMap(Map<String, dynamic> json) {
    return Title(
      id: json["id"],
      technical_name: json["technical_name"],
      creator_id: json["creator_id"],
      created_at: json["created_at"],
      updated_at: json["updated_at"],
    );
  }

  Map<String, dynamic> toMap() => {
    "id": id,
    "technical_name": technical_name,
    "creator_id": creator_id,
    "created_at": created_at,
    "updated_at": updated_at,
  };

}