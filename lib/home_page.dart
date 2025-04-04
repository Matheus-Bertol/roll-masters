import 'package:flutter/material.dart';
import 'inventory_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text('Bem-vindo! Clique para prosseguir'),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => InventoryPage()),
          ),
        ),
      ),
    );
  }
}
