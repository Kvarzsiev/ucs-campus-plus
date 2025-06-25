import 'package:campus_plus/enums/perfil_enum.dart';
import 'package:campus_plus/models/permissao_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'perfil_permissao_model.g.dart';

@JsonSerializable()
class PerfilPermissao {
  final Perfil perfil;
  final List<Permissao> permissoes;

  PerfilPermissao({required this.perfil, required this.permissoes});

  factory PerfilPermissao.fromJson(Map<String, dynamic> json) =>
      _$PerfilPermissaoFromJson(json);
  Map<String, dynamic> toJson() => _$PerfilPermissaoToJson(this);
}
