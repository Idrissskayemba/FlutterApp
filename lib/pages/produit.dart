import 'dart:io';
import 'package:flutter/material.dart';
import 'package:stockapp/pages/ajouterproduit.dart';
import 'package:stockapp/models/produit.dart';
import 'package:stockapp/database/LocalDb.dart';
import 'package:stockapp/pages/detailproduit.dart';

class listProduit extends StatefulWidget {
  const listProduit({super.key});

  @override
  State<StatefulWidget> createState() {
    return listProduitState();
  }
}

class listProduitState extends State<listProduit> {
  List<Produit> _produits = [];

  @override
  void initState() {
    super.initState();
    _getAllProduits();
  }

  Future<void> _getAllProduits() async {
    try {
      final db = LocalDb();
      final produits = await db.getAllProduits();
      setState(() {
        _produits = produits;
        print(produits);
      });
    } catch (error) {
      setState(() {
        _produits = [];
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors du chargement des produits: $error')),
      );
    }
  }

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Row(
          children: <Widget>[
            Icon(
              Icons.article,
              color: Colors.white,
            ),
            Text(
              "Produits",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ],
        ),
      ),
      body: _produits.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _produits.length,
              itemBuilder: (context, index) {
                final produit = _produits[index];
                return Card(
                  color: Colors.white,
                  elevation: 2.0,
                  child: ListTile(
                    leading: produit.image != null
                        ? CircleAvatar(
                            backgroundImage: FileImage(File(produit.image!)),
                          )
                        : const CircleAvatar(
                            backgroundColor: Colors.green,
                            child: Icon(Icons.shopping_bag),
                          ),
                    title: Text(produit.designation),
                    subtitle: Text(produit.description),
                    trailing: const Icon(Icons.list, color: Colors.black),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => detailProduit(
                                designation: produit.designation)),
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint('Ajouter un nouveau produit');
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ajouterProduit()),
          );
        },
        backgroundColor: Colors.blueGrey,
        tooltip: 'Ajouter un nouveau produit',
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}