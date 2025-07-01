import 'package:campus_plus/models/opcao_model.dart';
import 'package:campus_plus/services/enquete_service.dart';
import 'package:json_annotation/json_annotation.dart';

part 'enquete_model.g.dart';

// Enquete está presente tanto no diagrama de classes quanto no de projeto
@JsonSerializable()
class Enquete {
  final String pergunta;
  @JsonKey(toJson: dateTimeToJson, fromJson: dateTimeFromJson)
  final DateTime dataInicio;
  @JsonKey(toJson: dateTimeToJson, fromJson: dateTimeFromJson)
  final DateTime dataFim;
  @JsonKey(includeToJson: false)
  final String? id;
  @JsonKey(includeToJson: false)
  List<Opcao>? opcoes;

  Enquete({
    required this.pergunta,
    required this.dataInicio,
    required this.dataFim,
    this.id,
    this.opcoes,
  });

  factory Enquete.fromJson(Map<String, dynamic> json) =>
      _$EnqueteFromJson(json);
  Map<String, dynamic> toJson() => _$EnqueteToJson(this);

  static int dateTimeToJson(DateTime date) => date.millisecondsSinceEpoch;
  static DateTime dateTimeFromJson(int millisecondsSinceEpoch) =>
      DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);

  Future<void> criarEnquete() async {
    await EnqueteService().validarPeriodo(this);
    await EnqueteService().salvarEnquete(this);
  }
}
