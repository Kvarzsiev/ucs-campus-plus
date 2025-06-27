import 'package:campus_plus/models/perfil_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'usuario_model.g.dart';

@JsonSerializable()
class Usuario {
  final String? id;
  @JsonKey(toJson: perfilToJson, includeFromJson: false)
  final Perfil? perfil;

  Usuario({this.id, this.perfil});

  factory Usuario.fromJson(Map<String, dynamic> json) =>
      _$UsuarioFromJson(json);
  Map<String, dynamic> toJson() => _$UsuarioToJson(this);

  static String perfilToJson(Perfil perfil) => '/perfis/${perfil.id}';
}
