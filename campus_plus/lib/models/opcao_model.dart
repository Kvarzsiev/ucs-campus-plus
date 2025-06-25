import 'package:campus_plus/models/resposta_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'opcao_model.g.dart';

@JsonSerializable()
class Opcao {
  final String descricao;
  @JsonKey(includeToJson: false)
  final String? id;
  @JsonKey(includeToJson: false)
  final List<Resposta>? respostas;

  Opcao({this.id, required this.descricao, this.respostas});

  factory Opcao.fromJson(Map<String, dynamic> json) => _$OpcaoFromJson(json);
  Map<String, dynamic> toJson() => _$OpcaoToJson(this);
}
