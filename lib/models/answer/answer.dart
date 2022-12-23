import 'package:boilerplate/models/title/title.dart';
import 'package:flutter/material.dart';

class Answer {
  int id;
  int question_id;
  TechnicalName title;
  int order;
  String? image;
  bool selected;
  bool is_enabled;
  String creator_id;
  String created_at;
  String updated_at;

  Answer({
    required this.id,
    required this.question_id,
    required this.title,
    required this.order,
    this.image,
    this.selected = false,
    required this.is_enabled,
    required this.creator_id,
    required this.created_at,
    required this.updated_at,
  });

  bool get isSelected{
    return selected;
  }

  void setSelected(bool value){
    selected = value;
  }

  void toggleSelected(){
    selected = !selected;
  }

  Image getImage(){
    return Image.network(image!);
  }

  String get getTitle{
    return title.string;
  }

  factory Answer.fromMap(Map<String, dynamic> json) {
    //   image: Endpoints.domain +
    //       '/api/app/answers/img/${json["image"].toString().replaceAll(
    //           Endpoints.domain + '/api/app/answers/img/', '')}',
    return Answer(
      id: json["id"],
      question_id: json["question_id"],
      title: TechnicalName.fromMap(json["title"]),
      order: json["order"],
      image: json["image"],
      selected: json["selected"] == 1 ? true : false,
      is_enabled: json["is_enabled"] == 1 ? true : false,
      creator_id: json["creator_id"],
      created_at: json["created_at"],
      updated_at: json["updated_at"],
    );
  }

  Map<String, dynamic> toMap() => {
    "id": id,
    "question_id": question_id,
    "title": title.toMap(),
    "order": order,
    "image": image,
    "selected": selected ? 1 : 0,
    "is_enabled": is_enabled ? 1 : 0,
    "creator_id": creator_id,
    "created_at": created_at,
    "updated_at": updated_at,
  };

}