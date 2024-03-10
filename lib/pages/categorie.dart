import 'dart:io';

import 'package:flutter/material.dart';
import 'package:stockapp/pages/acceuil.dart';
import 'package:stockapp/pages/ajoutercategorie.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stockapp/models/categorie.dart';
import 'package:stockapp/database/LocalDb.dart';
import 'package:stockapp/pages/detailcategorie.dart';

class ListCategorie extends StatefulWidget {
  const ListCategorie({super.key});

  @override
  State<StatefulWidget> createState() => ListCategorieState();
}

class ListCategorieState extends State<ListCategorie> {
  List<Categorie> _categories = [];

  @override
  void initState() {
    super.initState();
    _getAllCategories();
  }

  Future<void> _getAllCategories() async {
    final db = LocalDb();
    final categories = await db.getAllCategories();
    setState(() {
      _categories = categories;
      print(categories);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Row(
          children: <Widget>[
            Icon(
              Icons.category,
              color: Colors.white,
            ),
            const Text(
              "Liste des catégories",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ],
        ),
      ),
      body: _categories.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final categorie = _categories[index];
                return Card(
                  color: Colors.white,
                  elevation: 2.0,
                  child: ListTile(
                    leading: categorie.image != null
                        ? CircleAvatar(
                            backgroundImage: FileImage(File(categorie.image!)),
                          )
                        : const CircleAvatar(
                            backgroundColor: Colors.green,
                            child: Icon(Icons.shopping_bag),
                          ),
                    title: Text(categorie.designation),
                    subtitle: Text(categorie.description),
                    trailing: const Icon(Icons.list, color: Colors.black),
                    onTap: () {
                      Navigator.push(
                      context,
                      MaterialPageRoute(
                      builder: (context) => detailCategorie(designation: categorie.designation),
                      ),
                       );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint('Ajouter une nouvelle catégorie');
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const ajouterCategorie()));
        },
        backgroundColor: Colors.blueGrey,
        tooltip: 'Ajouter une nouvelle catégorie',
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}