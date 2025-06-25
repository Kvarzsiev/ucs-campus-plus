// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usuario_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Usuario _$UsuarioFromJson(Map<String, dynamic> json) => Usuario(
  email: json['email'] as String,
  nome: json['nome'] as String,
  perfil: $enumDecode(_$PerfilEnumMap, json['perfil']),
);

Map<String, dynamic> _$UsuarioToJson(Usuario instance) => <String, dynamic>{
  'email': instance.email,
  'nome': instance.nome,
  'perfil': _$PerfilEnumMap[instance.perfil]!,
};

const _$PerfilEnumMap = {
  Perfil.estudante: 'estudante',
  Perfil.professor: 'professor',
  Perfil.administrativo: 'administrativo',
};
