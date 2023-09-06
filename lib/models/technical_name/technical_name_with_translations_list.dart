import 'package:guide_wizard/models/technical_name/technical_name_with_translations.dart';
import 'package:mobx/mobx.dart';

class TechnicalNameWithTranslationsList {
  @observable
  ObservableList<TechnicalNameWithTranslations> technicalNameWithTranslations;

  TechnicalNameWithTranslationsList({
    required this.technicalNameWithTranslations,
  });

  @action
  factory TechnicalNameWithTranslationsList.fromJson(List<dynamic> json) {
    ObservableList<TechnicalNameWithTranslations> list = new ObservableList();
    json.forEach((translationsWithStepName) => list.add(
        TechnicalNameWithTranslationsFactory()
            .fromMap(translationsWithStepName)));
    return TechnicalNameWithTranslationsList(
      technicalNameWithTranslations: list,
    );
  }
}
