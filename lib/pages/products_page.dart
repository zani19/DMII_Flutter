import 'package:flutter/material.dart';

import '../utils/database_helper.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  List<dynamic> products = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final dbHelper = DatabaseHelper();
    final productsList = await dbHelper.getProdutos();
    setState((){
      products = productsList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos'),
      ),
      body: Column(
        children: [
          const Center(
            child: Text(
              'Lista de Produtos',
              style: TextStyle(fontSize: 24.0),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ListTile(
                  title: Text(product['produto']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Quantidade: ${product['quantidade']}'),
                      Text('Preço: R\$${product['preco']}'),
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