import 'package:guide_wizard/models/translation/translation.dart';
import 'package:mobx/mobx.dart';

class TranslationList {

  @observable
  final ObservableList<Translation> translations;

  TranslationList({
    required this.translations,
  });

  @action
  factory TranslationList.fromJson(List<dynamic> json) {
    ObservableList<Translation> translations;
    translations = ObservableList<Translation>.of(json.map((translation) => TranslationFactory().fromMap(translation)));

    return TranslationList(
      translations: translations,
    );
  }
}
