import 'package:campus_plus/enums/perfil_enum.dart';
import 'package:json_annotation/json_annotation.dart';

part 'usuario_model.g.dart';

@JsonSerializable()
class Usuario {
  final String email;
  final String nome;
  final Perfil perfil;

  Usuario({required this.email, required this.nome, required this.perfil});

  factory Usuario.fromJson(Map<String, dynamic> json) =>
      _$UsuarioFromJson(json);
  Map<String, dynamic> toJson() => _$UsuarioToJson(this);
}
