import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stockapp/models/produit.dart';
import 'package:stockapp/database/LocalDb.dart';
import 'package:stockapp/pages/produit.dart';

class detailProduit extends StatefulWidget {
  const detailProduit({super.key, required this.designation});

  final String designation;

  @override
  State<StatefulWidget> createState() => detailProduitState();
}

class detailProduitState extends State<detailProduit> {
  late Produit _produit;

  @override
  void initState() {
    super.initState();
    _getProduitDetails();
  }

  Future<void> _getProduitDetails() async {
    final db = LocalDb();
    final produit = await db.getProduitByDesignation(widget.designation);
    setState(() {
      _produit = produit!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text("Détail du produit", style: TextStyle(color: Colors.white)),
        actions: [ 
          IconButton(
            onPressed: () => _editProduit(),
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () => _deleteProduit(),
            icon: const Icon(Icons.delete),
          ),
          IconButton(
            onPressed: () => _pushProduit(),
            icon: const Icon(Icons.warning),
          ),
        ],
      ),
      body: _produit == null 
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
                      image: FileImage(File(_produit.image!)),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  _produit.designation,
                  style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                Text(_produit.description),

                const SizedBox(height: 8),

                Text(
                  _produit.reference 
                  ),

                  const SizedBox(height: 8),

                Text(
                  _produit.categorie 
                  ),

                  const SizedBox(height: 8),

                Text(
                  _produit.prixAchat 
                  ),

                  const SizedBox(height: 8),

                Text(
                  _produit.prixVente 
                  ),

                  const SizedBox(height: 8),

                Text(
                  _produit.stockMin
                  ),

                  const SizedBox(height: 8),

                Text(
                  _produit.stockMax 
                  ),
 
              ],
            ),
          ),
        ),
    );
  }
  Future<void> _editProduit() async {
    
  }

  Future<void> _pushProduit() async {
    
  }

  void _deleteProduit() async {
    final confirmation = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmation de suppression'),
        content: Text('Voulez-vous vraiment supprimer la catégorie "${_produit.designation}" ?'),
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
    await LocalDb().deleteProduit(_produit);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Produit supprimée avec succès')),
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const listProduit()),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erreur lors de la suppression : $e')),
    );
  }
  }
}
}