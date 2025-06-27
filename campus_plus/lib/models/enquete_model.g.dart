// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enquete_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Enquete _$EnqueteFromJson(Map<String, dynamic> json) => Enquete(
  pergunta: json['pergunta'] as String,
  dataInicio: Enquete.dateTimeFromJson((json['dataInicio'] as num).toInt()),
  dataFim: Enquete.dateTimeFromJson((json['dataFim'] as num).toInt()),
  id: json['id'] as String?,
  opcoes:
      (json['opcoes'] as List<dynamic>?)
          ?.map((e) => Opcao.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$EnqueteToJson(Enquete instance) => <String, dynamic>{
  'pergunta': instance.pergunta,
  'dataInicio': Enquete.dateTimeToJson(instance.dataInicio),
  'dataFim': Enquete.dateTimeToJson(instance.dataFim),
};
