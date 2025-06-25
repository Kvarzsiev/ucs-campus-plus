import 'package:json_annotation/json_annotation.dart';

part 'resposta_model.g.dart';

@JsonSerializable()
class Resposta {
  final String idUsuario;

  Resposta({required this.idUsuario});

  factory Resposta.fromJson(Map<String, dynamic> json) =>
      _$RespostaFromJson(json);
  Map<String, dynamic> toJson() => _$RespostaToJson(this);
}
