import 'package:json_annotation/json_annotation.dart';

part 'perfil_model.g.dart';

// Perfil está presente tanto no diagrama de classes quanto no de projeto
@JsonSerializable()
class Perfil {
  final String? id;
  final String nome;
  final String descricao;
  final List<String> permissoes;

  Perfil({
    this.id,
    required this.nome,
    required this.descricao,
    required this.permissoes,
  });

  factory Perfil.fromJson(Map<String, dynamic> json) => _$PerfilFromJson(json);
  Map<String, dynamic> toJson() => _$PerfilToJson(this);
}
