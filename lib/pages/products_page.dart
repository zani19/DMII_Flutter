import 'package:flutter/material.dart';

class ProductsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Produtos'),
      ),
      body: Center(
        child: Text(
          'Lista de Produtos',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}
