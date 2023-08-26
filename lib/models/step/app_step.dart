import 'package:guide_wizard/models/question/question.dart';
import 'package:guide_wizard/models/task/task.dart';
import 'package:mobx/mobx.dart';

// // Include generated file
part 'app_step.g.dart';

// This is the class used by rest of your codebase
class AppStep = _AppStep with _$AppStep;

abstract class _AppStep with Store {
  @observable
  int id;

  @observable
  int name;

  @observable
  int description;

  @observable
  int order;

  @observable
  String? image;

  @observable
  int creator_id;

  @observable
  String created_at;

  @observable
  String updated_at;

  @observable
  ObservableList<Question> questions;

  ObservableList<Task> tasks;

  _AppStep(
      {required this.id,
      required this.name,
      required this.description,
      required this.order,
      required this.image,
      required this.creator_id,
      required this.created_at,
      required this.updated_at,
      required this.questions,
      required this.tasks});

  Map<String, dynamic> toMap() => {
      "id": id,
      "name": name,
      "description": description,
      "order": order,
      "image": image,
      "creator_id": creator_id,
      "created_at": created_at,
      "updated_at": updated_at,
      "questions": ObservableList.of(questions.map((question) => question.toMap())),
      "tasks": ObservableList.of(tasks.map((task) => task.toMap())),
  };

}

class AppStepFactory{
  AppStep fromMap(Map<String, dynamic> json) {
    return AppStep(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      order: json["order"],
      image: json["image"],
      creator_id: json["creator_id"],
      created_at: json["created_at"],
      updated_at: json["updated_at"],
      questions: ObservableList.of(json["questions"].map((x) => QuestionFactory().fromMap(x)).toList().cast<Question>()),
      tasks: ObservableList.of(json["tasks"].map((task) => TaskFactory().fromMap(task)).toList().cast<Task>()),
    );
  }
}
