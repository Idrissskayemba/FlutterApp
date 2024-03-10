import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stockapp/models/categorie.dart';
import 'package:stockapp/database/LocalDb.dart';
import 'package:stockapp/models/produit.dart';

class ajouterProduit extends StatefulWidget {
  const ajouterProduit({super.key});

  @override
  State<StatefulWidget> createState() => ajouterProduitState();
}

class ajouterProduitState extends State<ajouterProduit> {
final _picker = ImagePicker();
  TextEditingController referenceController = TextEditingController();
  TextEditingController designationController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController prixAchatController = TextEditingController();
  TextEditingController prixVenteController = TextEditingController();
  TextEditingController stockMinController = TextEditingController();
  TextEditingController stockMaxController = TextEditingController();
  XFile? _imageFile;
  final _db = LocalDb();
  bool _isAdding = false;
  String _message = "Produit ajouté avec succès !";
  IconData _icon = Icons.info;

  String? selectedCategorie;
  List<Categorie> _categories = [];
  @override
  void initState() {
    super.initState();
    _getCategories();
  }

  Future<void> _getCategories() async {
    final db = LocalDb();
    final categories = await db.getAllCategories();
    setState(() {
      _categories = categories;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text("Ajouter un produit", style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15),
              child: TextField(
                controller: referenceController,
                decoration: InputDecoration(
                  labelText: 'Reference',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                children: [
                  Expanded(
                    child: _imageFile != null
                        ? Image.file(File(_imageFile!.path))
                        : ElevatedButton(
                            onPressed: _getImage,
                            child: const Text("Choisir une image acrocheur", style: TextStyle(color: Colors.blueGrey)),
                          ),
                  ),
                ],
              ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: TextField(
                controller: designationController,
                decoration: InputDecoration(
                  labelText: 'Designation',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(15),
              child: TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
            Padding(
        padding: const EdgeInsets.all(15),
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Catégorie',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
          value: selectedCategorie,
          items: _categories.map((categorie) {
            return DropdownMenuItem<String>(
              value: categorie.reference.toString(),
              child: Text(categorie.designation),
            );
          }).toList(),
          onChanged: (value) {
            setState(() => selectedCategorie = value);
            print("Categorie sélectionnée: $selectedCategorie");
          },
        ),
      ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: TextField(
                controller: prixAchatController,
                decoration: InputDecoration(
                  labelText: "Prix d'achat",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: TextField(
                controller: prixVenteController,
                decoration: InputDecoration(
                  labelText: "Prix de vente",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: TextField(
                controller: stockMinController,
                decoration: InputDecoration(
                  labelText: "Stock min",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(15),
              child: TextField(
                controller: stockMaxController,
                decoration: InputDecoration(
                  labelText: "Stock max",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
            
            Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                Expanded(
                child: Container(
                height: 60,
                decoration: BoxDecoration(color: Colors.blueGrey,
                borderRadius: BorderRadius.circular(10)),
                child: TextButton(
            onPressed: () async{
              if (_isAdding) return;

                          final reference = referenceController.text;
                          final designation = designationController.text;
                          final description = descriptionController.text;
                          final prixAchat = prixAchatController.text;
                          final prixVente = prixVenteController.text;
                          final stockMin = stockMinController.text;
                          final stockMax = stockMaxController.text;

                          if (reference.isEmpty ||
                              designation.isEmpty ||
                              description.isEmpty ||
                              prixAchatController.text.isEmpty ||
                              prixVenteController.text.isEmpty ||
                              stockMinController.text.isEmpty ||
                              stockMaxController.text.isEmpty) {
                            _showSnackbar("Veuillez remplir tous les champs");
                            return;
                          }

                          setState(() {
                            _isAdding = true;
                          });

                          final produit = Produit(
                            reference: reference,
                            designation: designation,
                            description: description,
                            prixAchat: prixAchat,
                            prixVente: prixVente,
                            stockMin: stockMin,
                            stockMax: stockMax,
                            categorie: selectedCategorie!,
                            image: _imageFile?.path,
                          );

                          try {
                            await _db.insertProduit(produit);
                            setState(() {
                              _message = 'Produit ajouté avec succès !';
                              _icon = Icons.check_circle;
                              });
                              } catch (e) {
    setState(() {
      _message = "Échec de l'ajout du produit : $e";
      _icon = Icons.error;
    });
  } finally {
    setState(() {
      _isAdding = false;
    });
  }
ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(_message),
      backgroundColor: _icon == Icons.check_circle ? Colors.green : Colors.red,
     
    ),
  );

            },
            child: const Text("AJOUTER", style: TextStyle(color: Colors.white)),
          ),),
                  ),
              ],
            ),
            ),
          ],
        ),
      ),
    );
  }
   Future<void> _getImage() async {
     final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
setState(() {
  _imageFile = image;
});
   }

   void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}