import 'package:json_annotation/json_annotation.dart';
import 'package:mesa_for_dummies/data/equipment.dart';

part 'dnd_beyond.g.dart';

List _equipmentsToJson(List<Equipment> equipments) => equipments.map((o) => o.toJson()).toList();

@JsonSerializable()
class DNDBeyond {
  @JsonKey(nullable: false, toJson: _equipmentsToJson)
  List<Equipment> customItems;

  DNDBeyond();

  factory DNDBeyond.fromJson(Map<String, dynamic> json) => _$DNDBeyondFromJson(json);

  Map<String, dynamic> toJson() => _$DNDBeyondToJson(this);
}
