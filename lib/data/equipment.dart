import 'package:json_annotation/json_annotation.dart';

part 'equipment.g.dart';

@JsonSerializable()
class Equipment {
  @JsonKey(nullable: false)
  int id;

  @JsonKey(nullable: false)
  String name;

  @JsonKey(includeIfNull: false)
  String description;

  @JsonKey(includeIfNull: false)
  double weight;
  
  @JsonKey(includeIfNull: false)
  double cost;

  @JsonKey(nullable: false)
  int quantity;

  @JsonKey(includeIfNull: false)
  String notes;

  Equipment();

  factory Equipment.fromJson(Map<String, dynamic> json) => _$EquipmentFromJson(json);

  Map<String, dynamic> toJson() => _$EquipmentToJson(this);
}
