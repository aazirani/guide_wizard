import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:guide_wizard/constants/dimens.dart';
import 'package:guide_wizard/constants/lang_keys.dart';
import 'package:guide_wizard/data/data_load_handler.dart';
import 'package:guide_wizard/stores/app_settings/app_settings_store.dart';
import 'package:guide_wizard/stores/data/data_store.dart';
import 'package:guide_wizard/stores/language/language_store.dart';
import 'package:guide_wizard/stores/technical_name/technical_name_with_translations_store.dart';
import 'package:guide_wizard/stores/updated_at_times/updated_at_times_store.dart';
import 'package:guide_wizard/widgets/current_step_indicator_widget.dart';
import 'package:guide_wizard/widgets/info_step_description.dart';
import 'package:guide_wizard/widgets/shimmering_effect/shimmer_widget.dart';
import 'package:guide_wizard/widgets/step_slider/steps_widget.dart';
import 'package:guide_wizard/widgets/step_timeline/step_timeline.dart';
import 'package:guide_wizard/widgets/task_step_description.dart';
import 'package:material_dialog/material_dialog.dart';
import 'package:provider/provider.dart';
import 'package:guide_wizard/utils/extension/context_extensions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Stores :---------------------------------------------------------------------
  late DataStore _dataStore;
  late TechnicalNameWithTranslationsStore _technicalNameWithTranslationsStore;
  late LanguageStore _languageStore;
  late UpdatedAtTimesStore _updatedAtTimesStore;
  late AppSettingsStore _appSettingsStore;
  late DataLoadHandler _dataLoadHandler = DataLoadHandler(context: context);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // initializing stores
    _dataStore = Provider.of<DataStore>(context);
    _technicalNameWithTranslationsStore =
        Provider.of<TechnicalNameWithTranslationsStore>(context);
    _languageStore = Provider.of<LanguageStore>(context);
    _updatedAtTimesStore = Provider.of<UpdatedAtTimesStore>(context);
    _appSettingsStore = Provider.of<AppSettingsStore>(context);
  }

  @override
  void initState() {
    _dataLoadHandler.loadDataAndCheckForUpdate(initialLoading: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.primaryColor,
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        color: context.primaryColor,
        onRefresh: () async {
          DataLoadHandler(context: context)
              .loadDataAndCheckForUpdate(refreshData: true);
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height -
                _buildAppBar().preferredSize.height -
                MediaQuery.of(context).padding.top,
            child: _buildBody(context),
          ),
        ),
      ),
    );
  }

//appbar build methods .........................................................
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: Dimens.appBar.toolbarHeight,
      titleSpacing: Dimens.appBar.titleSpacing,
      backgroundColor: context.primaryColor,
      actions: _buildActions(context),
      title: Padding(
        padding: EdgeInsets.only(left: 10),
        child: Observer(
          builder: (_) => Text(
            _technicalNameWithTranslationsStore
                .getTranslationByTechnicalName(LangKeys.steps_title),
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Theme.of(context).colorScheme.onPrimary),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    return <Widget>[
      _buildLanguageButton(),
    ];
  }

  Widget _buildLanguageButton() {
    return IconButton(
      onPressed: () {
        _buildLanguageDialog();
      },
      icon: Icon(
        Icons.language,
      ),
      color: Colors.white,
    );
  }

  _buildLanguageDialog() {
    _showDialog<String>(
      context: context,
      child: Observer(
        builder: (_) => MaterialDialog(
          borderRadius: Dimens.homeScreen.buttonRadius,
          enableFullWidth: true,
          headerColor: Theme.of(context).primaryColor,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          closeButtonColor: Colors.white,
          enableCloseButton: true,
          enableBackButton: false,
          onCloseButtonClicked: () {
            Navigator.of(context).pop();
          },
          children: _technicalNameWithTranslationsStore
              .getSupportedLanguages()
              .map(
                (object) => ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.all(0.0),
                  title: Text(object.language_name,
                      style: Theme.of(context).textTheme.bodySmall),
                  onTap: () {
                    Navigator.of(context).pop();
                    // change user language based on selected locale
                    _languageStore.changeLanguage(object.language_code);
                    _technicalNameWithTranslationsStore
                        .setCurrentLocale(object.language_code);
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  _showDialog<T>({required BuildContext context, required Widget child}) {
    showDialog<T>(
      context: context,
      builder: (BuildContext context) => child,
    ).then<void>((T? value) {
      // The value passed to Navigator.pop() or null.
    });
  }

//body build methods ...........................................................
  Widget _buildBody(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Dimens.homeScreen.bodyBorderRadius),
          topRight: Radius.circular(Dimens.homeScreen.bodyBorderRadius)),
      child: Observer(
        builder: (_) => Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: context.lightBackgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(Dimens.homeScreen.bodyBorderRadius),
              topRight: Radius.circular(Dimens.homeScreen.bodyBorderRadius),
            ),
          ),
          child: !_dataStore.isEmpty &&
                  !_dataStore.isLoading &&
                  !_technicalNameWithTranslationsStore.technicalNameLoading &&
                  !_updatedAtTimesStore.updatedAtTimesLoading &&
                  _dataStore.stepSuccess &&
                  _technicalNameWithTranslationsStore.technicalNameSuccess &&
                  _updatedAtTimesStore.updatedAtTimesSuccess
              ? _buildScreenElements()
              : ShimmerWidget(),
        ),
      ),
    );
  }

  Widget _buildScreenElements() {
    _languageStore.changeLanguage(_languageStore.locale);
    _technicalNameWithTranslationsStore.setCurrentLocale(_languageStore.locale);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CurrentStepIndicatorWidget(),
        StepsWidget(),
        StepTimeLine(),
        _dataStore.isFirstStep(_appSettingsStore.currentStepId)
            ? InfoStepDescription()
            : TaskStepDescription(),
      ],
    );
  }
}