// main.dart
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Roll Masters',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.deepPurple),
      home: const HomePage(),
    );
  }
}

// TELA 1: INICIAL
class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Roll Masters')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CollectionsPage()),
          ),
          child: const Text('Ver Minhas Coleções'),
        ),
      ),
    );
  }
}

// TELA 2: LISTA DE COLEÇÕES
class CollectionsPage extends StatefulWidget {
  const CollectionsPage({super.key});
  @override
  State<CollectionsPage> createState() => _CollectionsPageState();
}

class _CollectionsPageState extends State<CollectionsPage> {
  List<Map<String, dynamic>> _collections = [];
  late Database _db;

  @override
  void initState() {
    super.initState();
    _initDb();
  }

  Future<void> _initDb() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, 'collections.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
            '''CREATE TABLE collections (id INTEGER PRIMARY KEY, name TEXT, lat REAL, lng REAL)''');
        await db.execute('''CREATE TABLE cards (
            id INTEGER,
            name TEXT,
            image TEXT,
            stackCount INTEGER,
            collectionId INTEGER
          )''');
      },
    );
    _loadCollections();
  }

  Future<void> _loadCollections() async {
    final result = await _db.query('collections');
    setState(() => _collections = result);
  }

  bool _isCreating = false;

  Future<void> _createCollection(BuildContext parentContext) async {
    final controller = TextEditingController();

    await showDialog(
      context: parentContext,
      builder: (BuildContext dialogContext) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setDialogState) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: const Text('Nova Coleção'),
            content: _isCreating
                ? const SizedBox(
                    height: 100,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 10),
                          Text('Criando coleção...',
                              style: TextStyle(fontSize: 14)),
                        ],
                      ),
                    ),
                  )
                : TextField(
                    controller: controller,
                    decoration:
                        const InputDecoration(hintText: 'Digite o Nome')),
            actions: _isCreating
                ? []
                : [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () async {
                        final name = controller.text.trim();
                        if (name.isNotEmpty) {
                          setDialogState(() => _isCreating = true);
                          final pos = await Geolocator.getCurrentPosition();
                          await _db.insert('collections', {
                            'name': name,
                            'lat': pos.latitude,
                            'lng': pos.longitude,
                          });
                          await _loadCollections();
                          if (parentContext.mounted){
                            Navigator.pop(dialogContext);
                            }
                          setState(() => _isCreating = false);
                        }
                      },
                      child: const Text('Criar'),
                    ),
                  ],
          );
        },
      ),
    );
  }

  Future<void> _clearCollections() async {
    await _db.delete('cards');
    await _db.delete('collections');
    await _loadCollections();
  }

  void _openCollection(BuildContext context, Map<String, dynamic> collection) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CollectionPage(db: _db, collection: collection),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Coleções'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            tooltip: 'Apagar tudo',
            onPressed: _clearCollections,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _collections.length,
        itemBuilder: (BuildContext context, int i) {
          final col = _collections[i];
          return ListTile(
            title: Text(col['name']),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _openCollection(context, col),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createCollection(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}

// TELA 3: UMA COLEÇÃO
class CollectionPage extends StatefulWidget {
  final Database db;
  final Map<String, dynamic> collection;
  const CollectionPage({super.key, required this.db, required this.collection});
  @override
  State<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  List<Map<String, dynamic>> _cards = [];

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    final result = await widget.db.query(
      'cards',
      where: 'collectionId = ?',
      whereArgs: [widget.collection['id']],
    );
    setState(() => _cards = result);
  }

  Future<void> _rollCharacter() async {
    final res = await http
        .get(Uri.parse('https://rickandmortyapi.com/api/character?page=1'));
    if (res.statusCode != 200) return;
    final data = json.decode(res.body);
    final results = data['results'];
    final index = Random().nextInt(results.length);
    final char = results[index];

    final existing = await widget.db.query(
      'cards',
      where: 'id = ? AND collectionId = ?',
      whereArgs: [char['id'], widget.collection['id']],
    );

    if (existing.isNotEmpty) {
      final currentStack = existing.first['stackCount'] as int;
      await widget.db.update(
        'cards',
        {'stackCount': currentStack + 1},
        where: 'id = ? AND collectionId = ?',
        whereArgs: [char['id'], widget.collection['id']],
      );
    } else {
      await widget.db.insert('cards', {
        'id': char['id'],
        'name': char['name'],
        'image': char['image'],
        'stackCount': 1,
        'collectionId': widget.collection['id'],
      });
    }

    await _loadCards();
  }

  void _showCollectionInfo(BuildContext parentContext) {
    final lat = widget.collection['lat']?.toStringAsFixed(5) ?? 'desconhecida';
    final lng = widget.collection['lng']?.toStringAsFixed(5) ?? 'desconhecida';
    showDialog(
      context: parentContext,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: const Text('Informações da Coleção'),
        content: Text('Criada em: ($lat, $lng)'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Fechar'))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.collection['name']),
        actions: [
          IconButton(
              onPressed: () => _showCollectionInfo(context),
              icon: const Icon(Icons.info_outline))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _rollCharacter,
        child: const Icon(Icons.casino),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: GridView.count(
          crossAxisCount: 4,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          children: _cards.map((card) {
            return Column(
              children: [
                Image.network(card['image'],
                    width: 60, height: 60, fit: BoxFit.cover),
                Text(card['name'],
                    style: const TextStyle(fontSize: 12),
                    overflow: TextOverflow.ellipsis),
                Text('x${card['stackCount']}',
                    style: const TextStyle(fontSize: 10)),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
