import 'package:flutter/material.dart';

class CardRevealWidget extends StatelessWidget {
  final String cardText;
  final VoidCallback onAdd;

  const CardRevealWidget({required this.cardText, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 24),
          padding: EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.red, width: 3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                cardText,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, color: Colors.red),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: onAdd,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: StadiumBorder(),
                ),
                child: Text('Adicionar'),
              )
            ],
          ),
        ),
      ),
    );
  }
}