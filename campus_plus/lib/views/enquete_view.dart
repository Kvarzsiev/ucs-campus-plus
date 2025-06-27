import 'dart:developer';

import 'package:campus_plus/models/enquete_model.dart';
import 'package:campus_plus/models/opcao_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';

class CriarEnqueteView extends StatefulWidget {
  const CriarEnqueteView({super.key});

  @override
  State<CriarEnqueteView> createState() => _CriarEnqueteViewState();
}

class _CriarEnqueteViewState extends State<CriarEnqueteView> {
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();
  final List<TextEditingController> _optionControllers = [
    TextEditingController(),
    TextEditingController(),
  ];

  DateTime? _startDate;
  TimeOfDay? _startTime;
  DateTime? _endDate;
  TimeOfDay? _endTime;

  @override
  void dispose() {
    _questionController.dispose();
    for (var controller in _optionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addOption() {
    setState(() {
      _optionControllers.add(TextEditingController());
    });
  }

  void _removeOption(int index) {
    setState(() {
      _optionControllers[index].dispose();
      _optionControllers.removeAt(index);
    });
  }

  Future<void> _selectDateTime(
    BuildContext context, {
    required bool isStart,
  }) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      locale: Locale('pt', 'BR'),
    );

    if (pickedDate != null) {
      if (context.mounted) {
        final TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );

        if (pickedTime != null) {
          setState(() {
            if (isStart) {
              _startDate = pickedDate;
              _startTime = pickedTime;
            } else {
              _endDate = pickedDate;
              _endTime = pickedTime;
            }
          });
        }
      }
    }
  }

  String _formatDateTime(DateTime? date, TimeOfDay? time) {
    if (date != null && time != null) {
      final dateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
      return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
    }
    return 'Não definido';
  }

  void _createPoll() async {
    if (_formKey.currentState!.validate()) {
      context.loaderOverlay.show();
      // Processar os dados da enquete
      final question = _questionController.text;
      final options =
          _optionControllers
              .map((controller) => Opcao(descricao: controller.text))
              .toList();
      final startDateTime = DateTime(
        _startDate!.year,
        _startDate!.month,
        _startDate!.day,
        _startTime!.hour,
        _startTime!.minute,
      );
      final endDateTime = DateTime(
        _endDate!.year,
        _endDate!.month,
        _endDate!.day,
        _endTime!.hour,
        _endTime!.minute,
      );

      inspect(options);

      try {
        await Enquete(
          pergunta: question,
          dataInicio: startDateTime,
          dataFim: endDateTime,
          opcoes: options,
        ).criarEnquete();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Enquete criada com sucesso!')),
          );

          clear();
        }
      } on FormatException catch (exception) {
        inspect(exception);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(exception.message),
            ),
          );
        }
      } finally {
        if (mounted) {
          context.loaderOverlay.hide();
        }
      }
    }
  }

  void clear() {
    _questionController.clear();
    for (final controller in _optionControllers) {
      controller.clear();
    }

    setState(() {
      _startDate = null;
      _startTime = null;
      _endDate = null;
      _endTime = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pergunta da Enquete',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _questionController,
              decoration: const InputDecoration(
                hintText: 'Digite a pergunta aqui',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira a pergunta.';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'Opções',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _optionControllers.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _optionControllers[index],
                          decoration: InputDecoration(
                            hintText: 'Opção ${index + 1}',
                            border: const OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Opção não pode ser vazia.';
                            }
                            return null;
                          },
                        ),
                      ),
                      if (_optionControllers.length > 2)
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: () => _removeOption(index),
                        ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: _addOption,
                icon: const Icon(Icons.add),
                label: const Text('Adicionar Opção'),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Período da Enquete',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _inputData(context, isStart: true),
                const SizedBox(width: 16),
                _inputData(context, isStart: false),
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _createPoll,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Criar Enquete'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Expanded _inputData(BuildContext context, {required bool isStart}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(isStart ? 'Início' : 'Fim'),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => _selectDateTime(context, isStart: isStart),
            child: AbsorbPointer(
              child: TextFormField(
                decoration: InputDecoration(
                  hintText:
                      isStart
                          ? _formatDateTime(_startDate, _startTime)
                          : _formatDateTime(_endDate, _endTime),
                  border: const OutlineInputBorder(),
                  suffixIcon: const Icon(Icons.calendar_today),
                ),
                validator: (value) {
                  if (isStart) {
                    if (_startDate == null || _startTime == null) {
                      return 'Defina a data e hora de início.';
                    }
                  } else {
                    if (_endDate == null || _endTime == null) {
                      return 'Defina a data e hora de fim.';
                    }
                  }
                  return null;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
