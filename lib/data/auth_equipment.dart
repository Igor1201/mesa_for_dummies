import 'package:json_annotation/json_annotation.dart';
import 'package:mesa_for_dummies/data/equipment.dart';

part 'auth_equipment.g.dart';

@JsonSerializable()
class AuthEquipment extends Equipment {
  @JsonKey(nullable: false)
  String username;

  @JsonKey(nullable: false)
  int characterId;

  @JsonKey(nullable: false)
  String csrfToken;

  AuthEquipment();

  factory AuthEquipment.fromJson(Map<String, dynamic> json) => _$AuthEquipmentFromJson(json);

  Map<String, dynamic> toJson() => _$AuthEquipmentToJson(this);
}
