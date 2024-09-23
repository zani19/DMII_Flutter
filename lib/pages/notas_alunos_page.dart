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
  List<dynamic> filteredList = [];
  int currentFilter = 0;

  Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse('http://demo0152687.mockable.io/notasAlunos'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      setState(() {
        dataList = jsonResponse['notasAlunos'];
        filteredList = dataList;
      });
    } else {
      print('Requisição falhou com o status: ${response.statusCode}.');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void filterByNota(int filterType) {
    setState(() {
      currentFilter = filterType;
      if (filterType == 1) {
        filteredList = dataList.where((item) => item['nota'] < 60).toList();
      } else if (filterType == 2) {
        filteredList = dataList
            .where((item) => item['nota'] >= 60 && item['nota'] < 100)
            .toList();
      } else if (filterType == 3) {
        filteredList = dataList.where((item) => item['nota'] == 100).toList();
      } else {
        filteredList = dataList;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Avaliação 01 - Notas Alunos',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Avaliação 01 - Notas Alunos'),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: filteredList.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = filteredList[index];
                  Color backgroundColor;

                  if (currentFilter == 0) {
                    backgroundColor =
                        (index % 2 == 0) ? Colors.grey : Colors.grey[400]!;
                  } else {
                    if (item['nota'] < 60) {
                      backgroundColor = Colors.yellow;
                    } else if (item['nota'] == 100) {
                      backgroundColor = Colors.green;
                    } else {
                      backgroundColor = Colors.blue;
                    }
                  }

                  return Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: backgroundColor,
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
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => filterByNota(1),
                    child: const Text('Nota < 60'),
                  ),
                  ElevatedButton(
                    onPressed: () => filterByNota(2),
                    child: const Text('Nota >= 60 e < 100'),
                  ),
                  ElevatedButton(
                    onPressed: () => filterByNota(3),
                    child: const Text('Nota == 100'),
                  ),
                  ElevatedButton(
                    onPressed: () => filterByNota(0),
                    child: const Text('Mostrar Todos'),
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
