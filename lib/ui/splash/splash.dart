import 'dart:async';
import 'package:boilerplate/constants/assets.dart';
import 'package:boilerplate/data/repository.dart';
import 'package:boilerplate/models/question/question.dart';
import 'package:boilerplate/models/task/task.dart';
import 'package:boilerplate/stores/question/questions_store.dart';
import 'package:boilerplate/stores/task/tasks_store.dart';
import 'package:boilerplate/ui/questions/questions_list_page.dart';
import 'package:boilerplate/ui/tasks/task_page.dart';
import 'package:boilerplate/ui/tasks/task_page_text_only.dart';
import 'package:boilerplate/ui/tasks/task_page_with_image.dart';
import 'package:boilerplate/utils/routes/routes.dart';
import 'package:boilerplate/widgets/app_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:boilerplate/stores/step/steps_store.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  //stores:---------------------------------------------------------------------
  late StepsStore _stepsStore;
  late TasksStore _tasksStore;
  late QuestionsStore _questionsStore;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // initializing stores
    _stepsStore = Provider.of<StepsStore>(context);
    _tasksStore = Provider.of<TasksStore>(context);
    _questionsStore = Provider.of<QuestionsStore>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(child: AppIconWidget(image: Assets.appLogo)),
    );
  }

  startTimer() {
    var _duration = Duration(milliseconds: 1000);
    return Timer(_duration, navigate);
  }

  navigate() async {

    if (!_stepsStore.loading) {
      await _stepsStore.truncateSteps();
      await _tasksStore.truncateTasks();
      await _questionsStore.truncateQuestions();
      await _stepsStore.getSteps();
      await _tasksStore.getTasks();
      await _questionsStore.getQuestions();
    }
    // _tasksStore.isTaskTypeOfImageById(1);
    // Task task = _tasksStore.getTaskById(1);
    // _tasksStore.isTaskTypeOfImageById(1)
    //     ? Navigator.of(context).push(MaterialPageRoute(
    //     builder: (context) => TaskPageWithImage(task: task)))
    //     : Navigator.of(context).push(MaterialPageRoute(
    //     builder: (context) => TaskPageTextOnly(task: task)));
    // Question question = _questionsStore.getQuestionById(1);
    // print("question id " + question.id.toString());
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => QuestionsListPage(questionId: 3,)));

  }
}
