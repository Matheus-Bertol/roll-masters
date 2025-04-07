import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'models.dart';
import 'theme/app_colors.dart';
import 'logic/stack_logic.dart';
import 'logic/card_data_provider.dart';

class RollPage extends StatefulWidget {
  final Collection collection;
  final VoidCallback onUpdate;

  const RollPage({super.key, required this.collection, required this.onUpdate});

  @override
  // ignore: library_private_types_in_public_api
  _RollPageState createState() => _RollPageState();
}

class _RollPageState extends State<RollPage> {
  CardStack? newCard;

  void _rollCard() {
    final int maxAvailableCards = CardDataProvider.totalCards;
    final int randomId = Random().nextInt(maxAvailableCards) + 1;

    final selected = CardDataProvider.getCardDataById(randomId);
    final id = selected['id']!;
    final name = selected['name']!;

    newCard = CardStack(id: id, name: name);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CardRevealWidget(
            cardText: newCard!.name,
            onAdd: () {
              if (kDebugMode) {
                print('newCard é: ${newCard?.name}');
              }
              setState(() {
                final existing = widget.collection.stackedCards
                    .firstWhere((c) => c.id == newCard!.id, orElse: () => CardStack(id: '', name: ''));

                if (existing.id.isNotEmpty) {
                  existing.quantity++;
                } else {
                  widget.collection.stackedCards.add(CardStack(
                    id: newCard!.id,
                    name: newCard!.name,
                    quantity: 1,
                  ));
                }

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
    final cards = widget.collection.stackedCards;

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
                      border: Border.all(
                          color: AppColors.cardBorder, width: 1.5),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          // ignore: deprecated_member_use
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
                              '${card.name} (${card.quantity}x)',
                              style: TextStyle(
                                  fontSize: 16, color: AppColors.text),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        FittedBox(
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove_red_eye,
                                    color: AppColors.accent),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text(card.name),
                                      content: Text(
                                          'Quantidade: ${card.quantity}'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text('Fechar'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete,
                                    color: AppColors.accent),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Descartar carta?'),
                                      content: Text(
                                          'Deseja remover uma cópia desta carta?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text('Cancelar'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              if (card.quantity > 1) {
                                                card.quantity--;
                                              } else {
                                                widget.collection
                                                    .stackedCards
                                                    .removeAt(index);
                                              }
                                            });
                                            widget.onUpdate();
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

  const CardRevealWidget({super.key, 
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
                color: Colors.black.withAlpha((0.15 * 255).toInt()),
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
                      padding:
                      EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: StadiumBorder(),
                    ),
                    child:
                    Text('Adicionar', style: TextStyle(color: Colors.white)),
                  ),
                  ElevatedButton(
                    onPressed: onDiscard,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondaryRed,
                      padding:
                      EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: StadiumBorder(),
                    ),
                    child:
                    Text('Descartar', style: TextStyle(color: Colors.white)),
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
