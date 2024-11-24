import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/clients');
              },
              child: const Text('Clientes'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/products');
              },
              child: const Text('Produtos'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/orders');
              },
              child: const Text('Pedidos'),
            ),
          ],
        ),
      ),
    );
  }
}