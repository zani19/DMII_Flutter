import 'dart:convert';
import 'package:flutter/material.dart';
import '../utils/database_helper.dart';
import 'package:http/http.dart' as http;
import 'create_order_page.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  List<Map<String, dynamic>> orders = [];

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    final dbHelper = DatabaseHelper();
    final ordersList = await dbHelper.getOrders();
    setState(() {
      orders = ordersList;
    });
  }

  Future<void> syncOrder(Map<String, dynamic> order) async {
    final response = await http.post(
      Uri.parse('http://demo0152687.mockable.io/pedidos'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(order),
    );

    if (response.statusCode == 200) {
      print('Pedido sincronizado com sucesso');
      final dbHelper = DatabaseHelper();
      await dbHelper.updateOrderSyncStatus(order['id'], 1);
      fetchOrders(); // Atualizar a lista de pedidos
    } else {
      print('Falha ao sincronizar pedido: ${response.statusCode}');
    }
  }

  Future<List<Map<String, dynamic>>> fetchOrderItems(int orderId) async {
    final dbHelper = DatabaseHelper();
    return await dbHelper.getOrderItems(orderId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedidos'),
      ),
      body: Column(
        children: [
          const Center(
            child: Text(
              'Lista de Pedidos',
              style: TextStyle(fontSize: 24.0),
            ),
          ),
          Expanded(
            child: orders.isEmpty
                ? const Center(child: Text('Não há pedidos cadastrados'))
                : ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      return ExpansionTile(
                        title: Text('Pedido ID: ${order['id']}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Cliente: ${order['cliente']}'),
                            Text('Total: R\$${order['total']}'),
                          ],
                        ),
                        trailing: order['isSynced'] == 1
                            ? null
                            : IconButton(
                                icon: const Icon(Icons.sync),
                                onPressed: () => syncOrder(order),
                              ),
                        children: [
                          FutureBuilder<List<Map<String, dynamic>>>(
                            future: fetchOrderItems(order['id']),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Erro: ${snapshot.error}');
                              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                return const Text('Não há itens no pedido');
                              } else {
                                final items = snapshot.data!;
                                return Column(
                                  children: items.map((item) {
                                    final double itemTotal = item['preco'] * item['quantidade'];
                                    final double discount = item['desconto'] ?? 0.0;
                                    final double finalItemTotal = itemTotal - (itemTotal * discount / 100);
                                    return ListTile(
                                      title: Text('Produto: ${item['produto']}'),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Valor: R\$${item['preco']}'),
                                          Text('Quantidade: ${item['quantidade']}'),
                                          Text('Total: R\$${itemTotal.toStringAsFixed(2)}'),
                                          Text('Desconto: ${discount}%'),
                                          Text('Valor Final: R\$${finalItemTotal.toStringAsFixed(2)}'),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                );
                              }
                            },
                          ),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateOrderPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}