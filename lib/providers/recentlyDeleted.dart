import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/http_exception.dart';

import '../models/delete.dart';
import '../models/transaction.dart';
import 'package:http/http.dart' as http;

class RecenltyDeleted with ChangeNotifier {
   List<Delete> _recentlydeleted = [] ;

   final String authToken ;
    final String userId ;
    RecenltyDeleted(this.authToken , this.userId , this._recentlydeleted); 

   List<Delete> get recentlydeleted {
      return [..._recentlydeleted];
   }

   List<Transaction> list () {
     List<Transaction> lst = [];
     for(int i = 0 ; i< _recentlydeleted.length ; i++){
       Transaction item = Transaction(
         amount: _recentlydeleted[i].amount ,
         title: _recentlydeleted[i].title  ,
         date:  _recentlydeleted[i].date ,
         id: _recentlydeleted[i].id ,
       );
       lst.insert(0, item) ;
     }
     return lst ;
   }

   Future <void> fetchAndSetProducts() async {
    final url = 'https://forfeit110.firebaseio.com/Recently_Deleted/$userId.json?auth=$authToken';
    try{
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String ,dynamic> ;
       if(extractedData ==null ){
          return;
       }
       List<Delete> loadedProducts = [] ;
      extractedData.forEach((prodId , existingProduct){
        loadedProducts.insert( 0, 
        Delete (
        where: existingProduct['where'], 
        index: int.parse(existingProduct['index']), 
          date: DateTime.parse(existingProduct['date']),
          id: prodId ,
          amount: double.parse(existingProduct['amount']) ,
          title: existingProduct['title'] ,
        )
        );
      });
      _recentlydeleted = loadedProducts.reversed.toList() ;
      notifyListeners();
    }catch(error){
      throw error ;
    }
  }

   Future<void> addItem (String where , int index , Transaction info)async{
    final url = 'https://forfeit110.firebaseio.com/Recently_Deleted/$userId.json?auth=$authToken' ;
    try {
      final response = await http.post(url , 
       body: json.encode({
      'where': where,
      'index': index.toString()  ,
      'amount' : info.amount.toString() ,
      'title' : info.title ,
      'date' : info.date.toIso8601String()
  //      Transaction(
  //       amount: info.amount,
  // //      id: info.id ,
  //       title: info.title ,
  //       date: info.date ,
  //       ).toString(),
  
    }), );
     _recentlydeleted.insert(0 ,Delete(
          where : where ,
          index : index ,
          id: json.decode(response.body)['name'] ,
           amount: info.amount,
           date: info.date ,
           title: info.title,
         ),
    //    notifyListeners();
     ); 
     notifyListeners() ;
    }
    catch(error){
      throw error ;
    }
      }
   


    Future<void> deleteAll() async {
       final url = 'https://forfeit110.firebaseio.com/Recently_Deleted/$userId.json?auth=$authToken' ;
       List<Delete> existingProduct = _recentlydeleted ;
       _recentlydeleted.clear() ;
       notifyListeners() ;

       final response = await http.delete(url) ;
        if(response.statusCode >= 400){
          _recentlydeleted = existingProduct ;
           notifyListeners();
         throw HttpException('Could not delete Product. you might not connected to internet');
        }
        existingProduct = null ;
     }

     Future<void> deleteone(String id) async {
       final url = 'https://forfeit110.firebaseio.com/Recently_Deleted/$userId/$id.json?auth=$authToken' ;
       final existingProductIndex = _recentlydeleted.indexWhere((prod) => prod.id == id);
      var existingProduct = _recentlydeleted[existingProductIndex];
      _recentlydeleted.removeAt(existingProductIndex) ;
          notifyListeners() ;
   
  
       final response = await http.delete(url) ;
       if(response.statusCode >= 400){
       _recentlydeleted.insert(existingProductIndex, existingProduct);
           notifyListeners();
         throw HttpException('Could not delete Product. you might not connected to internet');
               }
       existingProduct = null ;
      
     }

     Delete recover(String id){
         int index = _recentlydeleted.indexWhere((prod) => prod.id == id); 
         return _recentlydeleted[index] ;
     }
   
}