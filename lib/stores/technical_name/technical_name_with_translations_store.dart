import 'package:boilerplate/models/technical_name/technical_name.dart';
import 'package:boilerplate/models/technical_name/technical_name_with_translations.dart';
import 'package:boilerplate/models/technical_name/technical_name_with_translations_list.dart';
import 'package:get/get.dart';
import 'package:mobx/mobx.dart';
import 'package:boilerplate/data/repository.dart';

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
  void getCurrentLan(int language_id) {
    this.language_id = language_id;
  }

  @action
  Future truncateTechnicalNameWithTranslations() async {
    await _repository.truncateTechnicalNameWithTranslations();
  }

  // methods: ..................................................................
  String? getTranslation(int id) {
    if(isTranslationsEmpty(id)) return "";
    return getTechnicalName(id)!.translations[this.language_id!].translated_text;
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
}
