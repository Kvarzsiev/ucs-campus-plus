import 'package:campus_plus/models/enquete_model.dart';
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

    print("Enquete adicionada, ID: ${enqueteRef.id}");

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
}
