class Stock {
  //int id;
  String produit;
  String jour;
  String quantite;

  Stock({ required this.produit, required this.jour, required this.quantite});

  Map<String, dynamic> toMap() {
    return {
      //'id': id,
      'produit': produit,
      'jour': jour,
      'quantite': quantite,
    };
  }

  static Stock fromMap(Map<String, dynamic> map) {
    return Stock(
      //id: map['id'],
      produit: map['produit'],
      jour: map['jour'],
      quantite: map['quantite'],
    );
  }
}