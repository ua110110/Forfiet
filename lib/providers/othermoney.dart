import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/transaction.dart';
import '../widgets/new_transaction.dart';
import '../models/http_exception.dart';

class OM with ChangeNotifier {
 

   List<Transaction> _othermoney = [

  ];

   final String authToken ;
    final String userId ;
    OM(this.authToken , this.userId , this._othermoney); 

  List<Transaction> get othermoney {
     return [..._othermoney] ;
  }  

   double get totalAmount {
    double total = 0 ;
    for (int i=0 ; i < _othermoney.length ; i++) {
         total = total + _othermoney[i].amount ;
    }
    return total ;
  }


  Future <void> fetchAndSetProducts() async {
    final url = 'https://forfeit110.firebaseio.com/Other_Money/$userId.json?auth=$authToken';
    try{
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String ,dynamic> ;
       if(extractedData ==null ){
          return;
       }
      final List<Transaction> loadedProducts = [] ;
      extractedData.forEach((prodId ,  prodData){
        loadedProducts.insert(0,
        Transaction (
        id: prodId ,
        title : prodData['title'],
        amount: double.parse(prodData['amount']),
        date: DateTime.parse(prodData['date']),
        ));
      });
      _othermoney = loadedProducts ;
      notifyListeners();
    }catch(error){
      throw error ;
    }
  }


  Future<void> addNewTransaction(String txTitle, double txAmount , DateTime chosenDate, [int index])async {
   final url = 'https://forfeit110.firebaseio.com/Other_Money/$userId.json?auth=$authToken' ;
    try {
      final response = await http.post(url , 
       body: json.encode({
      'title': txTitle,
      'amount': txAmount.toString() ,
      'date' : chosenDate.toIso8601String(),
   //   'creatorId' : userId,
   //   'isFavorite' : product.isFavorite,
    }), );
       final newTx = Transaction(
      id: json.decode(response.body)['name'],
     amount: txAmount, 
     title: txTitle, 
     date: chosenDate,
     );
     if(index == null){
       index= 0 ;
     }
     _othermoney.insert(index,newTx);
    notifyListeners();
    }
    catch(error){
      throw error ;
    }
  }


  void startAddNewTransaction (BuildContext ctx) {
    showModalBottomSheet(
      context: ctx ,
      builder: (_) {
        return NewTransaction(addNewTransaction);
      },
    );
  }


 Future<void> deleteTransaction(String id) async {
  // final addin = Provider.of<RecenltyDeleted>(ctx) ;
  // final index = _userTransaction.indexWhere((test) => test.id == id) ;
  // addin.addItem(
  //   'daily', 
  //    index ,
  //   Transaction(
  //     id: _userTransaction[index].id,
  //     amount: _userTransaction[index].amount,
  //     title: _userTransaction[index].title,
  //     date: _userTransaction[index].date
  //     ),
  //     );
   //   setState(() {
  //   _mymoney.removeWhere((tx) {
 //      return tx.id == id ;
   //  });
 //  });
 //     notifyListeners() ;

 final url = 'https://forfeit110.firebaseio.com/Other_Money/$userId/$id.json?auth=$authToken' ;
      
      final existingProductIndex = _othermoney.indexWhere((prod) => prod.id == id);
      var existingProduct = _othermoney[existingProductIndex];
      _othermoney.removeAt(existingProductIndex) ;
          notifyListeners() ;
  
       final response = await http.delete(url) ;
       if(response.statusCode >= 400){
      _othermoney.insert(existingProductIndex, existingProduct);
           notifyListeners();
         throw HttpException('Could not delete Product. you might not connected to internet');
               }
       existingProduct = null ;
}



}