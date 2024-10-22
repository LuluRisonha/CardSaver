import 'package:flutter/material.dart';

class ListarPage extends StatelessWidget {
  var txtMessage = TextEditingController();

  //const ChatPage({super.key});
  void signOut(context) {
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 181, 190, 195),
      appBar: AppBar(
        title: Text(''),
        actions: [
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                onPressed: () => signOut(context),
                icon: Icon(Icons.logout),
              )),
        ],
      ),
      body: Center(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(
                bottom: 20.0), // Espaçamento da parte inferior
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: Size(200, 60), // Largura e altura
                side:
                    const BorderSide(color: Color.fromARGB(255, 242, 245, 242)),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
              onPressed: () {},
              child: const Text('Exportar',
                  style: TextStyle(color: Color.fromARGB(255, 10, 10, 10))),
            ),
          ),
        ),
      ),
    );
  }
}
