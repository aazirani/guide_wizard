import 'dart:math' as math;

import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/constants/dimens.dart';
import 'package:boilerplate/data/network/constants/endpoints.dart';
import 'package:boilerplate/models/question/question.dart';
import 'package:boilerplate/stores/current_step/current_step_store.dart';
import 'package:boilerplate/stores/step/step_store.dart';
import 'package:boilerplate/stores/technical_name/technical_name_with_translations_store.dart';
import 'package:boilerplate/ui/home/home.dart';
import 'package:boilerplate/url_handler.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:boilerplate/widgets/info_dialog.dart';
import 'package:boilerplate/widgets/scrolling_overflow_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:boilerplate/providers/question_widget_state/question_widget_state.dart';
import 'package:boilerplate/stores/data/data_store.dart';

class QuestionWidget extends StatefulWidget {
  Question question;
  bool isLastQuestion;
  int index;

  QuestionWidget({
    Key? key,
    required this.index,
    required this.question,
    required this.isLastQuestion,
  }) : super(key: key);

  @override
  State<QuestionWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget>
    with AutomaticKeepAliveClientMixin {
  late DataStore _dataStore;
  late StepStore _stepStore;
  late TechnicalNameWithTranslationsStore _technicalNameWithTranslationsStore;
  late CurrentStepStore _currentStepStore;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // initializing stores
    _dataStore = Provider.of<DataStore>(context);
    _stepStore = Provider.of<StepStore>(context);
    _technicalNameWithTranslationsStore =
        Provider.of<TechnicalNameWithTranslationsStore>(context);
    _currentStepStore = Provider.of<CurrentStepStore>(context);
  }

