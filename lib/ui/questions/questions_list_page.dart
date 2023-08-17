import 'package:flutter/material.dart';
import 'package:guide_wizard/constants/colors.dart';
import 'package:guide_wizard/data/data_laod_handler.dart';
import 'package:guide_wizard/providers/question_widget_state/question_widget_state.dart';
import 'package:guide_wizard/stores/app_settings/app_settings_store.dart';
import 'package:guide_wizard/stores/data/data_store.dart';
import 'package:guide_wizard/stores/technical_name/technical_name_with_translations_store.dart';
import 'package:guide_wizard/widgets/measure_size.dart';
import 'package:guide_wizard/widgets/next_stage_button.dart';
import 'package:guide_wizard/widgets/question_widget.dart';
import 'package:guide_wizard/widgets/questions_list_page_appBar.dart';
import 'package:provider/provider.dart';

class QuestionsListPage extends StatefulWidget {
  int stepNumber;
  QuestionsListPage({required this.stepNumber, Key? key}) : super(key: key);

  @override
  State<QuestionsListPage> createState() => _QuestionsListPageState();
}

class _QuestionsListPageState extends State<QuestionsListPage> {
  get _questionsCount => _dataStore.questionList.length;
  Size floatingActionButtonSize = Size(0, 0);
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
              child: Column(
                children: [
                  Flexible(
                    child: RawScrollbar(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _questionsCount,
                        itemBuilder: (context, index) => _buildQuestionWidget(index),
                      ),
                    ),
                  ),
                  SizedBox(height: floatingActionButtonSize.height,),
                ],
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
    return MeasureSize(
      onChange: (Size size) {
        setState(() {
          floatingActionButtonSize = size;
        });
      },
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: NextStageButton(),
        ),
      ),
    );
  }

  String _appBarTitleString() {
    int titleId = _dataStore.stepList.steps[widget.stepNumber].name;
    return _technicalNameWithTranslationsStore.getTranslation(titleId);
  }
}
