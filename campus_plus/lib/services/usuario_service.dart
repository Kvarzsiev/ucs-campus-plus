import 'package:campus_plus/models/usuario_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// UsuarioService foi diagramado no diagrama de projeto
class UsuarioService {
  // private static instance of the class
  static final UsuarioService _instance = UsuarioService._internal();

  // Private constructor to prevent external instantiation
  UsuarioService._internal();

  // Factory constructor to return the same instance
  factory UsuarioService() {
    return _instance;
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> criarUsuario(User user) async {
    final usuario = Usuario();

    await firestore.collection('usuarios').add(usuario.toJson());
  }

  String retornaIdDoUsuarioAtual() {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String uid = user.uid;
      return uid;
    }
    throw FormatException('Usuário não logado');
  }
}
