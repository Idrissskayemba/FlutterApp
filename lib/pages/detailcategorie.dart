import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stockapp/models/categorie.dart';
import 'package:stockapp/database/LocalDb.dart';
import 'package:stockapp/pages/categorie.dart';
import 'package:stockapp/models/produit.dart';

class detailCategorie extends StatefulWidget {
  const detailCategorie({super.key, required this.designation});

  final String designation;

  @override
  State<StatefulWidget> createState() => detailCategorieState();
}

class detailCategorieState extends State<detailCategorie> {
  late Categorie _categorie;

  @override
  void initState() {
    super.initState();
    _getCategorieDetails();
  }

  Future<void> _getCategorieDetails() async {
    final db = LocalDb();
    final categorie = await db.getCategorieByDesignation(widget.designation);
    final produits = await db.getProduitsByCategorie(categorie!.designation);
    setState(() {
      _categorie = categorie!;
      _produits = produits;
    });
  }

  List<Produit> _produits = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text("Détail de la catégorie", style: TextStyle(color: Colors.white)),
        actions: [ 
          IconButton(
            onPressed: () => _editCategorie(),
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () => _deleteCategorie(),
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: _categorie == null 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                
                Container( 
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(File(_categorie.image!)),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(height: 16),
                Text("Designation: "),

                const SizedBox(height: 5),

                Text(
                  _categorie.designation,
                  style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                Text(_categorie.reference),

                const SizedBox(height: 8),

                Text(
                  _categorie.description 
                  ), 
              ],
            ),
          ),
          
        ),
    );
  }
  Future<void> _editCategorie() async {
    
  }

  void _deleteCategorie() async {
    final confirmation = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmation de suppression'),
        content: Text('Voulez-vous vraiment supprimer la catégorie "${_categorie.designation}" ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false), 
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('OK'),
          ),
        ],
      ),
    );
    if (confirmation ?? false) {
  try {
    await LocalDb().deleteCategorie(_categorie);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Catégorie supprimée avec succès')),
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const ListCategorie()),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erreur lors de la suppression : $e')),
    );
  }
  }
}
}