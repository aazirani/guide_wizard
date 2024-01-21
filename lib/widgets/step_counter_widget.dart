import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guide_wizard/constants/lang_keys.dart';
import 'package:guide_wizard/stores/data/data_store.dart';
import 'package:guide_wizard/stores/technical_name/technical_name_with_translations_store.dart';
import 'package:provider/provider.dart';

class StepCounterWidget extends StatefulWidget {
  final int step_index;
  const StepCounterWidget({Key? key, required this.step_index}) : super(key: key);

  @override
  State<StepCounterWidget> createState() => _StepCounterWidgetState();
}

class _StepCounterWidgetState extends State<StepCounterWidget> {
  late DataStore _dataStore;
  late TechnicalNameWithTranslationsStore _technicalNameWithTranslationsStore;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _dataStore = Provider.of<DataStore>(context);
    _technicalNameWithTranslationsStore =
        Provider.of<TechnicalNameWithTranslationsStore>(context);
  }

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
        _dataStore.getStepByIndex(widget.step_index).tasks.isEmpty
            ? noOfQuestionsString(widget.step_index)
            : noOfTasksString(widget.step_index),
        style: Theme.of(context).textTheme.bodySmall!);
  }

  String noOfTasksString(index) {
    int noOfTasks = _dataStore.getStepByIndex(index).tasks.length;
    String str = "$noOfTasks ";
    switch (noOfTasks) {
      case 1:
        str += _technicalNameWithTranslationsStore
            .getTranslationByTechnicalName(LangKeys.task);
        break;
      default:
        str += _technicalNameWithTranslationsStore
            .getTranslationByTechnicalName(LangKeys.tasks);
        break;
    }
    return str;
  }

  String noOfQuestionsString(index) {
    int noOfQuestions = _dataStore.getStepByIndex(index).questions.length;
    String str = "$noOfQuestions ";
    switch (noOfQuestions) {
      case 1:
        str += _technicalNameWithTranslationsStore
            .getTranslationByTechnicalName(LangKeys.question);
        break;
      default:
        str += _technicalNameWithTranslationsStore
            .getTranslationByTechnicalName(LangKeys.questions);
        break;
    }
    return str;
  }
}