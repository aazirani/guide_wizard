import 'package:guide_wizard/models/translation/translation.dart';
import 'package:mobx/mobx.dart';

// Include generated file
part 'technical_name_with_translations.g.dart';

// This is the class used by rest of your codebase
class TechnicalNameWithTranslations = _TechnicalNameWithTranslations
    with _$TechnicalNameWithTranslations;

abstract class _TechnicalNameWithTranslations with Store {
  @observable
  int id;

  @observable
  String technical_name;

  @observable
  int creator_id;

  @observable
  String created_at;

  @observable
  String updated_at;

  @observable
  ObservableList<Translation> translations;

  _TechnicalNameWithTranslations({
    required this.id,
    required this.technical_name,
    required this.creator_id,
    required this.created_at,
    required this.updated_at,
    required this.translations,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "technical_name": technical_name,
      "creator_id": creator_id,
      "created_at": created_at,
      "updated_at": updated_at,
      "translations":
          translations.map((translation) => translation.toMap()).toList(),
    };
  }
}

class TechnicalNameWithTranslationsFactory {
  TechnicalNameWithTranslations fromMap(Map<String, dynamic> json) {
    return TechnicalNameWithTranslations(
      id: json["id"],
      technical_name: json["technical_name"],
      creator_id: json["creator_id"],
      created_at: json["created_at"],
      updated_at: json["updated_at"],
      translations: ObservableList.of(json["translations"]
          .map((translation) => TranslationFactory().fromMap(translation))
          .toList()
          .cast<Translation>()),
    );
  }
}
