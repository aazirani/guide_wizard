import 'dart:math' as math;
import 'package:boilerplate/constants/colors.dart';
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
                itemCount: _questionsCount,
                itemBuilder: (context, index) => Card(
                    margin: EdgeInsets.all(5.0),
                    child: _buildQuestionWidget(index)),
              ),
            ),
          ),
          floatingActionButton: Visibility(
            // visible: !builder.isLastQuestion(questionsCount: _questionsCount),
            visible: true,
            child: NextStageButton(),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        );
      }),
    );
  }

  Widget _buildQuestionWidget(int index) {
    return QuestionWidget(
      index: index,
      question: _dataStore.questionList.elementAt(index),
      questionsCount: _dataStore.questionList.length,
    );
  }

  String _appBarTitleString() {
    int titleId = _dataStore.stepList.steps[widget.stepNumber].name;
    return _technicalNameWithTranslationsStore.getTranslation(titleId)!;
  }
}
