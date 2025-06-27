import 'dart:developer';

import 'package:campus_plus/models/enquete_model.dart';
import 'package:campus_plus/models/opcao_model.dart';
import 'package:campus_plus/services/usuario_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EnqueteService {
  // private static instance of the class
  static final EnqueteService _instance = EnqueteService._internal();

  // Private constructor to prevent external instantiation
  EnqueteService._internal();

  // Factory constructor to return the same instance
  factory EnqueteService() {
    return _instance;
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> validarPeriodo(Enquete enquete) async {
    if (enquete.dataInicio.isAfter(enquete.dataFim)) {
      throw FormatException('A data final deve vir depois da data inicial!');
    }

    final today = DateTime.now();
    if (today.isAfter(enquete.dataFim)) {
      throw FormatException(
        'A data final não pode ser anterior ao momento atual!',
      );
    }
  }

  Future<void> salvarEnquete(Enquete enquete) async {
    final enqueteRef = await firestore
        .collection('enquete')
        .add(enquete.toJson());

    if (enquete.opcoes != null) {
      for (final opcao in enquete.opcoes!) {
        await firestore
            .collection('enquete')
            .doc(enqueteRef.id)
            .collection('opcao')
            .add(opcao.toJson());
      }
    }
  }

  Future<List<Enquete>> carregarEnquetes({
    required bool consultaResultados,
  }) async {
    print('1');
    final hoje = DateTime.now().millisecondsSinceEpoch;
    final enquetesSnap =
        consultaResultados
            ? await FirebaseFirestore.instance.collection('enquete').get()
            : await FirebaseFirestore.instance
                .collection('enquete')
                .where('dataInicio', isLessThanOrEqualTo: hoje)
                .where('dataFim', isGreaterThanOrEqualTo: hoje)
                .get();
    print('2');

    List<Enquete> enquetes = [];

    for (final enqueteDoc in enquetesSnap.docs) {
      final opcoesSnap =
          await FirebaseFirestore.instance
              .collection('enquete')
              .doc(enqueteDoc.id)
              .collection('opcao')
              .get();
      print('3');

      try {
        List<Opcao> opcoes = [];
        for (final opcaoDoc in opcoesSnap.docs) {
          final opcao = Opcao.fromJson({...opcaoDoc.data(), 'id': opcaoDoc.id});
          opcao.selecionada = false;

          opcoes.add(opcao);
        }

        Enquete enquete = Enquete.fromJson({
          ...enqueteDoc.data(),
          'id': enqueteDoc.id,
        })..opcoes = opcoes;
        inspect(enquete);

        // Verificar se o usuário já respondeu
        final opcoesQuery =
            await FirebaseFirestore.instance
                .collection('enquete')
                .doc(enquete.id)
                .collection('opcao')
                .where(
                  'respostas',
                  arrayContains:
                      '/usuarios/${UsuarioService().retornaIdDoUsuarioAtual()}',
                )
                .get();
        print('5');

        if (opcoesQuery.docs.isNotEmpty && opcoesQuery.docs.first.exists) {
          final opcaoSelecionada = opcoesQuery.docs.first;
          enquete
              .opcoes!
              .where((op) => op.id == opcaoSelecionada.id)
              .first
              .selecionada = true;
        }
        enquetes.add(enquete);
      } catch (err) {
        inspect(err);
      }
      print('4');
    }
    print('ENQUETES ');
    print('6');

    return enquetes;
  }

  Future<void> registrarResposta(String enqueteId, String opcaoId) async {
    final usuarioId = UsuarioService().retornaIdDoUsuarioAtual();

    final reference = FirebaseFirestore.instance
        .collection('enquete')
        .doc(enqueteId)
        .collection('opcao')
        .doc(opcaoId);

    await reference.update({
      'respostas': FieldValue.arrayUnion(['/usuarios/$usuarioId']),
    });
  }
}
