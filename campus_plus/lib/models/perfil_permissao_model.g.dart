// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'perfil_permissao_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PerfilPermissao _$PerfilPermissaoFromJson(Map<String, dynamic> json) =>
    PerfilPermissao(
      perfil: $enumDecode(_$PerfilEnumMap, json['perfil']),
      permissoes:
          (json['permissoes'] as List<dynamic>)
              .map((e) => Permissao.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$PerfilPermissaoToJson(PerfilPermissao instance) =>
    <String, dynamic>{
      'perfil': _$PerfilEnumMap[instance.perfil]!,
      'permissoes': instance.permissoes,
    };

const _$PerfilEnumMap = {
  Perfil.estudante: 'estudante',
  Perfil.professor: 'professor',
  Perfil.administrativo: 'administrativo',
};
