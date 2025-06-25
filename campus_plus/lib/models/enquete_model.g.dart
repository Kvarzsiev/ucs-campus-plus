// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enquete_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Enquete _$EnqueteFromJson(Map<String, dynamic> json) => Enquete(
  pergunta: json['pergunta'] as String,
  dataInicio: DateTime.parse(json['dataInicio'] as String),
  dataFim: DateTime.parse(json['dataFim'] as String),
  id: json['id'] as String?,
  opcoes:
      (json['opcoes'] as List<dynamic>?)
          ?.map((e) => Opcao.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$EnqueteToJson(Enquete instance) => <String, dynamic>{
  'pergunta': instance.pergunta,
  'dataInicio': instance.dataInicio.toIso8601String(),
  'dataFim': instance.dataFim.toIso8601String(),
};
