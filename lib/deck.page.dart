import 'package:flutter/material.dart';

class DeckPage extends StatelessWidget {
  var txtMessage = TextEditingController();

  get body => null;

  //const ChatPage({super.key});
  void signOut(context) {
    Navigator.pushReplacementNamed(context, '/login');
  }

  void SendCamera(context) {
    Navigator.pushReplacementNamed(context, '/camera');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 181, 190, 195),
      appBar: AppBar(
        title: Text('CardSaver'),
        actions: [
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                onPressed: () => signOut(context),
                icon: Icon(Icons.logout),
              )),
        ],
      ),
      body: Stack(
        children: <Widget>[
          // Conteúdo principal da tela pode ir aqui, como uma imagem, lista, etc.
          Center(
            child: Text(
              'Deck',
              style: TextStyle(fontSize: 24),
            ),
          ),
          // Botão na parte inferior central
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(
                  bottom: 20.0), // Espaçamento da parte inferior
              child: IconButton(
                  icon: Icon(Icons.add),
                  iconSize: 50.0, // Tamanho do ícone
                  color: const Color.fromARGB(255, 31, 32, 32), // Cor do ícone
                  onPressed: () {
                    Navigator.pushNamed(context, '/camera');
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
