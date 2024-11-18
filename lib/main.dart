import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD Flutter',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const CrudPage(),
    );
  }
}

class CrudPage extends StatefulWidget {
  const CrudPage({super.key});

  @override
  _CrudPageState createState() => _CrudPageState();
}

class _CrudPageState extends State<CrudPage> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _categoriaController = TextEditingController();

  List<Map<String, dynamic>> _data = [];

  @override
  void initState() {
    super.initState();
    fetchItems();
  }
  final String URL = "http://10.0.2.2"; // Definindo a variável URL
  
  Future<void> fetchItems() async {
    try {
      final response = await http.get(
        Uri.parse("$URL/api/testeApi.php/cliente/list"),
      );

      if (response.statusCode == 200) {
        setState(() {
          _data = List<Map<String, dynamic>>.from(json.decode(response.body));
        });
      }
    } catch (e) {
      print("Erro ao buscar dados: $e");
    }
  }

  Future<void> createItem() async {
    try {
      final response = await http.post(
        Uri.parse("$URL/api/testeApi.php/cliente"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "nome": _nomeController.text,
          "categoria": _categoriaController.text,
        }),
      );

      if (response.statusCode == 200) {
        fetchItems();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Item criado com sucesso!")),
        );
      }
    } catch (e) {
      print("Erro ao criar item: $e");
    }
  }

  Future<void> updateItem() async {
    try {
      final response = await http.put(
        Uri.parse("$URL/api/testeApi.php/cliente/${_idController.text}"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "nome": _nomeController.text,
          "categoria": _categoriaController.text,
        }),
      );

      if (response.statusCode == 200) {
        fetchItems();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Item atualizado com sucesso!")),
        );
      }
    } catch (e) {
      print("Erro ao atualizar item: $e");
    }
  }

  Future<void> deleteItem() async {
    try {
      final response = await http.delete(
        Uri.parse("$URL/api/testeApi.php/cliente/${_idController.text}"),
      );

      if (response.statusCode == 200) {
        fetchItems();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Item excluído com sucesso!")),
        );
      }
    } catch (e) {
      print("Erro ao excluir item: $e");
    }
  }

  void selectRow(Map<String, dynamic> item) {
    _idController.text = item['id'].toString();
    _nomeController.text = item['nome'];
    _categoriaController.text = item['categoria'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("CRUD Flutter")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _idController,
              decoration: const InputDecoration(labelText: "ID", enabled: false),
            ),
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(labelText: "Nome"),
            ),
            TextField(
              controller: _categoriaController,
              decoration: const InputDecoration(labelText: "Categoria"),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(onPressed: fetchItems, child: const Text("GET")),
                ElevatedButton(onPressed: createItem, child: const Text("POST")),
                ElevatedButton(onPressed: updateItem, child: const Text("PUT")),
                ElevatedButton(onPressed: deleteItem, child: const Text("DELETE")),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text("ID")),
                    DataColumn(label: Text("Nome")),
                    DataColumn(label: Text("Categoria")),
                  ],
                  rows: _data
                      .map(
                        (item) => DataRow(
                          cells: [
                            DataCell(Text(item['id'].toString())),
                            DataCell(Text(item['nome'])),
                            DataCell(Text(item['categoria'])),
                          ],
                          onSelectChanged: (_) => selectRow(item),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
