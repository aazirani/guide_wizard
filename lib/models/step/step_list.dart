import 'package:boilerplate/models/question/question.dart';
import 'package:boilerplate/models/step/step.dart' as s;
import 'package:boilerplate/models/sub_task/sub_task.dart';

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

  SubTask? findSubTaskByID(int id){
    SubTask? found_subTask;
    steps.forEach((step) {
      step.tasks.forEach((task) {
        task.sub_tasks.forEach((subTask) {
          if(subTask.id == id) found_subTask = subTask;
        });
      });
    });
    return found_subTask;
  }
}
