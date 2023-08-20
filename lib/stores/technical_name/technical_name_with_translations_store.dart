import 'package:get/get.dart';
import 'package:guide_wizard/data/repository.dart';
import 'package:guide_wizard/models/language/Language.dart';
import 'package:guide_wizard/models/technical_name/technical_name_with_translations.dart';
import 'package:guide_wizard/models/technical_name/technical_name_with_translations_list.dart';
import 'package:mobx/mobx.dart';

// // Include generated file
part 'technical_name_with_translations_store.g.dart';

// This is the class used by rest of your codebase
class TechnicalNameWithTranslationsStore = _TechnicalNameWithTranslationsStore with _$TechnicalNameWithTranslationsStore;

abstract class _TechnicalNameWithTranslationsStore with Store {
  Repository _repository;
  _TechnicalNameWithTranslationsStore(Repository repo) : this._repository = repo;

  static ObservableFuture<TechnicalNameWithTranslationsList>emptyTechnicalNameWithTranslationsResponse = ObservableFuture.value(TechnicalNameWithTranslationsList(technicalNameWithTranslations: []));

  @observable
  ObservableFuture<TechnicalNameWithTranslationsList>
      fetchTechnicalNameWithTranslationsFuture =
      ObservableFuture<TechnicalNameWithTranslationsList>(
          emptyTechnicalNameWithTranslationsResponse);

  @observable
  int? language_id;

  @observable
  TechnicalNameWithTranslationsList technicalNameWithTranslationsList =
      TechnicalNameWithTranslationsList(technicalNameWithTranslations: []);

  @observable
  bool success = false;

  @computed
  bool get loading =>
      fetchTechnicalNameWithTranslationsFuture.status == FutureStatus.pending;

  @action
  Future getTechnicalNameWithTranslations() async {
    final future = _repository.getTechnicalNameWithTranslations();
    fetchTechnicalNameWithTranslationsFuture = ObservableFuture(future);
    await future.then((technicalNameWithTranslationsList) {
      this.technicalNameWithTranslationsList =
          technicalNameWithTranslationsList;
    });
  }

  @action
  void setCurrentLocale(String languageCode) {
    try{
      this.language_id = getSupportedLanguages().firstWhere(
              (element) => element.language_code == languageCode,
          orElse: () => getSupportedLanguages().firstWhere(
                  (element) => element.is_main_language,
              orElse: () => getSupportedLanguages().first
          )
      ).id;
    } catch (e){
      this.language_id = 1;
    }
  }

  @action
  Future truncateTechnicalNameWithTranslations() async {
    await _repository.truncateTechnicalNameWithTranslations();
  }

  // methods: ..................................................................
  String getTranslation(int id) {
    if (isTranslationsEmpty(id)) return "";
    try {
      return getTechnicalName(id)!
          .translations
          .firstWhere((element) => element.language_id == this.language_id)
          .translated_text;
    } catch (e) {
      return '';
    }
  }

  String getTranslationByTechnicalName(String technicalName) {
    try {
      return technicalNameWithTranslationsList.technicalNameWithTranslations
          .firstWhere((e) => e.technical_name == technicalName)
          .translations
          .firstWhere((element) => element.language_id == this.language_id)
          .translated_text;
    } catch (e) {
      return '';
    }
  }

  TechnicalNameWithTranslations? getTechnicalName(int id) {
    return technicalNameWithTranslationsList.technicalNameWithTranslations.firstWhereOrNull((element) => element.id == id);
  }

  int getTranslationsLength(int id) {
    if(getTechnicalName(id) == null) return 0;
    return getTechnicalName(id)!.translations.length;
  }

  bool isTranslationsEmpty(int id) {
    return getTranslationsLength(id) == 0;
  }

  bool isTranslationsNotEmpty(int id) {
    return !isTranslationsEmpty(id);
  }

  List<Language> getSupportedLanguages(){
    Set<String> seenLanguageCodes = {};

    List<Language> uniqueLanguages = technicalNameWithTranslationsList.technicalNameWithTranslations
        .expand((text) => text.translations)
        .map((translation) => translation.language)
        .where((lang) => seenLanguageCodes.add(lang.language_code))
        .toList();
    return uniqueLanguages;
  }
}
