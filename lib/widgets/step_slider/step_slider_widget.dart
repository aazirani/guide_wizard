import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:guide_wizard/constants/lang_keys.dart';
import 'package:guide_wizard/stores/app_settings/app_settings_store.dart';
import 'package:guide_wizard/stores/data/data_store.dart';
import 'package:guide_wizard/stores/technical_name/technical_name_with_translations_store.dart';
import 'package:guide_wizard/widgets/step_content.dart';
import 'package:provider/provider.dart';

class StepSliderWidget extends StatefulWidget {
  const StepSliderWidget({Key? key,}) : super(key: key);

  @override
  State<StepSliderWidget> createState() => _StepSliderWidgetState();
}

class _StepSliderWidgetState extends State<StepSliderWidget> {

  late DataStore _dataStore;
  late TechnicalNameWithTranslationsStore _technicalNameWithTranslationsStore;
  late AppSettingsStore _appSettingsStore;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _dataStore = Provider.of<DataStore>(context);
    _technicalNameWithTranslationsStore =
        Provider.of<TechnicalNameWithTranslationsStore>(context);
    _appSettingsStore = Provider.of<AppSettingsStore>(context);
  }

  final CarouselSliderController _carouselController = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => CarouselSlider(
        carouselController: _carouselController,
        options: CarouselOptions(
            scrollDirection: Axis.horizontal,
            initialPage:
                _dataStore.getIndexOfStep(_appSettingsStore.currentStepId),
            onPageChanged: (index, reason) {
              _appSettingsStore
                  .setCurrentStepId(_dataStore.getStepByIndex(index).id);
            },
            height: _getScreenHeight() / 4,
            enlargeCenterPage: true,
            enableInfiniteScroll: false),
        items: List<int>.generate(_dataStore.getAllSteps.length, (index) => index)
            .map((index) {
          return Builder(
            builder: (BuildContext context) {
              return GestureDetector(
                onTap: () {
                  _carouselController.animateToPage(index);
                },
                child: StepContent(step_index: index),
              );
            },
          );
        }).toList(),
      ),
    );
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

  //general methods ............................................................
  double _getScreenHeight() => MediaQuery.of(context).size.height;

}