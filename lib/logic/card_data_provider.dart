class CardDataProvider {
  static const int totalCards = 10;

  static Map<String, String> getCardDataById(int id) {
    const mockCards = {
      1: {'id': 'carta1', 'name': 'Carta do Goku'},
      2: {'id': 'carta2', 'name': 'Carta do Vegeta'},
      3: {'id': 'carta3', 'name': 'Carta da Bulma'},
      4: {'id': 'carta4', 'name': 'Carta do Kuririn'},
      5: {'id': 'carta5', 'name': 'Carta do Piccolo'},
      6: {'id': 'carta6', 'name': 'Carta do Gohan'},
      7: {'id': 'carta7', 'name': 'Carta do Trunks'},
      8: {'id': 'carta8', 'name': 'Carta do Freeza'},
      9: {'id': 'carta9', 'name': 'Carta do Cell'},
      10: {'id': 'carta10', 'name': 'Carta do Majin Buu'},
    };

    return mockCards[id] ?? {'id': 'unknown', 'name': 'Carta Misteriosa'};
  }
}