import 'package:json_annotation/json_annotation.dart';

part 'permissao_model.g.dart';

@JsonSerializable()
class Permissao {
  final String nome;
  final String descricao;

  Permissao({required this.nome, required this.descricao});

  factory Permissao.fromJson(Map<String, dynamic> json) =>
      _$PermissaoFromJson(json);
  Map<String, dynamic> toJson() => _$PermissaoToJson(this);
}
