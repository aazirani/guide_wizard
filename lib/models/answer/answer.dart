import 'package:boilerplate/data/network/constants/endpoints.dart';

class Answer {
  int id;
  int question_id;
  List<dynamic> title;
  int order;
  String? image;
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
    required this.is_enabled,
    required this.creator_id,
    required this.created_at,
    required this.updated_at,
  });

  factory Answer.fromMap(Map<String, dynamic> json) {
    // return Answer(
    //   id: json["id"],
    //   title: json ["title"],
    //   text: json["text"],
    //   image: Endpoints.domain +
    //       '/api/app/answers/img/${json["image"].toString().replaceAll(
    //           Endpoints.domain + '/api/app/answers/img/', '')}',
    //   color: json["color"],
    //   selected: (json["selected"] == null) ? false : json["selected"],
    //   updated_at: json["updated_at"],
    //   is_enabled: json["is_enabled"] == 1 ? true : false,
    //   disabled_text: json ["disabled_text"],
    // );
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
    );
  }

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
  };

}