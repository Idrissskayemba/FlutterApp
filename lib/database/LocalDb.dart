import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:stockapp/models/categorie.dart';
import 'package:stockapp/models/produit.dart';
import 'package:stockapp/models/stock.dart';

class LocalDb {
  static final LocalDb _instance = LocalDb._internal();
  Database? _database;

  factory LocalDb() {
    return _instance;
  }

  LocalDb._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = await getDatabasesPath();
    return await openDatabase(
      '$path/stockapp.db',
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE categories (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            reference TEXT NOT NULL,
            designation TEXT NOT NULL,
            description TEXT NOT NULL,
            image BLOB
          )
        ''');

        await db.execute('''
          CREATE TABLE produits (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            reference TEXT NOT NULL,
            designation TEXT NOT NULL,
            description TEXT NOT NULL,
            prixAchat TEXT NOT NULL,
            prixVente TEXT NOT NULL,
            stockMin TEXT NOT NULL,
            stockMax TEXT NOT NULL,
            categorie TEXT NOT NULL,
            image BLOB
          )
        ''');

        await db.execute('''
          CREATE TABLE stock (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            produit TEXT NOT NULL,
            jour TEXT NOT NULL,
            quantite TEXT NOT NULL,
            FOREIGN KEY (produit) REFERENCES produits(designation)
          )
        ''');   
      },
      version: 1,
    );
    
  }
  

  Future<void> insertCategorie(Categorie categorie) async {
    final db = await database;
    await db.insert('categories', categorie.toMap());
  }

  Future<void> insertProduit(Produit produit) async {
  final db = await database;
  await db.insert('produits', produit.toMap());
}

Future<void> insertStock(Stock stock) async {
  final db = await database;
  final stockMap = {
    'produit': stock.produit,
    'jour': stock.jour,
    'quantite': stock.quantite.toString(),
  };
  await db.insert('stock', stockMap);
}

  Future<List<Categorie>> getAllCategories() async {
    final db = await database;
    final maps = await db.query('categories');
    return List.generate(maps.length, (i) => Categorie.fromMap(maps[i]));
  }

  Future<List<Produit>> getAllProduits() async {
    final db = await database;
    final maps = await db.query('produits');
    return List.generate(maps.length, (i) => Produit.fromMap(maps[i]));
  }

  Future<Categorie?> getCategorieByDesignation(String designation) async {
  final db = await database;
  final maps = await db.query(
    'categories',
    columns: ['reference', 'designation', 'description', 'image'],
    where: 'designation = ?',
    whereArgs: [designation],
  );

  if (maps.isNotEmpty) {
    
    return Categorie.fromMap(maps.first);
  } else {
    return null; 
  }
}

Future<Produit?> getProduitByDesignation(String designation) async {
    final db = await database;
    final maps = await db.query(
      'produits',
      columns: [
        'reference',
        'designation',
        'description',
        'prixAchat',
        'prixVente',
        'stockMin',
        'stockMax',
        'categorie',
        'image',
      ],
      where: 'designation = ?',
      whereArgs: [designation],
    );

    if (maps.isNotEmpty) {
      return Produit.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<void> deleteProduit(Produit produit) async {
    final db = await database;
    await db.delete('produits', where: 'designation = ?', whereArgs: [produit.designation]);
  }

  Future<void> updateProduit(Produit produit) async {
    final db = await database;
    await db.update('produits', produit.toMap(), where: 'designation = ?', whereArgs: [produit.designation]);
  }

  getCategorieByReference(String text) {}

  

  //Future<void> updateCategorie(Categorie categorie) async {
    //final db = await database;
    //await db.update('categories', categorie.toMap(), where: 'id = ?', whereArgs: [categorie.id]);
  //}

  Future<void> deleteCategorie(Categorie categorie) async {
    final db = await database;
    await db.delete('categories', where: 'designation = ?', whereArgs: [categorie.designation]);
  }

  getProduitsByCategorie(String designation) {}

  getAllStocks() {}

  
  //Future<void> deleteCategorie(Categorie categorie) async {
  //await database.delete(
    //'categories',
    //where: 'designation = ?',
    //whereArgs: [categorie.designation],
  //);
//}


}