import 'package:flutter/material.dart';
import 'package:stockapp/pages/produit.dart';
import 'package:stockapp/pages/categorie.dart';
import 'package:stockapp/pages/stock.dart';

class EcranAcceuil extends StatefulWidget{
  const EcranAcceuil({super.key});

  @override
  State<EcranAcceuil> createState() => _HomeState();
}

class _HomeState extends State<EcranAcceuil>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Row(
            children: <Widget>[
              Icon(
                Icons.inventory_2,
                color: Colors.white,
              ),
              Text(
                "StockApp",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              
            ],
          ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget> [
            Image.asset('images/image.png'),
            Container(
              height: 200,
              width: double.infinity,
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(colors: [
                  Colors.green,
                  Colors.blueGrey,
                ])
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Gerez efficacement", 
                    style: TextStyle(fontSize: 40,
                    color: Colors.white),),
                    Text("avec StockApp", style: TextStyle(fontSize: 25, color: Colors.white),),
                  ],
                ),
            ),
            Container(
              margin: EdgeInsets.all(20),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                 Expanded(
                child: Container(
                height: 100,
                decoration: BoxDecoration(color: Colors.blueGrey,
                borderRadius: BorderRadius.circular(10)),
                child: TextButton(onPressed: (){
                  debugPrint('gerer les catégories');
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                  return const ListCategorie();
                  }));
                },
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Icon(Icons.category, color: Colors.white, size: 40),
                Text("Catégories", style: TextStyle(color: Colors.white)),
                ],
                ),
                )),
                  ),
                  SizedBox(width: 20),
                 Expanded(
                child: Container(
                height: 100,
                decoration: BoxDecoration(color: Colors.blueGrey,
                borderRadius: BorderRadius.circular(10)),
                child: TextButton(onPressed: (){
                   debugPrint('gerer les catégories');
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                  return const listProduit();
                  }));
                },
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Icon(Icons.article, color: Colors.white, size: 40),
                Text("Produits", style: TextStyle(color: Colors.white)),
                ],
                ),)),
                  ),
                   SizedBox(width: 20),
                  Expanded(
                child: Container(
                height: 100,
                decoration: BoxDecoration(color: Colors.blueGrey,
                borderRadius: BorderRadius.circular(10)),
                child: TextButton(onPressed: (){
                  debugPrint('gerer le stock');
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                  return const ListStock();
                  }));
                },
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Icon(Icons.storage, color: Colors.white, size: 40),
                Text("Stock", style: TextStyle(color: Colors.white)),
                ],
                ),)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}