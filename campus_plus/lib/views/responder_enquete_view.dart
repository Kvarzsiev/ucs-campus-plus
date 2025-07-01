import 'dart:developer';

import 'package:campus_plus/models/enquete_model.dart';
import 'package:campus_plus/services/enquete_service.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';

class ResponderEnqueteView extends StatefulWidget {
  const ResponderEnqueteView({super.key});

  @override
  State<ResponderEnqueteView> createState() => _ResponderEnqueteViewState();
}

class _ResponderEnqueteViewState extends State<ResponderEnqueteView> {
  late Future<List<Enquete>> _enquetes;

  final _service = EnqueteService();

  final Map<String, String?> _radioInputControllers = {};

  @override
  void initState() {
    super.initState();
    try {
      _enquetes = _service.carregarEnquetes(consultaResultados: false);
    } catch (err) {
      inspect(err);
    }
  }

  bool _answerMode = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _answerMode = true;
                    _enquetes = _service.carregarEnquetes(
                      consultaResultados: false,
                    );
                  });
                },
                style: ButtonStyle(
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(side: BorderSide.none),
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.indigo,
                        width: _answerMode ? 2 : 0,
                      ),
                    ),
                  ),
                  child: Text(
                    'Responder Enquetes',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _answerMode = false;
                    _enquetes = _service.carregarEnquetes(
                      consultaResultados: true,
                    );
                  });
                },
                style: ButtonStyle(
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(side: BorderSide.none),
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.indigo,
                        width: !_answerMode ? 2 : 0,
                      ),
                    ),
                  ),
                  child: Text(
                    'Consultar respostas',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: FutureBuilder<List<Enquete>>(
              future: _enquetes,
              builder: (context, snapshot) {
                print('snapshot.hasData: ${snapshot.hasData}');
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final enquetes = snapshot.data!;

                if (enquetes.isEmpty) {
                  return Center(child: Text("Nenhuma enquete disponível."));
                }

                return ListView.builder(
                  itemCount: enquetes.length,
                  itemBuilder: (context, index) {
                    final enquete = enquetes[index];
                    final enqueteId = enquete.id!;

                    int numeroTotalRespostas = 0;
                    enquete.opcoes?.forEach(
                      (opcao) =>
                          numeroTotalRespostas += opcao.respostas?.length ?? 0,
                    );

                    final opcaoSelecionada =
                        enquete.opcoes!
                            .where((op) => op.selecionada == true)
                            .firstOrNull;

                    if (opcaoSelecionada != null) {
                      final Map<String, String?> selected = {
                        enqueteId: opcaoSelecionada.id,
                      };

                      _radioInputControllers.addAll(selected);
                    }

                    return Card(
                      margin: EdgeInsets.all(12),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              enquete.pergunta,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            ...enquete.opcoes!.map((opcao) {
                              if (_answerMode) {
                                return RadioListTile<String>(
                                  title: Text(opcao.descricao),
                                  value: opcao.id!,
                                  groupValue: _radioInputControllers[enqueteId],
                                  onChanged:
                                      _radioInputControllers[enqueteId] != null
                                          ? null
                                          : (value) => _registrarResposta(
                                            value,
                                            enqueteId,
                                          ),
                                );
                              } else {
                                final numRespostas =
                                    opcao.respostas?.length ?? 0;

                                final porcentagem =
                                    numeroTotalRespostas > 0 && numRespostas > 0
                                        ? '- ${(numeroTotalRespostas / numRespostas) * 100}% do total'
                                        : '';

                                return ListTile(
                                  title: Text(opcao.descricao),
                                  subtitle: Text(
                                    'Número de respostas: $numRespostas $porcentagem',
                                  ),
                                );
                              }
                            }),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _registrarResposta(String? value, String enqueteId) async {
    inspect({'VALUE': value});
    inspect({'ENQUETE ID ': enqueteId});
    context.loaderOverlay.show();

    setState(() {
      _radioInputControllers[enqueteId] = value;
      _radioInputControllers.update(
        enqueteId,
        (_) => value,
        ifAbsent: () => value,
      );
    });

    await EnqueteService().registrarResposta(enqueteId, value!);

    if (mounted) {
      context.loaderOverlay.hide();
      inspect(_radioInputControllers);
    }
  }
}
