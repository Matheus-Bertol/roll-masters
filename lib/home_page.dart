import 'package:flutter/material.dart';
import 'inventory_page.dart';
import 'theme/app_colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => InventoryPage()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            shape: StadiumBorder(),
          ),
          child: Text(
            'Bem-vindo! Clique para prosseguir',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