  @override
  bool get wantKeepAlive => true;
  double _getScreenWidth() => MediaQuery.of(context).size.width;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<QuestionsWidgetState>(builder: (context, builder, child) {
      return ExpansionPanelList(
        expandedHeaderPadding: EdgeInsets.zero,
        elevation: 0,
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            builder.setActiveIndex(widget.index);
          });
        },
        children: [
          ExpansionPanel(
            canTapOnHeader: true,
            headerBuilder: (BuildContext context, bool isExpanded) {
              return _buildTitle();
            },
            body: Column(
              children: [
                _buildDescription(),
                _buildOptions(),
                widget.isLastQuestion
                    ? _buildNextStageButton()
                    : _buildNextQuestionButton(),
              ],
            ),
            isExpanded: builder.isWidgetExpanded(widget.index),
          ),
        ],
      );
    });
  }

  Widget _buildTitle() {
    var title_id = widget.question.title;
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20, left: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ScrollingOverflowText(
            text: _technicalNameWithTranslationsStore
                .getTranslation(title_id)!,
            textStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
            height: 30,
            width: _getScreenWidth() - 100,
          ),
          Provider.of<QuestionsWidgetState>(context)
              .isWidgetExpanded(widget.index) && _hasInfo()
              ? _buildInfoButton()
              : SizedBox(),
          // _buildHelpButton(),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    var questionSubtitleId = widget.question.sub_title;
    return Container(
      margin: Dimens.questionDescriptionPadding,
      child: Text(
        _technicalNameWithTranslationsStore
            .getTranslation(questionSubtitleId)!,
      ),
    );
  }

  ButtonStyle _buildQuestionsButtonStyle(Color color) {
    return ButtonStyle(
      minimumSize: MaterialStateProperty.all(sizeOfButton()),
      backgroundColor: MaterialStateProperty.all<Color>(color),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
    );
  }

  Widget _buildNextStageButton() {
    return Padding(
      padding: Dimens.questionButtonPadding,
      child: TextButton(
        style: _buildQuestionsButtonStyle(AppColors.nextStepColor),
        onPressed: () {
          _dataStore.getTasks(_stepStore.currentStep);
          _currentStepStore.setStepNumber(1);
          Navigator.of(context)
              .pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => HomeScreen()),
                  (Route<dynamic> route) => false)
              .then((value) => setState(() {}));
        },
        child: Text(
          AppLocalizations.of(context).translate('next_stage_button_text'),
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
      ),
    );
  }

  Widget _buildNextQuestionButton() {
    return Consumer<QuestionsWidgetState>(builder: (context, builder, child) {
      return Padding(
        padding: Dimens.questionButtonPadding,
        child: TextButton(
          style: _buildQuestionsButtonStyle(AppColors.main_color),
          onPressed: () async => {
            await builder.setActiveIndex(widget.index + 1),
          },
          child: Text(
            AppLocalizations.of(context).translate('next_question_button_text'),
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
        ),
      );
    });
  }

  ButtonStyle _buildInfoCloseButtonStyle({required double scaleBy}) {
    return ButtonStyle(
      minimumSize: MaterialStateProperty.all(sizeOfButton(scaleBy: scaleBy)),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: Dimens.infoInsideDialogButtonsRadius,
          side: BorderSide(color: AppColors.close_button_color, width: 2),
        ),
      ),
    );
  }

  Widget _buildInfoCloseButton({double scaleBy = 1}) {
    return Consumer<QuestionsWidgetState>(builder: (context, builder, child) {
      return Flexible(
        child: TextButton(
          style: _buildInfoCloseButtonStyle(scaleBy: scaleBy),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
              AppLocalizations.of(context).translate('close'),
            style: TextStyle(color: AppColors.close_button_color, fontSize: 15),
          ),
        ),
      );
    });
  }

  ButtonStyle _buildInfoOpenUrlButtonStyle({required double scaleBy, Color color = AppColors.main_color}) {
    return ButtonStyle(
      minimumSize: MaterialStateProperty.all(sizeOfButton(scaleBy: scaleBy)),
      backgroundColor: MaterialStateProperty.all<Color>(color),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
    );
  }

  Widget _buildInfoOpenUrlButton({double scaleBy = 1}) {
    return Consumer<QuestionsWidgetState>(builder: (context, builder, child) {
      return Flexible(
        child: TextButton(
          style: _buildInfoOpenUrlButtonStyle(scaleBy: scaleBy),
          onPressed: () {
            UrlHandler.openUrl(context: context, url: _getInfoUrl());
          },
          child: Text(
            AppLocalizations.of(context).translate('read_more'),
            style: TextStyle(color: AppColors.white, fontSize: 15),
          ),
        ),
      );
    });
  }

  void _showInfoInBottomSheet({required Widget buttonsRow}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return InfoDialog(
          content: Padding(
            padding: Dimens.infoBottomSheetPadding,
            child: Text(
              _getInfoDescription(),
              style: TextStyle(fontSize: 17),
            ),
          ),
          bottomRow: Container(
            color: AppColors.white,
            child: Padding(
              padding: Dimens.infoButtonsPadding,
              child: buttonsRow,
            ),
          ),
        );
      },
    );
  }

  bool _hasInfoDescription() {
    return _technicalNameWithTranslationsStore.isTranslationsNotEmpty(widget.question.info_description);
  }

  bool _hasInfoUrl() {
    return _technicalNameWithTranslationsStore.isTranslationsNotEmpty(widget.question.info_url);
  }

  bool _hasInfo() {
    return _hasInfoDescription() || _hasInfoUrl();
  }

  String _getInfoDescription() {
    return _technicalNameWithTranslationsStore.getTranslation(widget.question.info_description)!;
  }

  String _getInfoUrl() {
    return _technicalNameWithTranslationsStore.getTranslation(widget.question.info_url)!;
  }

  void _showInfo() {
    bool hasDescription = _hasInfoDescription();
    bool hasUrl = _hasInfoUrl();
    if(hasDescription && hasUrl) {
      _showInfoInBottomSheet(
        buttonsRow: Row(
          children: [
            _buildInfoCloseButton(scaleBy: 2),
            SizedBox(width: 10,),
            _buildInfoOpenUrlButton(scaleBy: 2),
          ],
        ),
      );
    }
    else if(hasDescription && !hasUrl) {
      _showInfoInBottomSheet(
        buttonsRow: Row(
          children: [
            _buildInfoCloseButton(scaleBy: 1),
          ],
        ),
      );
    }
    else if(!hasDescription && hasUrl) {
      UrlHandler.openUrl(context: context, url: _getInfoUrl());
    }

  }

  Widget _buildInfoButton() {
    return Container(
      margin: Dimens.infoButtonContainerMargin,
      child: Material(
        borderRadius: Dimens.infoButtonBorderRadius,
        child: InkWell(
          onTap:() {
            _showInfo();
          },
          child: Container(
            padding: Dimens.infoButtonContainerPadding,
            child: Icon(
              Icons.help_outline_rounded,
              color: Colors.white,
            ),
          ),
        ),
        color: AppColors.main_color,
      ),
    );
  }

  Widget _buildOptions() {
    if (widget.question.isImageQuestion) {
      return _buildImageOptions();
    } else {
      return _buildTextOptions();
    }
  }

  Widget _buildImageOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int row = 0;
        row <= widget.question.answers.length / widget.question.axis_count;
        row++)
          _buildAImageOptionsRow(
              row * widget.question.axis_count,
              math.min((row + 1) * widget.question.axis_count,
                  widget.question.answers.length)),
      ],
    );
  }

  Widget _buildAImageOptionsRow(int begin, int end) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int index = begin; index < end; index++)
            _buildSingleImageOption(index),
        ],
      ),
    );
  }

  Widget _buildSingleImageOption(int index) {
    return Flexible(
      child: Stack(
        alignment: AlignmentDirectional.topEnd,
        children: [
          Container(
            margin: const EdgeInsets.all(8),
            // height: 200, //TODO: can admin set height manually?
            //   width: 200, //TODO: can admin set width manually?
            child: ListTile(
                horizontalTitleGap: 0,
                minVerticalPadding: 0,
                minLeadingWidth: 0,
                contentPadding: EdgeInsets.zero,
                onTap: () {
                  setState(() {
                    _dataStore.updateQuestion(
                        widget.question,
                        widget.question.getAnswerByIndex(index),
                        !widget.question.getAnswerByIndex(index).selected);
                  });
                },
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: widget.question.getAnswerByIndex(index).isSelected
                          ? AppColors.main_color
                          : Colors.transparent,
                      width: 2),
                  borderRadius: BorderRadius.circular(5),
                ),
                title: Column(
                  children: [
                    _buildImageLoader(
                        Endpoints.answersImageBaseUrl + widget.question.getAnswerByIndex(index).getImage),
                    _buildImageOptionSubtitle(index),
                  ],
                ),
                tileColor: AppColors.greys[500]),
          ),
          _buildImageCheckBox(index),
        ],
      ),
    );
  }

  Widget _buildImageLoader(String imageURL) {
    return Image.network(
      imageURL,
      fit: BoxFit.cover,
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) return child;
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes!
                  : null,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.main_color),
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageOptionSubtitle(int index) {
    if (answerHasTitle(widget.question)) {
      var answer_title_id = widget.question.getAnswerByIndex(index).title;
      return Padding(
        padding: const EdgeInsets.only(top: 5, bottom: 5),
        child: Row(
          children: [
            Transform.scale(
              child: SizedBox(
                child: Checkbox(
                  value: widget.question.getAnswerByIndex(index).isSelected,
                  onChanged: (value) {
                    setState(() {
                      _dataStore.updateQuestion(
                          widget.question,
                          widget.question.getAnswerByIndex(index),
                          value ?? false);
                    });
                  },
                  checkColor: Colors.white,
                  activeColor: AppColors.main_color,
                  shape: CircleBorder(),
                ),
                height: 30,
                width: 30,
              ),
              scale: 0.8,
            ),
            Flexible(
              child: Text(
                _technicalNameWithTranslationsStore
                    .getTranslation(answer_title_id)!,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return SizedBox();
    }
  }

  bool answerHasTitle(Question question) {
    if(question.answers.length != 0) {
      return _technicalNameWithTranslationsStore.getTranslation(question.answers.elementAt(0).title)!.isNotEmpty;
    }
    return false;
  }

  Widget _buildImageCheckBox(int index) {
    if (answerHasTitle(widget.question)) {
      return SizedBox();
    }
    return Checkbox(
      value: widget.question.getAnswerByIndex(index).isSelected,
      onChanged: (value) {
        setState(() {
          _dataStore.updateQuestion(widget.question,
              widget.question.getAnswerByIndex(index), value ?? false);
        });
      },
      checkColor: AppColors.white,
      activeColor: AppColors.main_color,
      shape: CircleBorder(),
      side: BorderSide(color: Colors.transparent),
    );
  }


  Widget _buildTextOptions() {
    return Column(
      children: widget.question
          .getAnswers()
          .map((option) => Container(
        margin: const EdgeInsets.only(left: 15, right: 15, top: 10),
        child: CheckboxListTile(
          shape: RoundedRectangleBorder(
            side: BorderSide(
                color: option.isSelected
                    ? AppColors.main_color
                    : Colors.transparent,
                width: 2),
            borderRadius: BorderRadius.circular(5),
          ),
          checkboxShape: CircleBorder(),
          value: option.isSelected,
          onChanged: (value) {
            setState(() {
              _dataStore.updateQuestion(
                  widget.question, option, value ?? false);
            });
          },
          title: Text(
            _technicalNameWithTranslationsStore
                .getTranslation(option.getAnswerTitleID())!,
          ),
          controlAffinity: ListTileControlAffinity.leading,
          tileColor: AppColors.white,
          activeColor: AppColors.main_color,
        ),
      ))
          .toList(),
    );
  }

  Size sizeOfButton({scaleBy = 1}){
    return Size(math.max(_getScreenWidth() - (Dimens.buildQuestionsButtonStyle["pixels_smaller_than_screen_width"]!) / scaleBy, 0), Dimens.buildQuestionsButtonStyle["height"]!);
  }
}