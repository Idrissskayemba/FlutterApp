import 'dart:io';

import 'package:flutter/material.dart';
import 'package:stockapp/pages/acceuil.dart';
import 'package:stockapp/pages/ajoutercategorie.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stockapp/models/stock.dart';
import 'package:stockapp/database/LocalDb.dart';
import 'package:stockapp/pages/ajouterstock.dart';
import 'package:stockapp/pages/detailcategorie.dart';

class ListStock extends StatefulWidget {
  const ListStock({super.key});

  @override
  State<StatefulWidget> createState() => ListStockState();
}

class ListStockState extends State<ListStock> {
  List<Stock> _stocks = [];

  @override
  void initState() {
    super.initState();
    _getAllStocks();
  }

  Future<void> _getAllStocks() async {
    final db = LocalDb();
    final stocks = await db.getAllStocks();
    setState(() {
      _stocks = stocks;
      print(stocks);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Row(
          children: <Widget>[
            const Text(
              "10 derniers mouvements",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ],
        ),
      ),
      body: _stocks.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _stocks.length,
              itemBuilder: (context, index) {
                final stock = _stocks[index];
                return Card(
                  color: Colors.white,
                  elevation: 2.0,
                  child: ListTile(
                    leading: 
                          const CircleAvatar(
                            backgroundColor: Colors.green,
                            child: Icon(Icons.storage),
                          ),
                    title: Text(stock.jour),
                    subtitle: Text(stock.produit),
                    trailing: const Icon(Icons.list, color: Colors.black),
                    onTap: () {
                      //Navigator.push(
                      //context,
                      //MaterialPageRoute(
                      //builder: (context) => detailStock(designation: stock.jour),
                      //),
                       //);
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint('Ajouter un nouveau stock');
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const ajouterStock()));
        },
        backgroundColor: Colors.blueGrey,
        tooltip: 'Ajouter un nouveau stock',
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}