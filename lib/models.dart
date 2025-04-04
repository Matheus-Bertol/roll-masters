import 'logic/stack_logic.dart';

class Collection {
  final String name;
  final List<String> cards;
  List<CardStack> stackedCards;

  Collection({
    required this.name,
    this.cards = const [],
    List<CardStack>? stackedCards,
  }) : stackedCards = stackedCards ?? [];
}
