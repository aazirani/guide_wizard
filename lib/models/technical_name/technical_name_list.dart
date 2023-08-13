import 'package:guide_wizard/models/technical_name/technical_name.dart';

class TechnicalNameList {
  final List<TechnicalName> technicalNames;

  TechnicalNameList({
    required this.technicalNames,
  });

  factory TechnicalNameList.fromJson(List<dynamic> json) {
    List<TechnicalName> technicalNames;
    technicalNames =
        json.map((translation) => TechnicalName.fromMap(translation)).toList();

    return TechnicalNameList(
      technicalNames: technicalNames,
    );
  }
}
