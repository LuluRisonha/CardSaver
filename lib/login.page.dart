import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  var txtEmail = TextEditingController();
  var txtPassword = TextEditingController();

  void login(context) {
    Navigator.pushReplacementNamed(context,
        '/deck'); //substituiu a rota anterior, assim a quando se voltar ele sai do app;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 195, 201, 206),
      body: Container(
        padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: txtEmail,
              decoration: InputDecoration(
                hintText: "E-mail(required)",
                labelText: "E-mail",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 6,
            ),
            TextField(
              controller: txtPassword,
              decoration: InputDecoration(
                hintText: "Password",
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(
              height: 6,
            ),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                child: Text("Login"),
                onPressed: () => login(context),
              ),
            ),
            Container(
              width: double.infinity,
              child: TextButton(
                child: Text("New User"),
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
