// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'opcao_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Opcao _$OpcaoFromJson(Map<String, dynamic> json) => Opcao(
  id: json['id'] as String?,
  descricao: json['descricao'] as String,
  respostas:
      (json['respostas'] as List<dynamic>?)?.map((e) => e as String).toList(),
  selecionada: json['selecionada'] as bool?,
);

Map<String, dynamic> _$OpcaoToJson(Opcao instance) => <String, dynamic>{
  'descricao': instance.descricao,
};
