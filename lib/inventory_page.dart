import 'package:flutter/material.dart';
import 'models.dart';
import 'roll_page.dart';
import 'theme/app_colors.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  InventoryPageState createState() => InventoryPageState();
}

class InventoryPageState extends State<InventoryPage> {
  List<Collection> collections = [];

  void _addCollection() async {
    String? name = await showDialog<String>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Criar nova coleção',
              style: TextStyle(color: AppColors.text),
            ),
            content: TextField(
              autofocus: true,
              decoration: InputDecoration(hintText: 'Nome da coleção'),
              onSubmitted: (value) => Navigator.of(context).pop(value),
            ),
          ),
    );

    if (name!.isNotEmpty) {
      setState(
        () => collections.add(
          Collection(name: name, cards: [], stackedCards: []),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Minhas Coleções'),
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: AppColors.gradient),
        ),
      ),
      body: ListView.builder(
        itemCount: collections.length,
        itemBuilder: (context, index) {
          final collection = collections[index];
          return ListTile(
            title: Text(
              collection.name,
              style: TextStyle(color: AppColors.text),
            ),
            subtitle: Text(
              '${collection.stackedCards.fold<int>(0, (total, c) => total + c.quantity)} cartas',
              style: TextStyle(color: AppColors.text.withAlpha((0.7 * 255).toInt())),
            ),
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => RollPage(
                          collection: collection,
                          onUpdate: () => setState(() {}),
                        ),
                  ),
                ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addCollection,
        backgroundColor: AppColors.primary,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
