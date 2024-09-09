import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  List<dynamic> dataList = [];
  // método assíncrono para consumir informações de uma api
  Future<void> fetchData() async {
    // realiza a requisição
    final response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));
    // verifica êxito da requisição
    if (response.statusCode == 200) {
      // converte resposta em objeto json
      final jsonResponse = json.decode(response.body);
      // atualiza state
      setState(() {
        dataList = jsonResponse;
      });
    } else {
      // erro na requisição
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Atividade 02',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('HTTP - Consumir serviços rest (API)'),
        ),
        body: ListView.builder(
          itemCount: dataList.length,
          itemBuilder: (BuildContext context, int index) {
            final item = dataList[index];
            return Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                decoration: BoxDecoration(
                  color: (index%2==0?Colors.grey:Colors.grey[400]), // Cor de fundo do retângulo
                  borderRadius: BorderRadius.circular(10.0), // Raio 
                ),
                child: ListTile(
                  title: Text('${item['id']} - ${item['name']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Usuário: ${item['username']}'),
                      Text('E-mail: ${item['email']}'),
                      Text(
                        'Endereço: ${item['address']['street']}, ${item['address']['suite']}; Cidade: ${item['address']['city']}; Zipcode: ${item['address']['zipcode']}; Lat: ${item['address']['geo']['lat']}; Long: ${item['address']['geo']['lng']}'),
                      Text('Telefone: ${item['phone']}'),
                      Text('Site: ${item['website']}'),
                      Text('Empresa: ${item['company']['name']}, ${item['company']['catchPhrase']}, ${item['company']['bs']}'),
                    ],

                  ),
                ));
          },
        ),
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}


