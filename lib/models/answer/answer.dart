import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

// Include generated file
part 'answer.g.dart';

// This is the class used by rest of your codebase
class Answer = _Answer with _$Answer;

abstract class _Answer with Store {
  @observable
  int id;

  @observable
  int question_id;

  @observable
  int title;

  @observable
  int order;

  @observable
  String? image;

  @observable
  bool selected; // Not in JSON, only for saving in datasource

  @observable
  bool is_enabled;

  @observable
  int creator_id;

  @observable
  String created_at;

  @observable
  String updated_at;

  _Answer({
    required this.id,
    required this.question_id,
    required this.title,
    required this.order,
    this.image,
    required this.is_enabled,
    required this.creator_id,
    required this.created_at,
    required this.updated_at,
    this.selected = false,
  });

  @computed
  bool get isSelected => selected;

  @action
  void setSelected(bool value) {
    selected = value;
  }

  @action
  void toggleSelected() {
    selected = !selected;
  }

  @computed
  Image get getImageWidget => Image.network(image!);

  @computed
  String get getImage => image!;

  Map<String, dynamic> toMap() => {
        "id": id,
        "question_id": question_id,
        "title": title,
        "order": order,
        "image": image,
        "is_enabled": is_enabled ? 1 : 0,
        "creator_id": creator_id,
        "created_at": created_at,
        "updated_at": updated_at,
        "selected": selected,
      };
}

class AnswerFactory {
  Answer fromMap(Map<String, dynamic> json) {
    return Answer(
      id: json["id"],
      question_id: json["question_id"],
      title: json["title"],
      order: json["order"],
      image: json["image"],
      is_enabled: json["is_enabled"] == 1 ? true : false,
      creator_id: json["creator_id"],
      created_at: json["created_at"],
      updated_at: json["updated_at"],
      selected: json["selected"] ?? false,
    );
  }
}
