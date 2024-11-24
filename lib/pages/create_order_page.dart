import 'package:flutter/material.dart';
import '../utils/database_helper.dart';
import 'orders_page.dart';

class CreateOrderPage extends StatefulWidget {
  const CreateOrderPage({super.key});

  @override
  _CreateOrderPageState createState() => _CreateOrderPageState();
}

class _CreateOrderPageState extends State<CreateOrderPage> {
  final List<Map<String, dynamic>> _orderItems = [];
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController(text: '1');
  List<Map<String, dynamic>> _clients = [];
  List<Map<String, dynamic>> _products = [];
  String? _selectedClient;
  String? _selectedProduct;
  int _selectedQuantity = 1;
  double _total = 0.0;
  bool _isClientSelected = false;

  @override
  void initState() {
    super.initState();
    fetchClients();
    fetchProducts();
  }

  Future<void> fetchClients() async {
    final dbHelper = DatabaseHelper();
    final clientsList = await dbHelper.getClientes();
    setState(() {
      _clients = clientsList;
    });
  }

  Future<void> fetchProducts() async {
    final dbHelper = DatabaseHelper();
    final productsList = await dbHelper.getProdutos();
    setState(() {
      _products = productsList;
    });
  }

  void addOrderItem() {
    if (_selectedProduct != null && _selectedQuantity > 0) {
      final product = _products.firstWhere((p) => p['produto'] == _selectedProduct);
      final double discount = double.tryParse(_discountController.text) ?? 0.0;
      final double itemTotal = product['preco'] * _selectedQuantity;
      final double finalItemTotal = itemTotal - (itemTotal * discount / 100);

      setState(() {
        _orderItems.add({
          'produto': _selectedProduct,
          'quantidade': _selectedQuantity,
          'preco': product['preco'],
          'desconto': discount,
          'total': finalItemTotal,
        });
        _calculateTotal();
        // Limpar os campos de produto, quantidade e desconto
        _selectedProduct = null;
        _selectedQuantity = 1;
        _quantityController.text = '1';
        _discountController.clear();
      });
    }
  }

  Future<void> createOrder() async {
    final dbHelper = DatabaseHelper();
    final double finalTotal = _total;

    final order = {
      'cliente': _selectedClient,
      'total': finalTotal,
      'itens': _orderItems,
    };

    await dbHelper.insertOrder(order);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const OrdersPage()),
    );
  }

  void applyDiscount(String value) {
    setState(() {
      _calculateTotal();
    });
  }

  void _calculateTotal() {
    double total = 0.0;
    for (var item in _orderItems) {
      total += item['total'];
    }
    _total = total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Pedido'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Cliente'),
                items: _clients.map((client) {
                  return DropdownMenuItem<String>(
                    value: client['name'],
                    child: Text(client['name']),
                  );
                }).toList(),
                onChanged: _isClientSelected
                    ? null
                    : (value) {
                        setState(() {
                          _selectedClient = value;
                          _isClientSelected = true;
                        });
                      },
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Produto'),
                value: _selectedProduct,
                items: _products.map((product) {
                  return DropdownMenuItem<String>(
                    value: product['produto'],
                    child: Text(product['produto']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedProduct = value;
                  });
                },
              ),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: 'Quantidade'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _selectedQuantity = int.tryParse(value) ?? 1;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _discountController,
                decoration: const InputDecoration(labelText: 'Desconto (%)'),
                keyboardType: TextInputType.number,
                onChanged: applyDiscount,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: addOrderItem,
                child: const Text('Adicionar Produto'),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Itens do Pedido',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _orderItems.length,
                itemBuilder: (context, index) {
                  final item = _orderItems[index];
                  return ListTile(
                    title: Text('Produto: ${item['produto']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Valor: R\$${item['preco']}'),
                        Text('Quantidade: ${item['quantidade']}'),
                        Text('Total: R\$${(item['preco'] * item['quantidade']).toStringAsFixed(2)}'),
                        Text('Desconto: ${item['desconto']}%'),
                        Text('Valor Final: R\$${item['total'].toStringAsFixed(2)}'),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 16.0),
              Text(
                'Total do Pedido: R\$${_total.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: createOrder,
                child: const Text('Criar Pedido'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}