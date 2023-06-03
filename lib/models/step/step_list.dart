import 'package:boilerplate/models/question/question.dart';
import 'package:boilerplate/models/step/step.dart' as s;

class StepList {
  final List<s.Step> steps;

  StepList({
    required this.steps,
  });

  factory StepList.fromJson(List<dynamic> json) {
    List<s.Step> steps;
    steps = json.map((step) => s.Step.fromMap(step)).toList();

    return StepList(
      steps: steps,
    );
  }
  List<s.Step> get listStep {
    return steps;
  }

  Question? findQuestionByID(int id){
    Question? found_question;
    steps.forEach((step) {
      step.tasks.forEach((task) {
        task.sub_tasks.forEach((subTask) {
        });
        task.questions.forEach((question) {
          if(question.id == id) found_question = question;
        });
      });
    });
    return found_question;
  }
}
