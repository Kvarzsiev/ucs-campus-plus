// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'opcao_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Opcao _$OpcaoFromJson(Map<String, dynamic> json) => Opcao(
  id: json['id'] as String?,
  descricao: json['descricao'] as String,
  respostas:
      (json['respostas'] as List<dynamic>?)
          ?.map((e) => Resposta.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$OpcaoToJson(Opcao instance) => <String, dynamic>{
  'descricao': instance.descricao,
};
