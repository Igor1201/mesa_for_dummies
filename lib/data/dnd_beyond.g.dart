// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dnd_beyond.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DNDBeyond _$DNDBeyondFromJson(Map<String, dynamic> json) {
  return DNDBeyond()
    ..customItems = (json['customItems'] as List)
        .map((e) => Equipment.fromJson(e as Map<String, dynamic>))
        .toList();
}

Map<String, dynamic> _$DNDBeyondToJson(DNDBeyond instance) =>
    <String, dynamic>{'customItems': _equipmentsToJson(instance.customItems)};
