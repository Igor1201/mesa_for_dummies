// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'equipment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Equipment _$EquipmentFromJson(Map<String, dynamic> json) {
  return Equipment()
    ..id = json['id'] as int
    ..name = json['name'] as String
    ..description = json['description'] as String
    ..weight = (json['weight'] as num)?.toDouble()
    ..cost = (json['cost'] as num)?.toDouble()
    ..quantity = json['quantity'] as int
    ..notes = json['notes'] as String;
}

Map<String, dynamic> _$EquipmentToJson(Equipment instance) {
  var val = <String, dynamic>{
    'id': instance.id,
    'name': instance.name,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('description', instance.description);
  writeNotNull('weight', instance.weight);
  writeNotNull('cost', instance.cost);
  val['quantity'] = instance.quantity;
  writeNotNull('notes', instance.notes);
  return val;
}
