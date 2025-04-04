import 'package:flutter/material.dart';
import 'models.dart';
import 'theme/app_colors.dart';

class RollPage extends StatefulWidget {
  final Collection collection;
  final VoidCallback onUpdate;

  RollPage({required this.collection, required this.onUpdate});

  @override
  _RollPageState createState() => _RollPageState();
}

class _RollPageState extends State<RollPage> {
  String? newCard;

  void _rollCard() {
    setState(() {
      newCard = 'VOCÊ GANHOU UMA CARTA!';
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CardRevealWidget(
            cardText: newCard!,
            onAdd: () {
              setState(() {
                widget.collection.cards.add(newCard!);
                newCard = null;
              });
              widget.onUpdate();
              Navigator.of(context).pop();
            },
            onDiscard: () {
              setState(() {
                newCard = null;
              });
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cards = widget.collection.cards;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.collection.name),
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: AppColors.gradient),
        ),
      ),
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Expanded(
            child: cards.isEmpty
                ? Center(
              child: Text(
                'Nenhuma carta adicionada ainda.',
                style: TextStyle(color: AppColors.text),
              ),
            )
                : Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 3 / 4,
                ),
                itemCount: cards.length,
                itemBuilder: (context, index) {
                  final card = cards[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      border: Border.all(color: AppColors.cardBorder, width: 1.5),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          offset: Offset(0, 2),
                          blurRadius: 6,
                        )
                      ],
                    ),
                    padding: EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              'Carta',
                              style: TextStyle(fontSize: 16, color: AppColors.text),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        FittedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove_red_eye, color: AppColors.accent),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Carta'),
                                      content: Text(card),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: Text('Fechar'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: AppColors.accent),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Descartar carta?'),
                                      content: Text('Tem certeza que deseja descartar esta carta?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: Text('Cancelar'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              widget.collection.cards.removeAt(index);
                                              widget.onUpdate();
                                            });
                                            Navigator.pop(context);
                                          },
                                          child: Text('Descartar'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 32.0),
            child: ElevatedButton(
              onPressed: _rollCard,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: StadiumBorder(),
              ),
              child: Text('Roll', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}

class CardRevealWidget extends StatelessWidget {
  final String cardText;
  final VoidCallback onAdd;
  final VoidCallback onDiscard;

  const CardRevealWidget({
    required this.cardText,
    required this.onAdd,
    required this.onDiscard,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 24),
          padding: EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            border: Border.all(color: AppColors.cardBorder, width: 2),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                offset: Offset(0, 2),
                blurRadius: 6,
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                cardText,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, color: AppColors.text),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: onAdd,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: StadiumBorder(),
                    ),
                    child: Text('Adicionar', style: TextStyle(color: Colors.white)),
                  ),
                  ElevatedButton(
                    onPressed: onDiscard,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: StadiumBorder(),
                    ),
                    child: Text('Descartar', style: TextStyle(color: Colors.white)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
