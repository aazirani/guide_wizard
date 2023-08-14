import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:guide_wizard/constants/colors.dart';
import 'package:guide_wizard/constants/dimens.dart';
import 'package:guide_wizard/constants/lang_keys.dart';
import 'package:guide_wizard/data/network/constants/endpoints.dart';
import 'package:guide_wizard/models/answer/answer.dart';
import 'package:guide_wizard/models/question/question.dart';
import 'package:guide_wizard/providers/question_widget_state/question_widget_state.dart';
import 'package:guide_wizard/stores/app_settings/app_settings_store.dart';
import 'package:guide_wizard/stores/data/data_store.dart';
import 'package:guide_wizard/stores/technical_name/technical_name_with_translations_store.dart';
import 'package:guide_wizard/url_handler.dart';
import 'package:guide_wizard/utils/locale/app_localization.dart';
import 'package:guide_wizard/widgets/info_dialog.dart';
import 'package:guide_wizard/widgets/load_image_with_cache.dart';
import 'package:guide_wizard/widgets/next_stage_button.dart';
import 'package:provider/provider.dart';

class QuestionWidget extends StatefulWidget {
  Question question;
  int index, questionsCount;

  QuestionWidget({
    Key? key,
    required this.index,
    required this.question,
    required this.questionsCount,
  }) : super(key: key);

  @override
  State<QuestionWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> with AutomaticKeepAliveClientMixin {
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
  bool get wantKeepAlive => false;
  double _getScreenWidth() => MediaQuery.of(context).size.width;
  double _getScreenHeight() => MediaQuery.of(context).size.height;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListTile(
      contentPadding: Dimens.questionWidgetListTilePadding,
      title: _buildTitle(),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDescription(),
          _buildOptions(),
          // _buildQuestionButton(),
        ],
      ),
    );
  }

  bool _isLastQuestion() {
    return widget.index == widget.questionsCount - 1;
  }

  Widget _buildQuestionButton() {
    // return _isLastQuestion() ? _buildNextStageButton() : _buildNextQuestionButton();
    return _isLastQuestion() ? SizedBox() : _buildNextQuestionButton();
  }

  Widget _buildTitle() {
    var titleId = widget.question.title;
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 22, left: 17),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              _technicalNameWithTranslationsStore.getTranslation(titleId),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: _hasInfo()
                ? _buildInfoButton()
                : SizedBox(),
          ),
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
        _technicalNameWithTranslationsStore.getTranslation(questionSubtitleId)!,
        style: TextStyle(fontSize: 19),
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
    return NextStageButton();
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
            AppLocalizations.of(context).translate(LangKeys.next_question_button_text),
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
        ),
      );
    });
  }

  ButtonStyle _buildInfoCloseButtonStyle({required double scaleBy}) {
    return ButtonStyle(
      minimumSize: MaterialStateProperty.all(sizeOfButton(scaleBy: scaleBy)),
      overlayColor: MaterialStateColor.resolveWith((states) => AppColors.close_button_color.withOpacity(0.1)),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: Dimens.infoInsideDialogButtonsRadius,
          side: BorderSide(color:  AppColors.close_button_color, width: 2),
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
              AppLocalizations.of(context).translate(LangKeys.close),
            style: TextStyle(color: AppColors.close_button_color, fontSize: 15),
          ),
        ),
      );
    });
  }

  ButtonStyle _buildInfoOpenUrlButtonStyle({required double scaleBy, Color color = AppColors.main_color}) {
    return ButtonStyle(
      minimumSize: MaterialStateProperty.all(sizeOfButton(scaleBy: scaleBy)),
      overlayColor: MaterialStateColor.resolveWith((states) => AppColors.white.withOpacity(0.13)),
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
            AppLocalizations.of(context).translate(LangKeys.read_more),
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
    return _technicalNameWithTranslationsStore.getTranslation(widget.question.info_description);
  }

  String _getInfoUrl() {
    return _technicalNameWithTranslationsStore.getTranslation(widget.question.info_url)!;
  }

  void _showInfo() {
    bool hasDescription = _hasInfoDescription();
    bool hasUrl = _hasInfoUrl();
    if (hasDescription && hasUrl) {
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
    else if (hasDescription && !hasUrl) {
      _showInfoInBottomSheet(
        buttonsRow: Row(
          children: [
            _buildInfoCloseButton(scaleBy: 1),
          ],
        ),
      );
    }
    else if (!hasDescription && hasUrl) {
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

  Widget _buildSingleOption(int index) {
    if (widget.question.isImageQuestion) {
      return _buildSingleImageOption(index);
    } else {
      return _buildSingleTextOption(index);
    }
  }

  Widget _buildOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int row = 0; row <= widget.question.answers.length / widget.question.axis_count; row++)
        _buildAOptionsRow(
            row * widget.question.axis_count,
            math.min((row + 1) * widget.question.axis_count, widget.question.answers.length)
        ),
      ],
    );
  }

  Widget _buildAOptionsRow(int begin, int end) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int index = begin; index < end; index++)
            _buildSingleOption(index),
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
                    Answer option = widget.question.getAnswerByIndex(index);
                    answerOnTapFunction(option, !option.selected);
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
    return LoadImageWithCache(imageUrl: imageURL, color: AppColors.main_color,);
  }

  Widget _buildImageOptionSubtitle(int index) {
    if (answerHasTitle(widget.question)) {
      var answerTitleId = widget.question.getAnswerByIndex(index).title;
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
                      answerOnTapFunction(widget.question.getAnswerByIndex(index), value);
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
                _technicalNameWithTranslationsStore.getTranslation(answerTitleId),
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
          answerOnTapFunction(widget.question.getAnswerByIndex(index), value);
        });
      },
      checkColor: AppColors.white,
      activeColor: AppColors.main_color,
      shape: CircleBorder(),
      side: BorderSide(color: Colors.transparent),
    );
  }

  Widget _buildSingleTextOption(int index) {
    Answer option = widget.question.getAnswerByIndex(index);
    return Flexible(
      child: Container(
        margin: Dimens.singleTextOptionPadding,
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
              answerOnTapFunction(option, value);
            });
          },
          title: Text(
            _technicalNameWithTranslationsStore.getTranslation(option.getAnswerTitleID()),
          ),
          controlAffinity: ListTileControlAffinity.leading,
          tileColor: AppColors.white,
          activeColor: AppColors.main_color,
        ),
      ),
    );
  }

  Size sizeOfButton({scaleBy = 1}){
    return Size(math.max(_getScreenWidth() - (Dimens.buildQuestionsButtonStyle["pixels_smaller_than_screen_width"]!) / scaleBy, 0), Dimens.buildQuestionsButtonStyle["height"]!);
  }

  void answerOnTapFunction(Answer option, bool? value) async {
    if(!widget.question.is_multiple_choice) {
        widget.question.answers.forEach((answer) { answer.selected = false; });
    }
    widget.question.answers.firstWhere((answer) => answer.id == option.id).selected = value ?? false;
    await _dataStore.updateQuestion(widget.question);
    await _appSettingsStore.setMustUpdate(true);
  }
}