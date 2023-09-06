import 'package:mobx/mobx.dart';

// Include generated file
part 'technical_name.g.dart';

// This is the class used by rest of your codebase
class TechnicalName = _TechnicalName with _$TechnicalName;

abstract class _TechnicalName with Store {
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

  _TechnicalName({
    required this.id,
    required this.technical_name,
    required this.creator_id,
    required this.created_at,
    required this.updated_at,
  });

  Map<String, dynamic> toMap() => {
        "id": id,
        "technical_name": technical_name,
        "creator_id": creator_id,
        "created_at": created_at,
        "updated_at": updated_at,
      };
}

class TechnicalNameFactory {
  TechnicalName fromMap(Map<String, dynamic> json) {
    return TechnicalName(
      id: json["id"],
      technical_name: json["technical_name"],
      creator_id: json["creator_id"],
      created_at: json["created_at"],
      updated_at: json["updated_at"],
    );
  }
}
