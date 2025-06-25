// Define a tela principal (HomeScreen).
import 'package:campus_plus/views/enquete_view.dart';
import 'package:campus_plus/views/responder_enquete_view.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  // Índice da aba atualmente selecionada. Inicia na primeira aba (0).
  int _selectedIndex = 0;

  // Lista de títulos para a AppBar, correspondendo a cada aba.
  static const List<String> _appBarTitles = <String>[
    'Home',
    'Gerar Enquete',
    'Responder Enquete',
    'Meu Perfil',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitles[_selectedIndex]),
        centerTitle: true,
      ),
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.blueGrey,
        // Itens (abas) da barra de navegação.
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.add_chart), label: 'Gerar'),
          BottomNavigationBarItem(
            icon: Icon(Icons.question_answer_outlined),
            label: 'Responder',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Perfil',
          ),
        ],
        // Índice do item atualmente selecionado.
        currentIndex: _selectedIndex,
        // Função a ser chamada quando um item é tocado.
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    // Atualiza o estado para redesenhar a tela com a nova aba selecionada.
    setState(() {
      _selectedIndex = index;
    });
  }

  // Lista de widgets (telas) para exibir, correspondendo a cada aba.
  // Aqui, usamos widgets de exemplo para demonstração.
  static final List<Widget> _widgetOptions = <Widget>[
    // Tela Home
    Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[Icon(Icons.home, size: 80), SizedBox(height: 20)],
      ),
    ),
    // Tela para "Gerar Enquete"
    CriarEnqueteView(),
    // Tela para "Responder Enquete"
    ResponderEnqueteView(),
    // Tela para "Perfil"
    Center(
      child: ProfileScreen(
        providers: [EmailAuthProvider()],
        actions: [
          SignedOutAction((context) {
            Navigator.pushReplacementNamed(context, '/sign-in');
          }),
        ],
      ),
    ),
  ];
}
