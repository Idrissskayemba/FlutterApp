import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stockapp/models/categorie.dart';
import 'package:stockapp/database/LocalDb.dart';
import 'package:stockapp/pages/categorie.dart';

class ajouterCategorie extends StatefulWidget {
  const ajouterCategorie({super.key});

  @override
  State<StatefulWidget> createState() {
    return ajouterCategorieState();
  }
}

class ajouterCategorieState extends State<ajouterCategorie> {
  final _picker = ImagePicker();
  TextEditingController titleController = TextEditingController();
  TextEditingController reference = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  XFile? _imageFile;
  final _db = LocalDb();
  bool _isAdding = false;
  String _message = "Catégorie ajoutée avec succès !";
  IconData _icon = Icons.info;

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text("Ajouter une catégorie", style: TextStyle(color: Colors.white)),
      ),

      body: Padding(
        padding: const EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15),
              child: TextField(
                controller: reference,
                decoration: InputDecoration(
                  labelText: 'Reference',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(15),
              child: TextField(
                controller: titleController,
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
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(
                        onPressed: () async {
                          
                        if (reference.text.isEmpty || titleController.text.isEmpty || descriptionController.text.isEmpty) {
                            _showSnackbar("Veuillez remplir tous les champs");
                           return;
                        }


                        if (await _categoryExists()) {
                            _showSnackbar("La catégorie existe déjà!");
                           return;
                        }
  setState(() {
    _isAdding = true;
  });

  final categorie = Categorie(
    reference: reference.text,
    designation: titleController.text,
    description: descriptionController.text,
    image: _imageFile?.path,
  );

  try {
    await _db.insertCategorie(categorie);
    setState(() {
      _message = 'Catégorie ajoutée avec succès !';
      _icon = Icons.check_circle;
    });
     
  } catch (e) {
    setState(() {
      _message = "Échec de l'ajout de la catégorie : $e";
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
                      ),
                    ),
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
  if (image != null) {
    if (await _categoryExists()) {
      _showSnackbar("La catégorie existe déjà!");
      return;
    }
    
  }
}

  Future<bool> _categoryExists() async {
    final existingCategory = await _db.getCategorieByReference(reference.text);
    return existingCategory != null;
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  
}