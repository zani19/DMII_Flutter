import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  FormsState createState() => FormsState();
}

class FormsState extends State<LoginPage> {
  final TextEditingController _nome = TextEditingController();
  final TextEditingController _password = TextEditingController();

  Color textColor = Colors.black; // Cor padrão
  Color textColorWarning = Colors.grey; // Cor padrão
  Color borderColor = Colors.grey;

  bool envio = false;

  Future<void> _enviar() async {
    final response = await http.post(
      Uri.parse('http://demo0152687.mockable.io/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'nome': _nome.text,
        'password': _password.text,
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final token = jsonResponse['token'];

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Token Recebido'),
              content: Text('Token: $token'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/notas');
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Avaliação 1 - Tela de Login'),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _nome,
                decoration: InputDecoration(
                  labelText: 'Nome',
                  labelStyle: TextStyle(color: textColor),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: borderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: borderColor),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _password,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  labelStyle: TextStyle(color: textColor),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: borderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: borderColor),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: _enviar,
                child: const Text('Enviar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
