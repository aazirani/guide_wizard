import 'package:boilerplate/data/repository.dart';
import 'package:boilerplate/models/language/supported_language.dart';
import 'package:boilerplate/stores/error/error_store.dart';
import 'package:mobx/mobx.dart';

part 'language_store.g.dart';

class LanguageStore = _LanguageStore with _$LanguageStore;

abstract class _LanguageStore with Store {
  static const String TAG = "LanguageStore";

  // repository instance
  final Repository _repository;

  // store for handling errors
  final ErrorStore errorStore = ErrorStore();

  // supported languages
  List<SupportedLanguage> supportedLanguages = [
    SupportedLanguage(code: 'US', locale: 'en', language: 'English'),
    SupportedLanguage(code: 'DE', locale: 'de', language: 'German'),
  ];

  // constructor:---------------------------------------------------------------
  _LanguageStore(Repository repository) : this._repository = repository {
    init();
  }

  // store variables:-----------------------------------------------------------
  @observable
  String _locale = "en";

  @observable
  int? language_id;

  @computed
  String get locale => _locale;

  // actions:-------------------------------------------------------------------
  @action
  void changeLanguage(String value) {
    _locale = value;
    _repository.changeLanguage(value).then((_) {
      // write additional logic here
    });
  }

  @action
  String getCode() {
    var code;

    if (_locale == 'en') {
      code = "US";
    } else if (_locale == 'de') {
      code = "DE";
    }

    return code;
  }

  @action
  String? getLanguage() {
    return supportedLanguages[supportedLanguages
            .indexWhere((language) => language.locale == _locale)]
        .language;
  }

  // general:-------------------------------------------------------------------
  @action
  Future init() async {
    final future = _repository.getCurrentLocale();
    future.then((currentLocale) {
      if (currentLocale != null) {
        for (var i = 0; i < supportedLanguages.length; i++) {
          if ("${supportedLanguages[i].locale! + "-" + supportedLanguages[i].code!}" ==
              currentLocale) {
            this._locale = currentLocale;
            this.language_id = i;
          }
        }
      }
    });
  }
}
