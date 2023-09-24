import 'package:guide_wizard/models/technical_name/technical_name.dart';
import 'package:mobx/mobx.dart';

class TechnicalNameList {

  @observable
  final ObservableList<TechnicalName> technicalNames;

  TechnicalNameList({
    required this.technicalNames,
  });

  @action
  factory TechnicalNameList.fromJson(List<dynamic> json) {
    List<TechnicalName> technicalNames;
    technicalNames =
        json.map((translation) => TechnicalNameFactory().fromMap(translation)).toList();

    return TechnicalNameList(
      technicalNames: ObservableList<TechnicalName>.of(technicalNames),
    );
  }
}
