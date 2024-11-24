import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:simulado/pages/clients_page.dart';
import 'package:simulado/pages/home.dart';
import 'package:simulado/pages/products_page.dart';
import 'pages/create_order_page.dart';
import 'pages/orders_page.dart';
import 'utils/database_helper.dart';

void main() {
  runApp(const MyApp());
}

// Classe que inicia o aplicativo
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simulado',
      initialRoute: '/',
      routes: {
        '/': (context) => const Forms(),
        '/home': (context) => const HomePage(),
        '/clients': (context) => const ClientsPage(),
        '/products': (context) => const ProductsPage(),
        '/orders': (context) => const OrdersPage(),
        '/create_order': (context) => const CreateOrderPage(),
      },
    );
  }
}

// Classe que instância classe responsável por gerenciar estados
class Forms extends StatefulWidget {
  const Forms({super.key});

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
  Future<void> _enviar() async {
    await _syncData();
    Navigator.pushNamed(context, '/home');
  }

  Future<void> _syncData() async {
    final dbHelper = DatabaseHelper();

    // Sincronizar produtos
    final produtosResponse = await http.get(Uri.parse('http://demo0152687.mockable.io/produtos'));
    if (produtosResponse.statusCode == 200) {
      final produtosJson = json.decode(produtosResponse.body);
      for (var produto in produtosJson['produtos']) {
        await dbHelper.insertProduto(produto);
      }
    } else {
      print('Falha ao sincronizar produtos: ${produtosResponse.statusCode}');
    }

    // Sincronizar clientes
    final clientesResponse = await http.get(Uri.parse('http://demo0152687.mockable.io/clientes'));
    if (clientesResponse.statusCode == 200) {
      final clientesJson = json.decode(clientesResponse.body);
      for (var cliente in clientesJson['clientes']) {
        await dbHelper.insertCliente(cliente);
      }
    } else {
      print('Falha ao sincronizar clientes: ${clientesResponse.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercício 1'),
      ),
      body: SingleChildScrollView( // Adiciona SingleChildScrollView
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 100.0), // Um retângulo para separar widgets
              Image.asset(
                'images/logo.jpg',
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
      ),
    );
  }
}
