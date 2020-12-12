import 'dart:convert';

import 'package:flutter/material.dart';
import '../models/http_exception.dart';

import '../models/transaction.dart';
import 'package:http/http.dart' as http;
import '../widgets/new_transaction.dart';


class DailyTransactions with ChangeNotifier {
 
   List<Transaction> _userTransaction = [ ];

    final String authToken ;
    final String userId ;
    DailyTransactions(this.authToken , this.userId , this._userTransaction); 

  List<Transaction> get userTransaction {
  //    data() ;
     return [..._userTransaction] ;
  }    
                            
                                   
//   Future<void> data () async {
//  //   List<Transaction> _userTransactions = [ ];
//       var userTransaction = await SharedPreferences.getInstance();
//       Set<String> keys = userTransaction.getKeys();
//       int length = keys.length ;
//    if(length == 0){
//       return ;
//     }
//     for (int i=0 ; i< length ; i++){
//        final extractedData = json.decode(userTransaction.getString(keys.elementAt(i))) as Map<String , dynamic >;
//     Transaction newt = Transaction(
//       amount: double.parse(extractedData['amount']) ,
    
//       id: extractedData['id'],
//       title: extractedData['title'],
//       date: DateTime.parse(extractedData['date']) ,
//       );
//       _userTransaction.insert(0, newt);
//     }
//   //  notifyListeners() ;
//   }

  List<Transaction> get recentTransactions {
    return _userTransaction.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7)
        )
      );
    }).toList();

  }

  Future <void> fetchAndSetProducts() async {
   
    final url = 'https://forfeit110.firebaseio.com/dailytransactions/$userId.json?auth=$authToken';
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
        amount: prodData['amount'],
        date: DateTime.parse(prodData['date']),
        ));
      });
      _userTransaction = loadedProducts ;
      notifyListeners();
    }catch(error){
      throw error ;
    }
  }


  Future <void> addNewTransaction(String txTitle, double txAmount , DateTime chosenDate, [int index]) async {
    final url = 'https://forfeit110.firebaseio.com/dailytransactions/$userId.json?auth=$authToken' ;
    try {
      final response = await http.post(url , 
    body: json.encode({
      'title': txTitle,
      'amount': txAmount ,
      'date' : chosenDate.toIso8601String(),
  //    'creatorId' : userId,
   //   'isFavorite' : product.isFavorite,
    }), );
       final newTx = Transaction(
      id: json.decode(response.body)['name'],
     amount: txAmount, 
     title: txTitle, 
     date: chosenDate,
     );
     if(index == null){
       index = 0; 
     }
     _userTransaction.insert(index,newTx);
    notifyListeners();
    }
    catch(error){
      throw error ;
    }
   // fetchAndSetProducts() ;
      //  if(index==null){
      //    index = 0 ;
      //  }
    
    
    //  var userTransaction = await SharedPreferences.getInstance();
     
    //    final datas = json.encode({
       
    //      'id' : newid ,
    //      'title' : txTitle  ,
    //      'amount' : txAmount.toString()  ,
    //      'date' : chosenDate.toIso8601String()
    //      }  );
      //  userTransaction.setString(newid , datas) ;
     
  //      data() ;
   //     notifyListeners();
      
  }


  void startAddNewTransaction (BuildContext ctx ) {
    showModalBottomSheet(
      context: ctx ,
      builder: (_) {
        return NewTransaction(addNewTransaction);
      },
    );
  }


    Future<void> deleteTransaction(String id) async {

      final url = 'https://forfeit110.firebaseio.com/dailytransactions/$userId/$id.json?auth=$authToken' ;
      
      final existingProductIndex = _userTransaction.indexWhere((prod) => prod.id == id);
      var existingProduct = _userTransaction[existingProductIndex];
      _userTransaction.removeAt(existingProductIndex) ;
          notifyListeners() ;
  
       final response = await http.delete(url) ;
       if(response.statusCode >= 400){
      _userTransaction.insert(existingProductIndex, existingProduct);
           notifyListeners();
         throw HttpException('Could not delete Product. you might not connected to internet');
               }
       existingProduct = null ;
    //    fetchAndSetProducts();
   
   
    // var userTransaction = await SharedPreferences.getInstance();
  //    _userTransaction.removeWhere((tx) {
  //      return tx.id == id ;
  //  });
  //    data() ;
      // userTransaction.remove(id);
   //   notifyListeners() ;
}



}