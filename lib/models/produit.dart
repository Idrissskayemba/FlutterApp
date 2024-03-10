class Produit {
  final String reference;
  final String designation;
  final String description;
  final String prixAchat;
  final String prixVente;
  final String stockMin;
  final String stockMax;
  final String categorie;
  final String? image;

  Produit({
    required this.reference,
    required this.designation,
    required this.description,
    required this.prixAchat,
    required this.prixVente,
    required this.stockMin,
    required this.stockMax,
    required this.categorie,
    this.image,
  });

  factory Produit.fromMap(Map<String, dynamic> map) {
    return Produit(
      reference: map['reference'],
      designation: map['designation'],
      description: map['description'],
      prixAchat: map['prixAchat'],
      prixVente: map['prixVente'],
      stockMin: map['stockMin'],
      stockMax: map['stockMax'],
      categorie: map['categorie'],
      image: map['image'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'reference': reference,
      'designation': designation,
      'description': description,
      'prixAchat': prixAchat,
      'prixVente': prixVente,
      'stockMin': stockMin,
      'stockMax': stockMax,
      'categorie': categorie,
      'image': image,
    };
  }
}