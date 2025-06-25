import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ResponderEnqueteView extends StatefulWidget {
  const ResponderEnqueteView({super.key});

  @override
  State<ResponderEnqueteView> createState() => _ResponderEnqueteViewState();
}

class _ResponderEnqueteViewState extends State<ResponderEnqueteView> {
  Future<List<QueryDocumentSnapshot>> buscarEnquetesDoDia() async {
    final hoje = DateTime.now();

    final snapshot =
        await FirebaseFirestore.instance
            .collection('enquetes')
            .where('inicio', isLessThanOrEqualTo: hoje)
            .where('fim', isGreaterThanOrEqualTo: hoje)
            .get();

    return snapshot.docs;
  }

  final Map<String, String> respostas =
      {}; // id da enquete -> opção selecionada

  void responderEnquete(String enqueteId, String opcao) async {
    // Exemplo de gravação: cria subcoleção 'respostas' com opção escolhida
    await FirebaseFirestore.instance
        .collection('enquetes')
        .doc(enqueteId)
        .collection('respostas')
        .add({'opcao': opcao, 'respondidoEm': Timestamp.now()});

    setState(() {
      respostas[enqueteId] = opcao;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Enquetes do Dia")),
      body: FutureBuilder<List<QueryDocumentSnapshot>>(
        future: buscarEnquetesDoDia(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final enquetes = snapshot.data ?? [];

          if (enquetes.isEmpty) {
            return Center(child: Text("Nenhuma enquete ativa hoje."));
          }

          return ListView.builder(
            itemCount: enquetes.length,
            itemBuilder: (context, index) {
              final enquete = enquetes[index];
              final id = enquete.id;
              final pergunta = enquete['pergunta'];
              final opcoes = List<String>.from(enquete['opcoes']);
              final selecionada = respostas[id];

              return Card(
                margin: EdgeInsets.all(12),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pergunta,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      ...opcoes.map((opcao) {
                        final jaRespondido = selecionada != null;
                        final marcado = selecionada == opcao;

                        return RadioListTile<String>(
                          title: Text(opcao),
                          value: opcao,
                          groupValue: selecionada,
                          onChanged:
                              jaRespondido
                                  ? null
                                  : (value) => responderEnquete(id, value!),
                        );
                      }),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
