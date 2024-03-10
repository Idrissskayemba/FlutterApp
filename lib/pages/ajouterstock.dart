import 'package:flutter/material.dart';
import 'package:stockapp/models/produit.dart';
import 'package:stockapp/models/stock.dart';
import 'package:stockapp/database/LocalDb.dart';

class ajouterStock extends StatefulWidget{
  const ajouterStock({super.key});


@override
  State<StatefulWidget> createState() {
    return ajouterStockState();
  }
}

class ajouterStockState extends State<ajouterStock>{
  TextEditingController dateController = TextEditingController();
  TextEditingController quantiteController = TextEditingController();

  final _db = LocalDb();
  bool _isAdding = false;
  String _message = "Strock ajouté avec succès !";
  IconData _icon = Icons.info;

  DateTime? selectedDate;
  int quantite = 0;
   // Variable pour le produit sélectionnée

  String? selectedProduit;
  List<Produit> _produits =[];
  //final List<Produit> produits = [];
  @override
  void initState() {
    super.initState();
    _getProduits(); 
  }

  Future<void> _getProduits() async {
    final db = LocalDb();
    final produits = await db.getAllProduits();
    setState(() {
      _produits = produits;
    });
  }
  
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text("Ajouter un stock", style: TextStyle(color: Colors.white),),
      ),

      body: Padding(
        padding: const EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
        child: ListView(
          children: <Widget> [
            

            Padding(
              padding: const EdgeInsets.all(15),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Produit',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                value: selectedProduit,
          items: _produits.map((produit) {
            return DropdownMenuItem<String>(
              value: produit.reference.toString(),
              child: Text(produit.designation),
            );
          }).toList(),
          onChanged: (value) {
            setState(() => selectedProduit = value);
            print("Produit sélectionnée: $selectedProduit");
          },
              ),
            ),
            
            

            Padding(
            padding: const EdgeInsets.all(15),
            child: InkWell(
              onTap: () async {
                final selected = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (selected != null) {
                  setState(() {
                    selectedDate = selected;
                    dateController.text = selectedDate.toString();
                  });
                }
              },
              child: IgnorePointer(
                child: TextField(
                  controller: dateController,
                  decoration: InputDecoration(
                    labelText: 'Date',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
              ),
            ),
          ),

           Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: TextEditingController(text: quantite.toString()),
                    textAlign: TextAlign.center,
                    
                    decoration: InputDecoration(
                      labelText: 'Quantité',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
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
                decoration: BoxDecoration(color: Colors.blueGrey,
                borderRadius: BorderRadius.circular(10)),
                child: TextButton(onPressed: () async {
                  if (_isAdding) return;

                          final jour = dateController.text;
                          final quantite = quantiteController.text;
                          

                          

                          setState(() {
                            _isAdding = true;
                          });

                          final stock = Stock(
                            jour: selectedDate!.toString().split(' ')[0],
                            quantite: quantite,
                            produit: selectedProduit!,
                            
                          );

                          try {
                            await _db.insertStock(stock);
                            setState(() {
                              _message = 'Stock ajouté avec succès !';
                              _icon = Icons.check_circle;
                              });
                              } catch (e) {
    setState(() {
      _message = "Échec de l'ajout du stock : $e";
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
                child: const Text("AJOUTER", style: TextStyle(color: Colors.white),))),
                  ),
              ],
            ),
            ),
          ],
        ),
      ),
    );
  }
  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}