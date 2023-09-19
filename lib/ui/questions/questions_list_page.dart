import 'package:flutter/material.dart';
import 'package:guide_wizard/constants/colors.dart';
import 'package:guide_wizard/providers/question_widget_state/question_widget_state.dart';
import 'package:guide_wizard/stores/data/data_store.dart';
import 'package:guide_wizard/stores/technical_name/technical_name_with_translations_store.dart';
import 'package:guide_wizard/widgets/measure_size.dart';
import 'package:guide_wizard/widgets/next_stage_button.dart';
import 'package:guide_wizard/widgets/question_widget.dart';
import 'package:guide_wizard/widgets/questions_list_page_appBar.dart';
import 'package:provider/provider.dart';
import 'package:guide_wizard/utils/extension/context_extensions.dart';

class QuestionsListPage extends StatefulWidget {
  int stepId;
  QuestionsListPage({required this.stepId, Key? key}) : super(key: key);

  @override
  State<QuestionsListPage> createState() => _QuestionsListPageState();
}

class _QuestionsListPageState extends State<QuestionsListPage> {
  get questions => _dataStore.getStepById(widget.stepId).questions;
  Size floatingActionButtonSize = Size(0, 0);
  // stores:--------------------------------------------------------------------
  late DataStore _dataStore;
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
    _technicalNameWithTranslationsStore = Provider.of<TechnicalNameWithTranslationsStore>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QuestionsWidgetState>(builder: (context, builder, child) {
      return Scaffold(
        appBar: QuestionsListAppBar(title: _appBarTitleString(),),
        backgroundColor: context.primaryColor,
        body: ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: context.lightBackgroundColor,
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
                      itemCount: questions.length,
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
    });
  }

  Widget _buildQuestionWidget(int index) {
    return Card(
      child: QuestionWidget(
        index: index,
        question: questions[index]
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
    return _technicalNameWithTranslationsStore.getTranslation(_dataStore.getStepById(widget.stepId).name);
  }
}
