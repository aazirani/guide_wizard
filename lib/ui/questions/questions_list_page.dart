import 'dart:math' as math;
import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/constants/dimens.dart';
import 'package:boilerplate/data/data_laod_handler.dart';
import 'package:boilerplate/providers/question_widget_state/question_widget_state.dart';
import 'package:boilerplate/stores/app_settings/app_settings_store.dart';
import 'package:boilerplate/stores/technical_name/technical_name_with_translations_store.dart';
import 'package:boilerplate/widgets/next_stage_button.dart';
import 'package:boilerplate/widgets/question_widget.dart';
import 'package:boilerplate/widgets/questions_list_page_appBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:boilerplate/stores/data/data_store.dart';

class QuestionsListPage extends StatefulWidget {
  int stepNumber;
  QuestionsListPage({required this.stepNumber, Key? key}) : super(key: key);

  @override
  State<QuestionsListPage> createState() => _QuestionsListPageState();
}

class _QuestionsListPageState extends State<QuestionsListPage> {
  get _questionsCount => _dataStore.questionList.length;

  // stores:--------------------------------------------------------------------
  late DataStore _dataStore;
  late AppSettingsStore _appSettingsStore;
  late TechnicalNameWithTranslationsStore _technicalNameWithTranslationsStore;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // initializing stores
    _dataStore = Provider.of<DataStore>(context);
    _appSettingsStore = Provider.of<AppSettingsStore>(context);
    _technicalNameWithTranslationsStore = Provider.of<TechnicalNameWithTranslationsStore>(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await DataLoadHandler(context: context).checkIfUpdateIsNecessary();
        return true;
      },
      child: Consumer<QuestionsWidgetState>(builder: (context, builder, child) {
        return Scaffold(
          appBar: QuestionsListAppBar(title: _appBarTitleString(),),
          backgroundColor: AppColors.main_color,
          body: ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: ScrollablePositionedList.builder(
                itemCount: _questionsCount + 1,
                itemBuilder: (context, index) => _buildScrollablePositionedListItem(index),
              ),
            ),
          ),
          floatingActionButton: Visibility(
            // visible: !builder.isLastQuestion(questionsCount: _questionsCount),
            visible: true,
            child: _buildDockedNextStageButton(),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        );
      }),
    );
  }

  Widget _buildScrollablePositionedListItem(int index) {
    return _isItemAfterQuestions(index) ? SizedBox(height: Dimens.nextStageSurroundingContainerHeight - (Dimens.nextStageSurroundingContainerHeight - NextStageButton().height) / 2 - Dimens.questionWidgetListTilePadding.bottom,) : _buildQuestionWidget(index);
  }

  bool _isItemAfterQuestions(index) => index == _questionsCount;

  Widget _buildQuestionWidget(int index) {
    return Card(
      child: QuestionWidget(
        index: index,
        question: _dataStore.questionList.elementAt(index),
        questionsCount: _dataStore.questionList.length,
      ),
    );
  }

  Widget _buildDockedNextStageButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: Dimens.nextStageSurroundingContainerHeight,
      decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white.withOpacity(0),
              Colors.white,
              Colors.white,
            ],
          )
      ),
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Positioned(
            bottom: Dimens.nextStageDistanceFromBottom,
            child: NextStageButton(),
          ),
        ],
      ),
    );
  }

  String _appBarTitleString() {
    int titleId = _dataStore.stepList.steps[widget.stepNumber].name;
    return _technicalNameWithTranslationsStore.getTranslation(titleId)!;
  }
}
