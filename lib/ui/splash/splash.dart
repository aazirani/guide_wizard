import 'dart:async';
import 'package:boilerplate/constants/assets.dart';
import 'package:boilerplate/stores/question/questions_store.dart';
import 'package:boilerplate/stores/task/tasks_store.dart';
import 'package:boilerplate/ui/questions/questions_list_page.dart';
import 'package:boilerplate/widgets/app_icon_widget.dart';
import 'package:flutter/material.dart';
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
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => QuestionsListPage(questionId: 3,)));

  }
}
