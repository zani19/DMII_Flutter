import 'dart:convert';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;

class NotasAlunosPage extends StatefulWidget {
  const NotasAlunosPage({super.key});

  @override
  NotasAlunosPageState createState() => NotasAlunosPageState();
}

class NotasAlunosPageState extends State<NotasAlunosPage> {
  List<dynamic> dataList = [];

  Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse('http://demo0152687.mockable.io/notasAlunos'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      setState(() {
        dataList = jsonResponse['notasAlunos'];
      });
    } else {
      print('Requisição falhou com o status: ${response.statusCode}.');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData(); // Chama fetchData ao inicializar o estado
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Avaliação 01 - Notas Alunos',
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Avaliação 01 - Notas Alunos'),
          ),
          body: ListView.builder(
            itemCount: dataList.length,
            itemBuilder: (BuildContext context, int index) {
              final item = dataList[index];
              return Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                decoration: BoxDecoration(
                  color: (index % 2 == 0 ? Colors.grey : Colors.grey[400]),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ListTile(
                  title: Text(
                      '${item['matricula']} - ${item['name']} - ${item['nota']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Matrícula: ${item['matricula']}'),
                      Text('Aluno: ${item['name']}'),
                      Text('Nota: ${item['nota']}'),
                    ],
                  ),
                ),
              );
            },
          )),
    );
  }
}
