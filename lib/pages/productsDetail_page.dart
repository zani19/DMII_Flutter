import 'package:flutter/material.dart';
import 'productsOrderConfirmation_page.dart';

class ProductDetailPage extends StatelessWidget {
  final String product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(product),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Detalhes do $product',
                style: const TextStyle(fontSize: 24.0),
              ),
            ),
            const SizedBox(height: 16.0),
            Container(
              width: double.infinity,
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  labelText: 'Total de Produtos',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    final int quantity = int.tryParse(_controller.text) ?? 0;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderConfirmationPage(
                          product: product,
                          quantity: quantity,
                        ),
                      ),
                    );
                  },
                  child: const Text('Confirmar Pedido'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancelar Pedido'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}