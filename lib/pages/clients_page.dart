import 'package:flutter/material.dart';
import '../utils/database_helper.dart';

class ClientsPage extends StatefulWidget {
  const ClientsPage({super.key});

  @override
  _ClientsPageState createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  List<Map<String, dynamic>> clients = [];

  @override
  void initState() {
    super.initState();
    fetchClients();
  }

   Future<void> fetchClients() async {
    final dbHelper = DatabaseHelper();
    final clientsList = await dbHelper.getClientes();
    setState(() {
      clients = clientsList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes'),
      ),
      body: Column(
        children: [
          const Center(
            child: Text(
              'Lista de Clientes',
              style: TextStyle(fontSize: 24.0),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: clients.length,
              itemBuilder: (context, index) {
                final client = clients[index];
                return ListTile(
                  title: Text('ID: ${client['id'].toString()}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nome: ${client['name']}'),
                      Text('Endereço: ${client['endereco']}'),
                    ],
                  )
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}