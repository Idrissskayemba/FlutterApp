class Categorie {
  //final int id;
  final String reference;
  final String designation;
  final String description;
  final String? image;

  Categorie({
    //this.id=-1,
    required this.reference,
    required this.designation,
    required this.description,
    this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      //'id': id,
      'reference': reference,
      'designation': designation,
      'description': description,
      'image': image,
    };
  }

  factory Categorie.fromMap(Map<String, dynamic> map) {
    return Categorie(
      //id: map['id'],
      reference: map['reference'],
      designation: map['designation'],
      description: map['description'],
      image: map['image'],
    );
  }
}