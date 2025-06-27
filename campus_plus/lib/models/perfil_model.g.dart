// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'perfil_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Perfil _$PerfilFromJson(Map<String, dynamic> json) => Perfil(
  id: json['id'] as String?,
  nome: json['nome'] as String,
  descricao: json['descricao'] as String,
  permissoes:
      (json['permissoes'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$PerfilToJson(Perfil instance) => <String, dynamic>{
  'id': instance.id,
  'nome': instance.nome,
  'descricao': instance.descricao,
  'permissoes': instance.permissoes,
};
