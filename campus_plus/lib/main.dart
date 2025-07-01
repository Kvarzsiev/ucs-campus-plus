import 'package:campus_plus/config/firebase_options.dart';
import 'package:campus_plus/services/usuario_service.dart';
import 'package:campus_plus/views/home_view.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:loader_overlay/loader_overlay.dart';

// Arquivo Main, presente no diagrama de sequências do caso de uso 06
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const CampusPlus());
}

class CampusPlus extends StatelessWidget {
  const CampusPlus({super.key});

  @override
  Widget build(BuildContext context) {
    final providers = [EmailAuthProvider()];

    return MaterialApp(
      title: 'Campus+',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      initialRoute:
          auth.FirebaseAuth.instance.currentUser == null ? '/sign-in' : '/home',
      routes: {
        '/sign-in': (context) {
          return SignInScreen(
            providers: providers,
            actions: [
              // Troca de estados presente no diagrama de sequência do caso de uso 06
              AuthStateChangeAction<UserCreated>((context, state) async {
                await novoUsuario(
                  context,
                  auth.FirebaseAuth.instance.currentUser!,
                );
              }),
              // Troca de estados presente no diagrama de sequência do caso de uso 06
              AuthStateChangeAction<SignedIn>((context, state) async {
                await autenticado(context);
              }),
              AuthStateChangeAction<AuthFailed>((context, state) {
                autenticacaoFalhou(context);
              }),
            ],
          );
        },
        '/home': (context) {
          return LoaderOverlay(child: HomeView());
        },
        '/profile': (context) {
          return ProfileScreen(
            providers: providers,
            actions: [
              SignedOutAction((context) {
                Navigator.pushReplacementNamed(context, '/sign-in');
              }),
            ],
          );
        },
      },
      locale: Locale('pt', 'BR'),
      localizationsDelegates: [
        // Creates an instance of FirebaseUILocalizationDelegate with overridden labels
        FirebaseUILocalizations.withDefaultOverrides(const PtLocalizations()),

        // Delegates below take care of built-in flutter widgets
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,

        // This delegate is required to provide the labels that are not overridden by LabelOverrides
        FirebaseUILocalizations.delegate,
      ],
    );
  }

  // Métodos presentes no diagrama de sequências do caso de uso 06
  Future<void> novoUsuario(
    BuildContext context,
    // Usuário do pacote Firebase Auth
    auth.User usuarioFirebase,
  ) async {
    await UsuarioService().criarUsuario(usuarioFirebase);
  }

  // Métodos presentes no diagrama de sequências do caso de uso 06
  Future<void> autenticado(BuildContext context) async {
    await Navigator.pushReplacementNamed(context, '/home');
  }

  // Métodos presentes no diagrama de sequências do caso de uso 06
  void autenticacaoFalhou(BuildContext context) {
    const snackBar = SnackBar(content: Text('Credenciais inválidas.'));

    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
