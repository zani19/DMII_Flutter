import 'package:flutter/material.dart';
import 'pages/products_page.dart';

void main() {
  runApp(MyApp());
}

// Classe que inicia o aplicativo
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exercício 1',
      initialRoute: '/',
      routes: {
        '/': (context) => Forms(),
        '/products': (context) => ProductsPage(),
      },
    );
  }
}

// Classe que instância classe responsável por gerenciar estados
class Forms extends StatefulWidget {
  @override
  FormsState createState() => FormsState();
}

// Classe que contém os widgets
class FormsState extends State<Forms> {
  final TextEditingController _nome = TextEditingController();
  final TextEditingController _password = TextEditingController();

  Color textColor = Colors.black; // Cor padrão
  Color textColorWarning = Colors.grey; // Cor padrão
  Color borderColor = Colors.grey;

  bool envio = false;

  // Simula envio de informação
  void _enviar() {
    Navigator.pushNamed(context, '/products');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sample Input'),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 100.0), // Um retângulo para separar widgets
            Image.asset(
              'images/noCloud_logo.png',
              width: 300,
              height: 300,
            ),
            const SizedBox(height: 16.0), // Um retângulo contendo widget de entrada
            SizedBox(
              width: 300,
              child: TextField(
                controller: _nome, // Associa controle ao widget
                keyboardType: TextInputType.text, // Tipo de entrada
                decoration: InputDecoration(
                  hintText: 'Entre com nome', // Hint
                  prefixIcon: const Icon(Icons.account_circle_outlined), // Ícone
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: borderColor), // Cor da borda
                  ), // Quando receber o foco, altera cor da borda
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0), // Um retângulo contendo widget de entrada
            SizedBox(
              width: 300,
              child: TextField(
                controller: _password, // Associa controle ao widget
                keyboardType: TextInputType.text, // Tipo de entrada
                obscureText: true, // Oculta texto
                decoration: InputDecoration(
                  hintText: 'Entre com a senha', // Hint
                  prefixIcon: const Icon(Icons.lock_outline), // Ícone
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: borderColor), // Cor da borda
                  ), // Quando receber o foco, altera cor da borda
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              width: 300,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _enviar,
                    child: const Text('Enviar'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _nome.clear();
                      _password.clear();
                    },
                    child: const Text('Cancelar'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
