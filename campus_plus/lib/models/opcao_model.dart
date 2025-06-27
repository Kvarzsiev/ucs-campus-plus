import 'package:json_annotation/json_annotation.dart';

part 'opcao_model.g.dart';

@JsonSerializable()
class Opcao {
  final String descricao;
  @JsonKey(includeToJson: false)
  final String? id;
  @JsonKey(includeToJson: false)
  final List<String>? respostas;

  // Control property, used only to keep track of user selection on screen
  @JsonKey(includeToJson: false)
  bool? selecionada;

  Opcao({this.id, required this.descricao, this.respostas, this.selecionada});

  factory Opcao.fromJson(Map<String, dynamic> json) => _$OpcaoFromJson(json);
  Map<String, dynamic> toJson() => _$OpcaoToJson(this);
}
