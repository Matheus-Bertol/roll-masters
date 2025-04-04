import 'package:flutter/material.dart';
import 'models.dart';
import 'roll_page.dart';

class InventoryPage extends StatefulWidget {
  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  List<Collection> collections = [];

  void _addCollection() async {
    String? name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Criar nova coleção'),
        content: TextField(
          autofocus: true,
          decoration: InputDecoration(hintText: 'Nome da coleção'),
          onSubmitted: (value) => Navigator.of(context).pop(value),
        ),
      ),
    );

    if (name != null && name.isNotEmpty) {
      setState(() => collections.add(Collection(name: name, cards: [])));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Minhas Coleções')),
      body: ListView.builder(
        itemCount: collections.length,
        itemBuilder: (context, index) {
          final collection = collections[index];
          return ListTile(
            title: Text(collection.name),
            subtitle: Text('${collection.cards.length} cartas'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => RollPage(
                  collection: collection,
                  onUpdate: () => setState(() {}), // força a atualização da lista
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addCollection,
        child: Icon(Icons.add),
        tooltip: 'Criar coleção',
      ),
    );
  }
}
