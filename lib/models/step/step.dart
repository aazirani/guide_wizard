import 'package:boilerplate/models/title/title.dart';

class Step {
  int id;
  Title name;
  Title description;
  int order;
  String type;
  int creator_id;
  String created_at;
  String updated_at;

  Step({
    required this.id,
    required this.name,
    required this.description,
    required this.order,
    required this.type,
    required this.creator_id,
    required this.created_at,
    required this.updated_at,
  });

  factory Step.fromMap(Map<String, dynamic> json) {
    return Step(
      id: json["id"],
      name: Title.fromMap(json["name"]),
      description: Title.fromMap(json["description"]),
      order: json["order"],
      type: json["type"],
      creator_id: json["creator_id"],
      created_at: json["created_at"],
      updated_at: json["updated_at"],
    );
  }

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "description": description,
    "order": order,
    "type": type,
    "creator_id": creator_id,
    "created_at": created_at,
    "updated_at": updated_at,
  };

}